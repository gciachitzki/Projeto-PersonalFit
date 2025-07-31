import '../entities/appointment.dart';

abstract class AppointmentRepository {
  Future<List<Appointment>> getAppointments();
  Future<Appointment> createAppointment(Appointment appointment);
  Future<void> updateAppointmentStatus(String appointmentId, AppointmentStatus status);
  Future<void> deleteAppointment(String appointmentId);
  Future<List<Appointment>> getPersonalAppointments(String personalId);
  Future<List<Appointment>> getUserAppointments(String userId);
} 