import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/mock_api_service.dart';
import '../services/real_api_service.dart';
import '../services/api_service.dart';
import '../constants/app_config.dart';
import '../../modules/personals/data/datasources/personal_datasource.dart';
import '../../modules/personals/data/repositories/personal_repository_impl.dart';
import '../../modules/personals/domain/repositories/personal_repository.dart';
import '../../modules/personals/presentation/controllers/personal_controller.dart';
import '../../modules/personals/data/repositories/appointment_repository_impl.dart';
import '../../modules/personals/data/repositories/review_repository_impl.dart';
import '../../modules/personals/presentation/controllers/appointment_controller.dart';
import '../../modules/personals/presentation/controllers/review_controller.dart';

// API Service Provider
final apiServiceProvider = Provider<IApiService>((ref) {
  if (AppConfig.useRealApi) {
    return RealApiService();
  } else {
    return MockApiService();
  }
});

// DataSource Provider
final personalDataSourceProvider = Provider<PersonalDataSource>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return PersonalDataSourceImpl(apiService);
});

// Repository Provider
final personalRepositoryProvider = Provider<PersonalRepository>((ref) {
  final dataSource = ref.watch(personalDataSourceProvider);
  return PersonalRepositoryImpl(dataSource);
});

// Repository Providers
final appointmentRepositoryProvider = Provider<AppointmentRepositoryImpl>((ref) {
  return AppointmentRepositoryImpl();
});

final reviewRepositoryProvider = Provider<ReviewRepositoryImpl>((ref) {
  return ReviewRepositoryImpl();
});

// Controller Provider
final personalControllerProvider = StateNotifierProvider<PersonalController, PersonalState>((ref) {
  final repository = ref.watch(personalRepositoryProvider);
  return PersonalController(repository);
});

final appointmentControllerProvider = StateNotifierProvider<AppointmentController, AppointmentState>((ref) {
  final repository = ref.read(appointmentRepositoryProvider);
  return AppointmentController(repository);
});

final reviewControllerProvider = StateNotifierProvider<ReviewController, ReviewState>((ref) {
  final repository = ref.read(reviewRepositoryProvider);
  final personalController = ref.read(personalControllerProvider.notifier);
  return ReviewController(repository, personalController: personalController);
}); 