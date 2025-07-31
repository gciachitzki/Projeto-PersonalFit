import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/rating_widget.dart';
import '../../../../core/providers/providers.dart';
import '../../domain/entities/personal.dart';
import '../../domain/entities/review.dart';
import '../widgets/review_card.dart';
import '../widgets/review_form_dialog.dart';

class ReviewsPage extends ConsumerStatefulWidget {
  final Personal personal;

  const ReviewsPage({
    super.key,
    required this.personal,
  });

  @override
  ConsumerState<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends ConsumerState<ReviewsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reviewControllerProvider.notifier).loadPersonalReviews(widget.personal.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reviewState = ref.watch(reviewControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Avaliações'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showReviewForm(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header com estatísticas
          _buildReviewsHeader(reviewState.personalReviews)
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: -0.3, duration: 400.ms),
          
          // Lista de avaliações
          Expanded(
            child: reviewState.isLoading
                ? _buildLoadingList()
                : reviewState.error != null
                    ? _buildErrorWidget(reviewState.error!)
                    : reviewState.personalReviews.isEmpty
                        ? _buildEmptyWidget()
                        : _buildReviewsList(reviewState.personalReviews),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsHeader(List<Review> reviews) {
    final averageRating = reviews.isNotEmpty 
        ? reviews.fold(0.0, (sum, review) => sum + review.rating) / reviews.length
        : 0.0;
    
    final ratingDistribution = _getRatingDistribution(reviews);
    final totalReviews = reviews.length;

    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
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
      child: Column(
        children: [
          // Rating geral
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    averageRating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  RatingWidget(
                    rating: averageRating,
                    size: 20,
                    showText: false,
                  ),
                  Text(
                    '$totalReviews avaliações',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: List.generate(5, (index) {
                    final rating = 5 - index;
                    final count = ratingDistribution[rating] ?? 0;
                    final percentage = totalReviews > 0 ? (count / totalReviews) : 0.0;
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Text(
                            '$rating',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: percentage,
                              backgroundColor: AppColors.textLight.withOpacity(0.3),
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.rating),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$count',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Botão para adicionar avaliação
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showReviewForm(context),
              icon: const Icon(Icons.rate_review),
              label: const Text('Avaliar Personal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
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
            'Erro ao carregar avaliações',
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
              ref.read(reviewControllerProvider.notifier).clearError();
              ref.read(reviewControllerProvider.notifier).loadPersonalReviews(widget.personal.id);
            },
            child: const Text('Tentar Novamente'),
          ),
        ],
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
              Icons.rate_review_outlined,
              size: 64,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Nenhuma avaliação ainda',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Seja o primeiro a avaliar este personal!',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showReviewForm(context),
            icon: const Icon(Icons.rate_review),
            label: const Text('Avaliar Agora'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsList(List<Review> reviews) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ReviewCard(
            review: review,
            onTap: () {
              // Mostrar detalhes da avaliação se necessário
            },
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: (index * 100).ms)
              .slideX(begin: 0.3, duration: 400.ms, delay: (index * 100).ms),
        );
      },
    );
  }

  void _showReviewForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ReviewFormDialog(
        personal: widget.personal,
        onReviewSubmitted: () {
          ref.read(reviewControllerProvider.notifier).loadPersonalReviews(widget.personal.id);
        },
      ),
    );
  }

  Map<int, int> _getRatingDistribution(List<Review> reviews) {
    final distribution = <int, int>{};
    for (int i = 1; i <= 5; i++) {
      distribution[i] = reviews.where((r) => r.rating == i).length;
    }
    return distribution;
  }
} 