import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../constants/app_colors.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final double size;
  final bool showText;
  final bool allowHalfRating;
  final void Function(double)? onRatingChanged;

  const RatingWidget({
    super.key,
    required this.rating,
    this.size = 20,
    this.showText = false,
    this.allowHalfRating = false,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RatingBar.builder(
          initialRating: rating,
          minRating: 0,
          maxRating: 5,
          allowHalfRating: allowHalfRating,
          itemCount: 5,
          itemSize: size,
          itemBuilder: (context, index) {
            return Icon(
              Icons.star,
              color: AppColors.rating,
            );
          },
          onRatingUpdate: onRatingChanged ?? (rating) {},
          ignoreGestures: onRatingChanged == null,
        ),
        if (showText) ...[
          const SizedBox(width: 8),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.6,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ],
    );
  }
}

class RatingBadge extends StatelessWidget {
  final double rating;
  final double size;

  const RatingBadge({
    super.key,
    required this.rating,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.rating.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.rating.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: size,
            color: AppColors.rating,
          ),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.7,
              fontWeight: FontWeight.w600,
              color: AppColors.rating,
            ),
          ),
        ],
      ),
    );
  }
} 