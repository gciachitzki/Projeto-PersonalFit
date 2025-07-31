import 'review.dart';

class Personal {
  final String id;
  final String name;
  final String bio;
  final List<String> specialties;
  final double rating;
  final String city;
  final String state;
  final String photoUrl;
  final String whatsapp;
  final double price;
  final List<String> availableDays; // Dias disponíveis (ex: ['segunda', 'terça'])
  final List<String> availableHours; // Horários disponíveis (ex: ['08:00', '09:00'])
  final List<Review> reviews; // Lista de avaliações
  final int totalSessions; // Total de sessões realizadas

  const Personal({
    required this.id,
    required this.name,
    required this.bio,
    required this.specialties,
    required this.rating,
    required this.city,
    required this.state,
    required this.photoUrl,
    required this.whatsapp,
    required this.price,
    this.availableDays = const [],
    this.availableHours = const [],
    this.reviews = const [],
    this.totalSessions = 0,
  });

  String get location => '$city, $state';
  
  String get formattedPrice => 'R\$ ${price.toStringAsFixed(0)}';
  
  String get formattedRating => rating.toStringAsFixed(1);

  // Método para verificar se o personal está disponível em um horário específico
  bool isAvailable(String day, String hour) {
    return availableDays.contains(day) && availableHours.contains(hour);
  }

  // Método para obter horários disponíveis de um dia específico
  List<String> getAvailableHoursForDay(String day) {
    if (availableDays.contains(day)) {
      return availableHours;
    }
    return [];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Personal && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Personal(id: $id, name: $name, rating: $rating)';
  }

  Personal copyWith({
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
    return Personal(
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