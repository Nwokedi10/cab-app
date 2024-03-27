import 'dart:async';

import 'package:dio/dio.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import '/src/utils/utils_barrel.dart';

///mixin for the error handler of all dio calls
///use this in your class that uses dio for network calls
///Guideline: strongly type all variables and functions

class DioErrorHandler {
  static FutureOr<T> handleDioError<T>(FutureOr<T> computation) async {
    late Failure failure;
    try {
      return await computation;
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.connectTimeout:
          failure = Failure(message: ErrorStrings.connectionTimeout);
          break;
        case DioErrorType.cancel:
          failure = Failure(message: ErrorStrings.requestCanceled);
          break;
        case DioErrorType.sendTimeout:
          failure = Failure(message: ErrorStrings.sendTimeout);
          break;
        case DioErrorType.receiveTimeout:
          failure = Failure(message: ErrorStrings.receiveTimeout);
          break;
        case DioErrorType.response:
          {
            final String message = '''
            ${e.response?.statusCode}
            ${e.response?.statusMessage}
            ${e.message}
            ${e.response.toString()}
            ''';
            failure = Failure(message: message);
            break;
          }
        case DioErrorType.other:
          failure = Failure(message: ErrorStrings.unknown);
          break;
      }

      return Future.error(failure);
    } catch (e) {
      if (e is Failure) {
        return Future.error(e);
      }
      failure = Failure(message: e.toString());
      return Future.error(failure);
    }
  }
  // static Future<T> handleError<T>(FutureOr<T> res) {
  //   final c = handleDioError(res);
  //   if (c is Failure) {
  //     return false;
  //   }
  // }
}
