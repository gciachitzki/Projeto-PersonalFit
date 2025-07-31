import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/contact_confirmation.dart';
import '../../../../core/providers/providers.dart';
import '../controllers/personal_controller.dart';
import '../../domain/entities/personal.dart';
import '../../domain/entities/contact_interest.dart';
import '../../domain/entities/appointment.dart';

class ContactInterestDialog extends ConsumerStatefulWidget {
  final Personal personal;

  const ContactInterestDialog({
    super.key,
    required this.personal,
  });

  @override
  ConsumerState<ContactInterestDialog> createState() => _ContactInterestDialogState();
}

class _ContactInterestDialogState extends ConsumerState<ContactInterestDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedModality = 'presencial';
  String _selectedFrequency = '2x';
  double _estimatedPrice = 0;

  final Map<String, String> _modalities = {
    'presencial': 'Presencial',
    'online': 'Online',
  };

  final Map<String, String> _frequencies = {
    '1x': '1x por semana',
    '2x': '2x por semana',
    '3x': '3x por semana',
    '4x': '4x por semana',
    '5x': '5x por semana',
  };

  @override
  void initState() {
    super.initState();
    _calculateEstimatedPrice();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _calculateEstimatedPrice() {
    final basePrice = widget.personal.price;
    final frequencyMultiplier = _getFrequencyMultiplier(_selectedFrequency);
    final modalityMultiplier = _getModalityMultiplier(_selectedModality);
    
    setState(() {
      _estimatedPrice = basePrice * frequencyMultiplier * modalityMultiplier * 4; // 4 semanas
    });
  }

  double _getFrequencyMultiplier(String frequency) {
    switch (frequency) {
      case '1x': return 1;
      case '2x': return 2;
      case '3x': return 3;
      case '4x': return 4;
      case '5x': return 5;
      default: return 2;
    }
  }

  double _getModalityMultiplier(String modality) {
    switch (modality) {
      case 'online': return 0.8; // 20% desconto se for online
      default: return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(personalControllerProvider);
    final controller = ref.read(personalControllerProvider.notifier);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
                  child: _buildDialogContent(state, controller),
                ),
        ),
      ),
    );
  }

  Widget _buildDialogContent(PersonalState state, PersonalController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.personal.photoUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.textLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.person,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contratar ${widget.personal.name}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    widget.personal.formattedPrice,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // nome
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Seu nome',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira seu nome';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        // modalidade
        const Text(
          'Modalidade',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedModality,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          items: _modalities.entries.map((entry) {
            return DropdownMenuItem(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedModality = value!;
              _calculateEstimatedPrice();
            });
          },
        ),
        const SizedBox(height: 16),
        // frequência
        const Text(
          'Frequência',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedFrequency,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          items: _frequencies.entries.map((entry) {
            return DropdownMenuItem(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedFrequency = value!;
              _calculateEstimatedPrice();
            });
          },
        ),
        const SizedBox(height: 24),
        // valor estimado por mês
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Valor estimado por mês:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                'R\$ ${_estimatedPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // acão do botão
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: state.isSendingInterest
                    ? null
                    : () => _submitInterest(controller),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.surface,
                ),
                child: state.isSendingInterest
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.surface),
                        ),
                      )
                    : const Text('Enviar Interesse'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _submitInterest(PersonalController controller) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final contactInterest = ContactInterest(
        personalId: widget.personal.id,
        modality: _selectedModality,
        frequency: _selectedFrequency,
        userName: _nameController.text.trim(),
        estimatedPrice: _estimatedPrice,
      );

      await controller.sendContactInterest(contactInterest);

      if (mounted) {
        final state = ref.read(personalControllerProvider);
        
        if (state.interestSent) {
          await _createAutomaticAppointment();
          
          Navigator.pop(context);
          _showSuccessDialog();
          controller.resetInterestSent();
        } else if (state.error != null) {
          _showErrorDialog(state.error!);
          controller.clearError();
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Erro inesperado: ${e.toString()}');
      }
    }
  }

  Future<void> _createAutomaticAppointment() async {
    try {
      final appointmentController = ref.read(appointmentControllerProvider.notifier);
      
      // Determinar o tipo de sessão baseado na modalidade
      AppointmentType appointmentType;
      switch (_selectedModality) {
        case 'online':
          appointmentType = AppointmentType.online;
          break;
        case 'presencial':
        default:
          appointmentType = AppointmentType.inPerson;
          break;
      }

      // Encontrar a próxima data disponível
      final nextAvailableDate = _findNextAvailableDate();
      
      // Encontrar o primeiro horário disponível
      final availableHours = widget.personal.getAvailableHoursForDay(
        _getDayName(nextAvailableDate.weekday)
      );
      final firstAvailableTime = availableHours.isNotEmpty ? availableHours.first : '08:00';

      // Criar o agendamento
      await appointmentController.createAppointment(
        personalId: widget.personal.id,
        personalName: widget.personal.name,
        personalPhotoUrl: widget.personal.photoUrl,
        date: nextAvailableDate,
        time: firstAvailableTime,
        type: appointmentType,
        notes: 'interesse: ${_selectedFrequency} por semana.',
      );
    } catch (e) {
      // Se falhar ao criar agendamento, apenas logar o erro mas não interromper o fluxo
      print('Erro ao criar agendamento automático: $e');
    }
  }

  DateTime _findNextAvailableDate() {
    final now = DateTime.now();
    final daysOfWeek = ['segunda', 'terça', 'quarta', 'quinta', 'sexta', 'sábado', 'domingo'];
    
    // Procurar a próxima data disponível nos próximos 14 dias
    for (int i = 1; i <= 14; i++) {
      final date = now.add(Duration(days: i));
      final dayName = daysOfWeek[date.weekday - 1];
      
      if (widget.personal.availableDays.contains(dayName)) {
        return date;
      }
    }
    
    // Se não encontrar, retornar amanhã
    return now.add(const Duration(days: 1));
  }

  String _getDayName(int weekday) {
    const days = ['segunda', 'terça', 'quarta', 'quinta', 'sexta', 'sábado', 'domingo'];
    return days[weekday - 1];
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ContactConfirmation(
        personalName: widget.personal.name,
        onClose: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text('Erro ao enviar interesse: $error'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
} 