import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../constants/app_config.dart';
import 'api_service.dart';

/// Exemplo de implementação do serviço de API real
/// Para usar esta implementação, substitua o MockApiService nos providers
class RealApiService implements IApiService {
  late final Dio _dio;

  RealApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: Duration(seconds: AppConfig.connectionTimeoutSeconds),
      receiveTimeout: Duration(seconds: AppConfig.receiveTimeoutSeconds),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // Adicione headers de autenticação se necessário
        // 'Authorization': 'Bearer $token',
      },
    ));

    // Interceptor para logs
    if (AppConfig.enableApiLogs) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ));
    }

    // Interceptor para tratamento de erros
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        // Tratamento personalizado de erros
        if (error.response?.statusCode == 401) {
          // Token expirado - redirecionar para login
          print('Token expirado - redirecionar para login');
        } else if (error.response?.statusCode == 403) {
          // Acesso negado
          print('Acesso negado');
        }
        handler.next(error);
      },
    ));
  }

  Future<Response> get(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> post(String endpoint, dynamic data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> put(String endpoint, dynamic data) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
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
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Erro desconhecido';
        return Exception('Erro $statusCode: $message');
      case DioExceptionType.cancel:
        return Exception('Requisição cancelada');
      case DioExceptionType.connectionError:
        return Exception('Erro de conexão - verifique sua internet');
      default:
        return Exception(AppConstants.genericErrorMessage);
    }
  }

  /// Método para configurar token de autenticação
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Método para remover token de autenticação
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
} 