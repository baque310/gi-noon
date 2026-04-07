import 'package:dio/dio.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/print_value.dart';

class ApiService {
  static final _apiService = ApiService._internal();

  factory ApiService() => _apiService;

  ApiService._internal();

  static late final Dio _dio;

  final apiKey = ApiUrls.apiKey;

  void initializeDio() {
    _dio = _init();
  }

  Dio _init() {
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
              options.headers['x-api-key'] = apiKey;

              dprint('========== onRequest ==========');
              dprint(tag: 'Api URL', '${options.method} -> ${options.uri}');
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
          return handler.next(e);
        },
      ),
    );
    return dio;
  }

  Future<Response> post({
    required String url,
    dynamic body,
    String? token,
    Map<String, String>? queryParameters,
  }) async {
    final response = await _dio.post(
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
    final response = await _dio.delete(
      url,
      data: body,
      queryParameters: queryParameters,
    );
    return response;
  }
}
