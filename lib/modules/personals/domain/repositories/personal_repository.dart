import '../entities/personal.dart';
import '../entities/contact_interest.dart';

abstract class PersonalRepository {
  Future<List<Personal>> getPersonals();
  Future<List<Personal>> searchPersonals(String query);
  Future<List<Personal>> filterPersonalsBySpecialty(String specialty);
  Future<void> sendContactInterest(ContactInterest contactInterest);
} 