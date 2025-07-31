import '../../domain/entities/personal.dart';
import '../../domain/entities/contact_interest.dart';
import '../../domain/repositories/personal_repository.dart';
import '../datasources/personal_datasource.dart';

class PersonalRepositoryImpl implements PersonalRepository {
  final PersonalDataSource _dataSource;

  PersonalRepositoryImpl(this._dataSource);

  @override
  Future<List<Personal>> getPersonals() async {
    try {
      final personals = await _dataSource.getPersonals();
      return personals;
    } catch (e) {
      throw Exception('Erro ao buscar personais: $e');
    }
  }

  @override
  Future<List<Personal>> searchPersonals(String query) async {
    try {
      final allPersonals = await _dataSource.getPersonals();
      final filteredPersonals = allPersonals.where((personal) {
        return personal.name.toLowerCase().contains(query.toLowerCase()) ||
               personal.specialties.any((specialty) => 
                 specialty.toLowerCase().contains(query.toLowerCase()));
      }).toList();
      return filteredPersonals;
    } catch (e) {
      throw Exception('Erro ao buscar personais: $e');
    }
  }

  @override
  Future<List<Personal>> filterPersonalsBySpecialty(String specialty) async {
    try {
      final allPersonals = await _dataSource.getPersonals();
      final filteredPersonals = allPersonals.where((personal) {
        return personal.specialties.contains(specialty);
      }).toList();
      return filteredPersonals;
    } catch (e) {
      throw Exception('Erro ao filtrar personais: $e');
    }
  }

  @override
  Future<void> sendContactInterest(ContactInterest contactInterest) async {
    try {
      await _dataSource.sendContactInterest(contactInterest);
    } catch (e) {
      throw Exception('Erro ao enviar interesse de contato: $e');
    }
  }
} 