import '../../domain/entities/personal.dart';
import '../../domain/entities/review.dart';
import 'review_model.dart';

class PersonalModel extends Personal {
  const PersonalModel({
    required super.id,
    required super.name,
    required super.bio,
    required super.specialties,
    required super.rating,
    required super.city,
    required super.state,
    required super.photoUrl,
    required super.whatsapp,
    required super.price,
    super.availableDays,
    super.availableHours,
    super.reviews,
    super.totalSessions,
  });

  factory PersonalModel.fromJson(Map<String, dynamic> json) {
    return PersonalModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      bio: json['bio'] ?? '',
      specialties: List<String>.from(json['specialties'] ?? []),
      rating: (json['rating'] ?? 0.0).toDouble(),
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      availableDays: List<String>.from(json['availableDays'] ?? []),
      availableHours: List<String>.from(json['availableHours'] ?? []),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((review) => ReviewModel.fromJson(review))
          .toList() ?? [],
      totalSessions: json['totalSessions'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'specialties': specialties,
      'rating': rating,
      'city': city,
      'state': state,
      'photoUrl': photoUrl,
      'whatsapp': whatsapp,
      'price': price,
      'availableDays': availableDays,
      'availableHours': availableHours,
      'reviews': reviews.map((review) => (review as ReviewModel).toJson()).toList(),
      'totalSessions': totalSessions,
    };
  }

  PersonalModel copyWith({
    String? id,
    String? name,
    String? bio,
    List<String>? specialties,
    double? rating,
    String? city,
    String? state,
    String? photoUrl,
    String? whatsapp,
    double? price,
    List<String>? availableDays,
    List<String>? availableHours,
    List<Review>? reviews,
    int? totalSessions,
  }) {
    return PersonalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      specialties: specialties ?? this.specialties,
      rating: rating ?? this.rating,
      city: city ?? this.city,
      state: state ?? this.state,
      photoUrl: photoUrl ?? this.photoUrl,
      whatsapp: whatsapp ?? this.whatsapp,
      price: price ?? this.price,
      availableDays: availableDays ?? this.availableDays,
      availableHours: availableHours ?? this.availableHours,
      reviews: reviews ?? this.reviews,
      totalSessions: totalSessions ?? this.totalSessions,
    );
  }
} 