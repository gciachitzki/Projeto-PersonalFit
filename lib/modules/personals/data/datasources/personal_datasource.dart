import 'package:dio/dio.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_config.dart';
import '../models/personal_model.dart';
import '../../domain/entities/contact_interest.dart';

abstract class PersonalDataSource {
  Future<List<PersonalModel>> getPersonals();
  Future<void> sendContactInterest(ContactInterest contactInterest);
}

class PersonalDataSourceImpl implements PersonalDataSource {
  final IApiService _apiService;

  PersonalDataSourceImpl(this._apiService);

  @override
  Future<List<PersonalModel>> getPersonals() async {
    try {
      final response = await _apiService.get(AppConstants.personalsEndpoint);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => PersonalModel.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao buscar personais');
      }
    } catch (e) {
      throw Exception('Erro ao buscar personais: $e');
    }
  }

  @override
  Future<void> sendContactInterest(ContactInterest contactInterest) async {
    try {
      if (AppConfig.useRealApi) {
        // Usar API real
        final response = await _apiService.post(
          AppConstants.contactInterestEndpoint,
          contactInterest.toJson(),
        );
        
        if (response.statusCode != 200 && response.statusCode != 201) {
          throw Exception('Erro ao enviar interesse de contato');
        }
        
        if (AppConfig.enableApiLogs) {
          print('✅ Interesse enviado com sucesso para a API: ${contactInterest.toJson()}');
        }
      } else {
        // Usar mock local
        await Future.delayed(const Duration(seconds: 2));
        print('🔄 Mock: Enviando interesse: ${contactInterest.toJson()}');
        
        if (AppConfig.enableMockErrors) {
          throw Exception('Erro simulado para teste');
        }
      }
      
    } catch (e) {
      if (AppConfig.enableApiLogs) {
        print('❌ Erro ao enviar interesse: $e');
      }
      throw Exception('Erro ao enviar interesse de contato: $e');
    }
  }
} 