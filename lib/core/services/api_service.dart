import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

abstract class IApiService {
  Future<Response> get(String endpoint);
  Future<Response> post(String endpoint, dynamic data);
}

class ApiService implements IApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Interceptor para logs
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  @override
  Future<Response> get(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Response> post(String endpoint, dynamic data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception(AppConstants.networkErrorMessage);
      case DioExceptionType.badResponse:
        return Exception('Erro ${e.response?.statusCode}: ${e.response?.statusMessage}');
      case DioExceptionType.cancel:
        return Exception('Requisição cancelada');
      default:
        return Exception(AppConstants.genericErrorMessage);
    }
  }
} 