import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart' as get_x;
import 'package:noon/controllers/login_controller.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/constant/app_strings.dart';
import 'package:noon/core/print_value.dart';

class ApiService {
  static final _apiService = ApiService._internal();

  factory ApiService() => _apiService;

  ApiService._internal();

  static late final Dio _dio;
  late LoginController loginController;
  final _box = Hive.box(AppStrings.boxKey);
  final String tokenKey = AppStrings.tokenKey;
  final String refreshKey = AppStrings.refreshToken;

  // ? Guard for refreshing token to prevent race conditions (logout by mistake)
  bool _isRefreshing = false;
  Future<String>? _refreshFuture;

  final apiKey = ApiUrls.apiKey;

  void initializeDio() {
    loginController = get_x.Get.put(LoginController());
    _dio = _init();
  }

  Dio _init() {
    dprint(_box.get(tokenKey));
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiUrls.baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
              final token = _box.get(tokenKey) as String?;
              if (token != null) {
                options.headers['Authorization'] = "Bearer $token";
              }
              options.headers['x-api-key'] = apiKey;

              dprint('========== onRequest ==========');
              dprint(tag: 'Api URL', '${options.method} -> ${options.uri}');
              dprint(tag: 'Request Headers', '${options.headers}');
              if (options.data is FormData) {
                final formData = options.data as FormData;
                final Map<String, dynamic> bodyMap = {};
                for (final field in formData.fields) {
                  bodyMap[field.key] = field.value;
                }
                for (final file in formData.files) {
                  bodyMap[file.key] = file.value.filename;
                }
                dprint(tag: 'Request Body (FormData)', bodyMap.toString());
              } else {
                dprint(tag: 'Request Body', options.data.toString());
              }

              return handler.next(options);
            },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          dprint('========== onRequestResponse ==========');
          dprint(tag: 'Api Response', '${response.data}');

          handler.next(response);
        },
        onError: (DioException e, ErrorInterceptorHandler handler) async {
          dprint('========== onRequestError ==========');
          dprint(tag: 'Request StatusCode', '${e.response?.statusCode ?? 0}');
          dprint(tag: 'Request Error', e.response?.data ?? e.error);

          // 401 error (unauthorized)
          if (e.response?.statusCode == 401) {
            try {
              String newAccessToken;

              if (_isRefreshing) {
                // Wait for the existing refresh operation
                dprint("Waiting for ongoing token refresh...");
                newAccessToken = await _refreshFuture!;
              } else {
                // Start a new refresh operation
                _isRefreshing = true;
                _refreshFuture = refreshToken();
                newAccessToken = await _refreshFuture!;
                _isRefreshing = false;
                _refreshFuture = null;
              }

              e.requestOptions.headers['Authorization'] =
                  'Bearer $newAccessToken';
              final response = await dio.fetch(e.requestOptions);
              return handler.resolve(response);
            } catch (refreshError) {
              _isRefreshing = false;
              _refreshFuture = null;
              return handler.next(e);
            }
          }
          // 404 error (resource not found)
          // if (e.response?.statusCode == 404 && loginController.isLoggedIn) {
          //   loginController.logout();
          // }
          return handler.next(e);
        },
      ),
    );
    return dio;
  }

  Future<String> refreshToken() async {
    try {
      // Retrieve the refresh token from storage
      final refreshToken = _box.get(refreshKey) as String?;
      if (refreshToken == null || refreshToken.isEmpty) {
        throw Exception("Refresh token not found or invalid.");
      }

      // Create a Dio instance with minimal configuration
      final dio = Dio(
        BaseOptions(
          baseUrl: ApiUrls.baseUrl,
          headers: {
            'Authorization': 'Bearer $refreshToken',
            'x-api-key': apiKey,
            'accept': '*/*',
          },
        ),
      );

      // Send the request to refresh the token
      final response = await dio.post(ApiUrls.refreshTokenUrl);

      // Validate the response structure
      if ((response.statusCode != 200 && response.statusCode != 201) ||
          response.data == null) {
        throw Exception(
          "Failed to refresh token. Status: ${response.statusCode}",
        );
      }

      final newAccessToken = response.data['token_access'] as String?;
      final newRefreshToken = response.data['token_refresh'] as String?;

      if (newAccessToken == null || newRefreshToken == null) {
        throw Exception("Invalid response: Missing token data.");
      }

      // Save the new tokens
      saveUserData(newAccessToken, newRefreshToken);

      return newAccessToken;
    } on DioException catch (error) {
      dprint("DioException refreshing token: ${error.message}");
      // ? Only logout if the server explicitly rejects the refresh token (Expired or Revoked)
      if (error.response?.statusCode == 401 ||
          error.response?.statusCode == 403) {
        dprint("Refresh token is invalid or expired. Logging out the user.");
        if (loginController.isLoggedIn) {
          loginController.finishLogoutProcess();
        }
      }
      rethrow;
    } catch (e, stackTrace) {
      dprint("Unexpected error refreshing token: $e");
      dprint("StackTrace: $stackTrace");
      // ? Do NOT logout for unexpected errors (e.g. network lost during refresh)
      // ? to prevent students from being logged out due to unstable internet.
      rethrow;
    }
  }

  Future<Response> post({
    required String url,
    dynamic body,
    String? token,
    Map<String, String>? queryParameters,
  }) async {
    //await _setSecurityContext();

    final response = await _dio.post(
      url,
      queryParameters: queryParameters,
      data: body,
    );
    return response;
  }

  Future<Response> patch({
    required String url,
    dynamic body,
    Map<String, String>? queryParameters,
  }) async {
    //await _setSecurityContext();
    final response = await _dio.patch(
      url,
      queryParameters: queryParameters,
      data: body,
    );
    return response;
  }

  Future<Response> get({
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    //await _setSecurityContext();
    final response = await _dio.get(
      url,
      data: body,
      queryParameters: queryParameters,
    );

    return response;
  }

  Future<Response> delete({
    required String url,
    String? token,
    Map<String, String>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    //await _setSecurityContext();

    final response = await _dio.delete(
      url,
      data: body,
      queryParameters: queryParameters,
    );
    return response;
  }

  void saveUserData(String? token, String refreshToken) async {
    await _box.put(AppStrings.tokenKey, token);
    await _box.put(AppStrings.refreshToken, refreshToken);
  }
}
