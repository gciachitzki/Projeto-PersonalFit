import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../models/appointment_model.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final String baseUrl = 'http://localhost:3000'; // JSON Server
  final List<Appointment> _mockAppointments = []; // Lista em memória para agendamentos criados

  @override
  Future<List<Appointment>> getAppointments() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/appointments'));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => AppointmentModel.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar agendamentos');
      }
    } catch (e) {
      // Combinar agendamentos mock iniciais com os criados em memória
      final allAppointments = [..._getMockAppointments(), ..._mockAppointments];
      return allAppointments;
    }
  }

  @override
  Future<Appointment> createAppointment(Appointment appointment) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/appointments'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode((appointment as AppointmentModel).toJson()),
      );
      
      if (response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return AppointmentModel.fromJson(jsonData);
      } else {
        throw Exception('Falha ao criar agendamento');
      }
    } catch (e) {
      // Fallback: adicionar à lista em memória
      _mockAppointments.add(appointment);
      return appointment;
    }
  }

  @override
  Future<void> updateAppointmentStatus(String appointmentId, AppointmentStatus status) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/appointments/$appointmentId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'status': status.toString().split('.').last,
          'updatedAt': DateTime.now().toIso8601String(),
        }),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Falha ao atualizar status do agendamento');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar status: $e');
    }
  }

  @override
  Future<void> deleteAppointment(String appointmentId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/appointments/$appointmentId'));
      
      if (response.statusCode != 200) {
        throw Exception('Falha ao deletar agendamento');
      }
    } catch (e) {
      throw Exception('Erro ao deletar agendamento: $e');
    }
  }

  @override
  Future<List<Appointment>> getPersonalAppointments(String personalId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/appointments?personalId=$personalId'),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => AppointmentModel.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar agendamentos do personal');
      }
    } catch (e) {
      final allAppointments = [..._getMockAppointments(), ..._mockAppointments];
      return allAppointments.where((a) => a.personalId == personalId).toList();
    }
  }

  @override
  Future<List<Appointment>> getUserAppointments(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/appointments?userId=$userId'),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => AppointmentModel.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar agendamentos do usuário');
      }
    } catch (e) {
      final allAppointments = [..._getMockAppointments(), ..._mockAppointments];
      return allAppointments.where((a) => a.userId == userId).toList();
    }
  }

  // Dados mock para fallback
  List<Appointment> _getMockAppointments() {
    return [
      AppointmentModel(
        id: '1',
        personalId: '1',
        personalName: 'Amanda Costa',
        personalPhotoUrl: 'https://randomuser.me/api/portraits/women/1.jpg',
        userId: 'user1',
        userName: 'Maria Silva',
        date: DateTime.now().add(const Duration(days: 2)),
        time: '08:00',
        type: AppointmentType.inPerson,
        status: AppointmentStatus.confirmed,
        notes: 'Primeira sessão, gostaria de focar em emagrecimento',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      AppointmentModel(
        id: '2',
        personalId: '3',
        personalName: 'Juliana Ferreira',
        personalPhotoUrl: 'https://randomuser.me/api/portraits/women/3.jpg',
        userId: 'user2',
        userName: 'Ana Paula',
        date: DateTime.now().add(const Duration(days: 3)),
        time: '19:00',
        type: AppointmentType.online,
        status: AppointmentStatus.pending,
        notes: 'Sessão online, tenho equipamentos básicos em casa',
        createdAt: DateTime.now(),
      ),
    ];
  }
}

 