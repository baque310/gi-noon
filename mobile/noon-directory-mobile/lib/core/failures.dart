import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/app_strings.dart';

import 'localization/language.dart';

abstract class Failure {
  Failure(this.message);

  String message;
}

class ServerFailure extends Failure {
  ServerFailure(super.errMessage);

  //to get error message from response data when an error occur
  static String _getErrorMessageFromResponse(Map<String, dynamic> data) {
    String errorMsg = AppLanguage.unexpectedErrorStr.tr;
    if (data.containsKey(AppStrings.messageKey)) {
      errorMsg = data[AppStrings.messageKey];
    }
    return errorMsg;
  }

  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(AppLanguage.unexpectedErrorStr.tr);
      case DioExceptionType.sendTimeout:
        return ServerFailure(AppLanguage.unexpectedErrorStr.tr);
      case DioExceptionType.receiveTimeout:
        return ServerFailure(AppLanguage.unexpectedErrorStr.tr);
      /*      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(dioError);*/
      case DioExceptionType.cancel:
        return ServerFailure(AppLanguage.unexpectedErrorStr.tr);
      case DioExceptionType.connectionError:
        final message = dioError.message ?? '';
        if (message.contains('SocketException') ||
            message.contains('Network is unreachable')) {
          return ServerFailure(AppLanguage.noInternetStr.tr);
        }
        return ServerFailure(AppLanguage.unexpectedErrorStr.tr);
      default:
        return ServerFailure.fromResponse(dioError);
    }
  }

  factory ServerFailure.fromResponse(DioException error) {
    if (error.response?.data is Map) {
      //get the response status code
      // final statusCode = error.response?.statusCode ?? 0;
      //to get the error message from server
      final errorMsg = _getErrorMessageFromResponse(error.response?.data);
      return ServerFailure(errorMsg);
    } else {
      return ServerFailure(AppLanguage.unexpectedErrorStr.tr);
    }
  }
}

class GeneralFailure extends Failure {
  GeneralFailure(super.message);
}
