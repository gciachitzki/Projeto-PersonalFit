import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';
import '../models/review_model.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final String baseUrl = 'http://localhost:3000'; // JSON Server
  final List<Review> _mockReviews = []; // Lista em memória para avaliações criadas

  @override
  Future<List<Review>> getReviews() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/reviews'));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => ReviewModel.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar avaliações');
      }
    } catch (e) {
      // Fallback para dados mock em caso de erro
      return _getMockReviews();
    }
  }

  @override
  Future<Review> createReview(Review review) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reviews'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode((review as ReviewModel).toJson()),
      );
      
      if (response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return ReviewModel.fromJson(jsonData);
      } else {
        throw Exception('Falha ao criar avaliação');
      }
    } catch (e) {
      // Fallback: adicionar à lista em memória
      _mockReviews.add(review);
      return review;
    }
  }

  @override
  Future<void> updateReview(String reviewId, {double? rating, String? comment, List<String>? photos}) async {
    try {
      final updateData = <String, dynamic>{};
      if (rating != null) updateData['rating'] = rating;
      if (comment != null) updateData['comment'] = comment;
      if (photos != null) updateData['photos'] = photos;
      
      final response = await http.patch(
        Uri.parse('$baseUrl/reviews/$reviewId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updateData),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Falha ao atualizar avaliação');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar avaliação: $e');
    }
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/reviews/$reviewId'));
      
      if (response.statusCode != 200) {
        throw Exception('Falha ao deletar avaliação');
      }
    } catch (e) {
      throw Exception('Erro ao deletar avaliação: $e');
    }
  }

  @override
  Future<List<Review>> getPersonalReviews(String personalId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reviews?personalId=$personalId'),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => ReviewModel.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar avaliações do personal');
      }
    } catch (e) {
      // Combinar avaliações mock iniciais com as criadas em memória
      final allReviews = [..._getMockReviews(), ..._mockReviews];
      return allReviews.where((r) => r.personalId == personalId).toList();
    }
  }

  @override
  Future<List<Review>> getUserReviews(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reviews?userId=$userId'),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => ReviewModel.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar avaliações do usuário');
      }
    } catch (e) {
      return _getMockReviews().where((r) => r.userName == 'Usuário').toList();
    }
  }

  @override
  Future<void> updatePersonalRating(String personalId, double newRating) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/personals/$personalId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'rating': newRating,
        }),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Falha ao atualizar nota do personal');
      }
    } catch (e) {
      // Fallback: atualizar em memória (não implementado para personals)
      print('Erro ao atualizar nota do personal: $e');
    }
  }

  // Dados mock para fallback
  List<Review> _getMockReviews() {
    return [
      ReviewModel(
        id: '1',
        personalId: '1',
        userName: 'Maria Silva',
        userPhotoUrl: 'https://randomuser.me/api/portraits/women/10.jpg',
        rating: 5.0,
        comment: 'Excelente profissional! Em 3 meses consegui perder 8kg e me sinto muito mais disposta. A Amanda é muito atenciosa e sempre me motiva.',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        verified: true,
      ),
      ReviewModel(
        id: '2',
        personalId: '1',
        userName: 'Ana Paula',
        userPhotoUrl: 'https://randomuser.me/api/portraits/women/11.jpg',
        rating: 4.5,
        comment: 'Muito boa personal! Os treinos são desafiadores mas sempre respeitando meus limites. Recomendo!',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        verified: true,
      ),
      ReviewModel(
        id: '3',
        personalId: '2',
        userName: 'João Santos',
        userPhotoUrl: 'https://randomuser.me/api/portraits/men/12.jpg',
        rating: 4.8,
        comment: 'Carlos é um excelente profissional! Em 6 meses consegui ganhar 5kg de massa muscular. Os treinos são intensos mas muito eficientes.',
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        verified: true,
      ),
    ];
  }
}

 