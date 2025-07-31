import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_colors.dart';

class StatsHeader extends StatelessWidget {
  final int totalPersonals;
  final int availablePersonals;
  final double averageRating;

  const StatsHeader({
    super.key,
    required this.totalPersonals,
    required this.availablePersonals,
    required this.averageRating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryLight,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                icon: Icons.people,
                value: totalPersonals.toString(),
                label: 'Total',
                delay: 0,
              ),
              _buildStatItem(
                icon: Icons.check_circle,
                value: availablePersonals.toString(),
                label: 'Disponíveis',
                delay: 200,
              ),
              _buildStatItem(
                icon: Icons.star,
                value: averageRating.toStringAsFixed(1),
                label: 'Avaliação',
                delay: 400,
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 16,
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Encontre o personal ideal!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 600.ms)
              .slideY(begin: 0.3, duration: 600.ms, delay: 600.ms),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 800.ms)
        .slideY(begin: -0.3, duration: 800.ms);
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required int delay,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 16,
          ),
        )
            .animate()
            .scale(duration: 400.ms, delay: delay.ms, curve: Curves.elasticOut),
        
        SizedBox(height: 4),
        
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms, delay: (delay + 200).ms),
        
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms, delay: (delay + 400).ms),
      ],
    );
  }
} 