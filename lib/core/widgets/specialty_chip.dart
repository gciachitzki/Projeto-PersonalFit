import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_colors.dart';

class SpecialtyChip extends StatelessWidget {
  final String specialty;
  final bool isSelected;
  final VoidCallback? onTap;

  const SpecialtyChip({
    super.key,
    required this.specialty,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primaryLight,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.textLight,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          specialty,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      )
          .animate(target: isSelected ? 1 : 0)
          .scale(
            duration: 200.ms,
            curve: Curves.easeInOut,
            begin: const Offset(1, 1),
            end: const Offset(1.05, 1.05),
          ),
    );
  }
}

class SpecialtyChipGroup extends StatelessWidget {
  final List<String> specialties;
  final String? selectedSpecialty;
  final Function(String) onSpecialtySelected;

  const SpecialtyChipGroup({
    super.key,
    required this.specialties,
    this.selectedSpecialty,
    required this.onSpecialtySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: specialties
          .map(
            (specialty) => SpecialtyChip(
              specialty: specialty,
              isSelected: selectedSpecialty == specialty,
              onTap: () => onSpecialtySelected(specialty),
            )
                .animate(delay: (specialties.indexOf(specialty) * 50).ms)
                .fadeIn(duration: 400.ms, curve: Curves.easeOut)
                .slideX(
                  begin: 0.3,
                  duration: 400.ms,
                  curve: Curves.easeOut,
                ),
          )
          .toList(),
    );
  }
} 