import '../../domain/entities/review.dart';

class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.personalId,
    required super.userName,
    required super.userPhotoUrl,
    required super.rating,
    required super.comment,
    required super.createdAt,
    super.photos,
    super.verified,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? '',
      personalId: json['personalId'] ?? '',
      userName: json['userName'] ?? '',
      userPhotoUrl: json['userPhotoUrl'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      photos: List<String>.from(json['photos'] ?? []),
      verified: json['verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personalId': personalId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'photos': photos,
      'verified': verified,
    };
  }

  ReviewModel copyWith({
    String? id,
    String? personalId,
    String? userName,
    String? userPhotoUrl,
    double? rating,
    String? comment,
    DateTime? createdAt,
    List<String>? photos,
    bool? verified,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      personalId: personalId ?? this.personalId,
      userName: userName ?? this.userName,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      photos: photos ?? this.photos,
      verified: verified ?? this.verified,
    );
  }
} 