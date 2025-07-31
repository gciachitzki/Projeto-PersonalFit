import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/review.dart';
import '../../data/models/review_model.dart';
import '../../data/repositories/review_repository_impl.dart';
import 'personal_controller.dart';

class ReviewState {
  final bool isLoading;
  final List<Review> reviews;
  final List<Review> personalReviews;
  final String? error;

  const ReviewState({
    this.isLoading = false,
    this.reviews = const [],
    this.personalReviews = const [],
    this.error,
  });

  ReviewState copyWith({
    bool? isLoading,
    List<Review>? reviews,
    List<Review>? personalReviews,
    String? error,
  }) {
    return ReviewState(
      isLoading: isLoading ?? this.isLoading,
      reviews: reviews ?? this.reviews,
      personalReviews: personalReviews ?? this.personalReviews,
      error: error,
    );
  }
}

class ReviewController extends StateNotifier<ReviewState> {
  final ReviewRepositoryImpl _repository;
  final PersonalController? _personalController;

  ReviewController(this._repository, {PersonalController? personalController}) 
      : _personalController = personalController,
        super(const ReviewState());

  Future<void> loadReviews() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final reviews = await _repository.getReviews();
      state = state.copyWith(
        isLoading: false,
        reviews: reviews,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadPersonalReviews(String personalId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final reviews = await _repository.getPersonalReviews(personalId);
      state = state.copyWith(
        isLoading: false,
        personalReviews: reviews,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createReview({
    required String personalId,
    required double rating,
    required String comment,
    List<String> photos = const [],
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final review = ReviewModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        personalId: personalId,
        userName: 'Usuário', // Mock user name
        userPhotoUrl: 'https://randomuser.me/api/portraits/men/1.jpg', // Mock user photo
        rating: rating,
        comment: comment,
        photos: photos,
        createdAt: DateTime.now(),
        verified: false,
      );

      await _repository.createReview(review);
      await loadPersonalReviews(personalId); // Recarregar avaliações do personal
      
      // Atualizar a nota do personal após criar a avaliação
      await _updatePersonalRating(personalId);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateReview(String reviewId, {
    double? rating,
    String? comment,
    List<String>? photos,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Buscar a avaliação para obter o personalId
      final review = state.personalReviews.firstWhere((r) => r.id == reviewId);
      
      await _repository.updateReview(reviewId, rating: rating, comment: comment, photos: photos);
      await loadReviews(); // Recarregar lista
      
      // Atualizar a nota do personal após atualizar a avaliação
      await _updatePersonalRating(review.personalId);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteReview(String reviewId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Buscar a avaliação para obter o personalId
      final review = state.personalReviews.firstWhere((r) => r.id == reviewId);
      
      await _repository.deleteReview(reviewId);
      await loadReviews(); // Recarregar lista
      
      // Atualizar a nota do personal após deletar a avaliação
      await _updatePersonalRating(review.personalId);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  // Calcular média de avaliações
  double calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0.0;
    final total = reviews.fold(0.0, (sum, review) => sum + review.rating);
    return total / reviews.length;
  }

  // Obter distribuição de avaliações (quantas 5 estrelas, 4 estrelas, etc.)
  Map<int, int> getRatingDistribution(List<Review> reviews) {
    final distribution = <int, int>{};
    for (int i = 1; i <= 5; i++) {
      distribution[i] = reviews.where((r) => r.rating == i).length;
    }
    return distribution;
  }

  // Obter avaliações recentes (últimos 30 dias)
  List<Review> getRecentReviews(List<Review> reviews) {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return reviews.where((review) => review.createdAt.isAfter(thirtyDaysAgo)).toList();
  }

  // Obter avaliações verificadas
  List<Review> getVerifiedReviews(List<Review> reviews) {
    return reviews.where((review) => review.verified).toList();
  }

  // Atualizar a nota do personal baseada nas avaliações
  Future<void> _updatePersonalRating(String personalId) async {
    try {
      // Recarregar avaliações do personal para ter dados atualizados
      await loadPersonalReviews(personalId);
      
      // Calcular nova média
      final newRating = calculateAverageRating(state.personalReviews);
      
      // Atualizar o personal no repositório
      await _repository.updatePersonalRating(personalId, newRating);
      
      // Atualizar o personal no controller para refletir na UI
      _personalController?.updatePersonalRating(personalId, newRating);
    } catch (e) {
      // Se falhar ao atualizar, apenas logar o erro mas não interromper o fluxo
      print('Erro ao atualizar nota do personal: $e');
    }
  }
}

 