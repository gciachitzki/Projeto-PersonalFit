import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../constants/app_config.dart';
import 'api_service.dart';

class MockApiService implements IApiService {
  final List<Map<String, dynamic>> _mockPersonals = [
  {
    "id": "1",
    "name": "Amanda Costa",
    "bio": "Especialista em emagrecimento feminino.",
    "specialties": [
      "Emagrecimento",
      "Funcional"
    ],
    "rating": 4.8,
    "city": "Goiânia",
    "state": "GO",
    "photoUrl": "https://randomuser.me/api/portraits/women/1.jpg",
    "whatsapp": "62988888888",
    "price": 100
  },
  {
    "id": "2",
    "name": "Carlos Eduardo",
    "bio": "Focado em hipertrofia masculina e treinos intensivos.",
    "specialties": [
      "Hipertrofia",
      "Musculação"
    ],
    "rating": 4.6,
    "city": "São Paulo",
    "state": "SP",
    "photoUrl": "https://randomuser.me/api/portraits/men/2.jpg",
    "whatsapp": "11998765432",
    "price": 120
  },
  {
    "id": "3",
    "name": "Juliana Ferreira",
    "bio": "Atendimento online e personalizado para mulheres.",
    "specialties": [
      "Treinamento Online",
      "Funcional",
      "Emagrecimento"
    ],
    "rating": 4.9,
    "city": "Belo Horizonte",
    "state": "MG",
    "photoUrl": "https://randomuser.me/api/portraits/women/3.jpg",
    "whatsapp": "31991234567",
    "price": 90
  }
  ];

  @override
  Future<Response> get(String endpoint) async {
    // Simular delay de rede
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Simular erro ocasional (5% de chance) - só se habilitado
    if (AppConfig.enableMockErrors && Random().nextDouble() < 0.05) {
      throw DioException(
        requestOptions: RequestOptions(path: endpoint),
        type: DioExceptionType.connectionTimeout,
      );
    }

    if (endpoint == AppConstants.personalsEndpoint) {
      return Response(
        requestOptions: RequestOptions(path: endpoint),
        data: _mockPersonals,
        statusCode: 200,
      );
    }

    throw DioException(
      requestOptions: RequestOptions(path: endpoint),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: RequestOptions(path: endpoint),
        statusCode: 404,
      ),
    );
  }

  @override
  Future<Response> post(String endpoint, dynamic data) async {
    // Simular delay de rede
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Simular erro ocasional (10% de chance) - só se habilitado
    if (AppConfig.enableMockErrors && Random().nextDouble() < 0.10) {
      throw DioException(
        requestOptions: RequestOptions(path: endpoint),
        type: DioExceptionType.connectionTimeout,
      );
    }

    if (endpoint == AppConstants.contactInterestEndpoint) {
      // Validar dados recebidos
      if (data['personalId'] == null || data['userName'] == null) {
        throw DioException(
          requestOptions: RequestOptions(path: endpoint),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: endpoint),
            statusCode: 400,
            data: {'error': 'Dados inválidos'},
          ),
        );
      }

      return Response(
        requestOptions: RequestOptions(path: endpoint),
        data: {
          'success': true,
          'message': 'Interesse registrado com sucesso',
          'data': data,
        },
        statusCode: 201,
      );
    }

    throw DioException(
      requestOptions: RequestOptions(path: endpoint),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: RequestOptions(path: endpoint),
        statusCode: 404,
      ),
    );
  }
} 