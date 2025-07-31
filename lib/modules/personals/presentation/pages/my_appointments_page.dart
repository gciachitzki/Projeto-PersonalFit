import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/providers.dart';
import '../../domain/entities/appointment.dart';
import '../controllers/appointment_controller.dart';
import '../widgets/appointment_card.dart';

class MyAppointmentsPage extends ConsumerStatefulWidget {
  const MyAppointmentsPage({super.key});

  @override
  ConsumerState<MyAppointmentsPage> createState() => _MyAppointmentsPageState();
}

class _MyAppointmentsPageState extends ConsumerState<MyAppointmentsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appointmentControllerProvider.notifier).loadAppointments();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appointmentState = ref.watch(appointmentControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Meus Agendamentos'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'Próximo'),
            Tab(text: 'Pendente'),
            Tab(text: 'Histórico'),
          ],
        ),
      ),
      body: appointmentState.isLoading
          ? _buildLoadingWidget()
          : appointmentState.error != null
              ? _buildErrorWidget(appointmentState.error!)
              : _buildTabBarView(appointmentState),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Erro ao carregar agendamentos',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: const TextStyle(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(appointmentControllerProvider.notifier).clearError();
              ref.read(appointmentControllerProvider.notifier).loadAppointments();
            },
            child: const Text('Tentar Novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarView(AppointmentState state) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildAppointmentsList(_getNextAppointments(state.appointments)),
        _buildAppointmentsList(_getPendingAppointments(state.appointments)),
        _buildAppointmentsList(_getHistoricalAppointments(state.appointments)),
      ],
    );
  }

  List<Appointment> _getNextAppointments(List<Appointment> appointments) {
    final now = DateTime.now();
    return appointments.where((appointment) {
      final appointmentDateTime = DateTime(
        appointment.date.year, appointment.date.month, appointment.date.day,
        int.parse(appointment.time.split(':')[0]),
        int.parse(appointment.time.split(':')[1]),
      );
      return appointmentDateTime.isAfter(now) && 
             appointment.status == AppointmentStatus.confirmed;
    }).toList();
  }

  List<Appointment> _getPendingAppointments(List<Appointment> appointments) {
    return appointments.where((appointment) {
      return appointment.status == AppointmentStatus.pending;
    }).toList();
  }

  List<Appointment> _getHistoricalAppointments(List<Appointment> appointments) {
    // Incluir todos os agendamentos na aba histórico
    return appointments;
  }

  Widget _buildAppointmentsList(List<Appointment> appointments) {
    if (appointments.isEmpty) {
      return _buildEmptyWidget();
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(appointmentControllerProvider.notifier).loadAppointments();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppointmentCard(
              appointment: appointment,
              onTap: () {
                // Mostrar detalhes do agendamento
              },
              onCancel: appointment.canBeCancelled
                  ? () => _showCancelDialog(appointment)
                  : null,
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: (index * 100).ms)
                .slideX(begin: 0.3, duration: 400.ms, delay: (index * 100).ms),
          );
        },
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.textLight.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Nenhum agendamento encontrado',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Agende sua primeira sessão com um personal!',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Agendamento'),
        content: Text(
          'Tem certeza que deseja cancelar o agendamento com ${appointment.personalName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Não'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelAppointment(appointment.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sim, Cancelar'),
          ),
        ],
      ),
    );
  }

  void _cancelAppointment(String appointmentId) async {
    await ref.read(appointmentControllerProvider.notifier).cancelAppointment(appointmentId);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agendamento cancelado com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
} 