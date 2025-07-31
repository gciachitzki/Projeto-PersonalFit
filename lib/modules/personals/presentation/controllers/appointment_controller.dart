import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/appointment.dart';
import '../../data/models/appointment_model.dart';
import '../../data/repositories/appointment_repository_impl.dart';

class AppointmentState {
  final bool isLoading;
  final List<Appointment> appointments;
  final List<Appointment> upcomingAppointments;
  final List<Appointment> pastAppointments;
  final String? error;

  const AppointmentState({
    this.isLoading = false,
    this.appointments = const [],
    this.upcomingAppointments = const [],
    this.pastAppointments = const [],
    this.error,
  });

  AppointmentState copyWith({
    bool? isLoading,
    List<Appointment>? appointments,
    List<Appointment>? upcomingAppointments,
    List<Appointment>? pastAppointments,
    String? error,
  }) {
    return AppointmentState(
      isLoading: isLoading ?? this.isLoading,
      appointments: appointments ?? this.appointments,
      upcomingAppointments: upcomingAppointments ?? this.upcomingAppointments,
      pastAppointments: pastAppointments ?? this.pastAppointments,
      error: error,
    );
  }
}

class AppointmentController extends StateNotifier<AppointmentState> {
  final AppointmentRepositoryImpl _repository;

  AppointmentController(this._repository) : super(const AppointmentState());

  Future<void> loadAppointments() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final appointments = await _repository.getAppointments();
      final upcoming = appointments.where((a) => a.isUpcoming).toList();
      final past = appointments.where((a) => a.isPast).toList();
      
      state = state.copyWith(
        isLoading: false,
        appointments: appointments,
        upcomingAppointments: upcoming,
        pastAppointments: past,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createAppointment({
    required String personalId,
    required String personalName,
    required String personalPhotoUrl,
    required DateTime date,
    required String time,
    required AppointmentType type,
    String? notes,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final appointment = AppointmentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        personalId: personalId,
        personalName: personalName,
        personalPhotoUrl: personalPhotoUrl,
        userId: 'user1', // Mock user ID
        userName: 'Usuário', // Mock user name
        date: date,
        time: time,
        type: type,
        notes: notes,
        createdAt: DateTime.now(),
      );

      await _repository.createAppointment(appointment);
      await loadAppointments(); // Recarregar lista
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateAppointmentStatus(String appointmentId, AppointmentStatus status) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _repository.updateAppointmentStatus(appointmentId, status);
      await loadAppointments(); // Recarregar lista
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> cancelAppointment(String appointmentId) async {
    await updateAppointmentStatus(appointmentId, AppointmentStatus.cancelled);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  // Verificar se um horário está disponível
  bool isTimeAvailable(String personalId, DateTime date, String time) {
    final conflictingAppointments = state.appointments.where((appointment) {
      return appointment.personalId == personalId &&
             appointment.date.year == date.year &&
             appointment.date.month == date.month &&
             appointment.date.day == date.day &&
             appointment.time == time &&
             appointment.status != AppointmentStatus.cancelled;
    }).toList();

    return conflictingAppointments.isEmpty;
  }

  // Obter próximos agendamentos (próximos 7 dias)
  List<Appointment> getNextWeekAppointments() {
    final now = DateTime.now();
    final nextWeek = now.add(const Duration(days: 7));
    
    return state.appointments.where((appointment) {
      return appointment.date.isAfter(now) && 
             appointment.date.isBefore(nextWeek) &&
             appointment.status != AppointmentStatus.cancelled;
    }).toList();
  }
}

 