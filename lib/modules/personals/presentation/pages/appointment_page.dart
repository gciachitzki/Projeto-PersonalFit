import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/providers.dart';
import '../../domain/entities/personal.dart';
import '../../domain/entities/appointment.dart';
import '../controllers/appointment_controller.dart';

class AppointmentPage extends ConsumerStatefulWidget {
  final Personal personal;

  const AppointmentPage({
    super.key,
    required this.personal,
  });

  @override
  ConsumerState<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends ConsumerState<AppointmentPage> {
  DateTime? selectedDate;
  String? selectedTime;
  AppointmentType selectedType = AppointmentType.inPerson;
  final TextEditingController _notesController = TextEditingController();

  final List<String> _daysOfWeek = [
    'segunda', 'terça', 'quarta', 'quinta', 'sexta', 'sábado', 'domingo'
  ];

  final List<String> _timeSlots = [
    '06:00', '07:00', '08:00', '09:00', '10:00', '17:00', '18:00', '19:00', '20:00'
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appointmentState = ref.watch(appointmentControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Agendar Sessão'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card do Personal
            _buildPersonalCard()
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: -0.3, duration: 400.ms),
            
            const SizedBox(height: 24),
            
            // Tipo de Sessão
            _buildSessionTypeSelector()
                .animate()
                .fadeIn(duration: 400.ms, delay: 200.ms)
                .slideY(begin: -0.3, duration: 400.ms, delay: 200.ms),
            
            const SizedBox(height: 24),
            
            // Seleção de Data
            _buildDateSelector()
                .animate()
                .fadeIn(duration: 400.ms, delay: 400.ms)
                .slideY(begin: -0.3, duration: 400.ms, delay: 400.ms),
            
            const SizedBox(height: 24),
            
            // Seleção de Horário
            if (selectedDate != null)
              _buildTimeSelector()
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 600.ms)
                  .slideY(begin: -0.3, duration: 400.ms, delay: 600.ms),
            
            const SizedBox(height: 24),
            
            // Campo de Observações
            _buildNotesField()
                .animate()
                .fadeIn(duration: 400.ms, delay: 800.ms)
                .slideY(begin: -0.3, duration: 400.ms, delay: 800.ms),
            
            const SizedBox(height: 32),
            
            // Botão de Agendamento
            _buildScheduleButton(appointmentState)
                .animate()
                .fadeIn(duration: 400.ms, delay: 1000.ms)
                .slideY(begin: 0.3, duration: 400.ms, delay: 1000.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(widget.personal.photoUrl),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.personal.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.personal.specialties.join(', '),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.personal.formattedPrice,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de Sessão',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTypeCard(
                type: AppointmentType.inPerson,
                title: 'Presencial',
                icon: Icons.fitness_center,
                description: 'Na academia',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTypeCard(
                type: AppointmentType.online,
                title: 'Online',
                icon: Icons.videocam,
                description: 'Por vídeo',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTypeCard(
                type: AppointmentType.home,
                title: 'Domiciliar',
                icon: Icons.home,
                description: 'Em casa',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeCard({
    required AppointmentType type,
    required String title,
    required IconData icon,
    required String description,
  }) {
    final isSelected = selectedType == type;
    
    return GestureDetector(
      onTap: () => setState(() => selectedType = type),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.textLight,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            Text(
              description,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white70 : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecionar Data',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 14, // Próximos 14 dias
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index));
              final dayName = _daysOfWeek[date.weekday - 1];
              final isAvailable = widget.personal.availableDays.contains(dayName);
              final isSelected = selectedDate?.year == date.year &&
                               selectedDate?.month == date.month &&
                               selectedDate?.day == date.day;
              
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: isAvailable ? () => setState(() => selectedDate = date) : null,
                  child: Container(
                    width: 70,
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppColors.primary 
                          : (isAvailable ? AppColors.surface : AppColors.textLight.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected 
                            ? AppColors.primary 
                            : (isAvailable ? AppColors.textLight : Colors.transparent),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getDayName(date.weekday),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isSelected 
                                ? Colors.white 
                                : (isAvailable ? AppColors.textPrimary : AppColors.textSecondary),
                          ),
                        ),
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected 
                                ? Colors.white 
                                : (isAvailable ? AppColors.textPrimary : AppColors.textSecondary),
                          ),
                        ),
                        Text(
                          _getMonthName(date.month),
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected 
                                ? Colors.white70 
                                : (isAvailable ? AppColors.textSecondary : AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelector() {
    final availableHours = widget.personal.getAvailableHoursForDay(
      _daysOfWeek[selectedDate!.weekday - 1]
    );
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecionar Horário',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _timeSlots.map((time) {
            final isAvailable = availableHours.contains(time);
            final isSelected = selectedTime == time;
            
            return GestureDetector(
              onTap: isAvailable ? () => setState(() => selectedTime = time) : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.primary 
                      : (isAvailable ? AppColors.surface : AppColors.textLight.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected 
                        ? AppColors.primary 
                        : (isAvailable ? AppColors.textLight : Colors.transparent),
                  ),
                ),
                child: Text(
                  time,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isSelected 
                        ? Colors.white 
                        : (isAvailable ? AppColors.textPrimary : AppColors.textSecondary),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Observações (opcional)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Ex: Primeira sessão, tenho lesão no joelho, objetivo é emagrecimento...',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleButton(AppointmentState state) {
    final canSchedule = selectedDate != null && selectedTime != null;
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canSchedule && !state.isLoading ? _scheduleAppointment : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: state.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Agendar Sessão',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  void _scheduleAppointment() async {
    final controller = ref.read(appointmentControllerProvider.notifier);
    
    await controller.createAppointment(
      personalId: widget.personal.id,
      personalName: widget.personal.name,
      personalPhotoUrl: widget.personal.photoUrl,
      date: selectedDate!,
      time: selectedTime!,
      type: selectedType,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sessão agendada com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  String _getDayName(int weekday) {
    const days = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
    ];
    return months[month - 1];
  }
} 