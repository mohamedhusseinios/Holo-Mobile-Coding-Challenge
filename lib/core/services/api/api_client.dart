import 'package:dio/dio.dart';

import '../../constants/app_constants.dart';
import '../../errors/app_exception.dart';
import '../../utils/typedefs.dart';

class ApiClient {
  ApiClient({Dio? dio}) : _dio = dio ?? Dio(_defaultOptions);

  final Dio _dio;

  static final BaseOptions _defaultOptions = BaseOptions(
    baseUrl: AppConstants.apiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
    responseType: ResponseType.json,
  );

  Future<JsonMap> getJson(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<JsonMap>(
        path,
        queryParameters: queryParameters,
      );
      final data = response.data;
      if (data == null) {
        throw AppException(message: 'Empty response body for $path');
      }
      return data;
    } on DioException catch (error) {
      throw AppException(
        message: error.message ?? 'Network error',
        statusCode: error.response?.statusCode,
        cause: error,
      );
    }
  }

  Future<List<JsonMap>> getJsonList(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        path,
        queryParameters: queryParameters,
      );
      final data = response.data;
      if (data == null) {
        throw AppException(message: 'Empty response body for $path');
      }
      return data.cast<JsonMap>();
    } on DioException catch (error) {
      throw AppException(
        message: error.message ?? 'Network error',
        statusCode: error.response?.statusCode,
        cause: error,
      );
    }
  }
}
