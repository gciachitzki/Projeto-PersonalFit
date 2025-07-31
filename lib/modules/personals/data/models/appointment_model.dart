import '../../domain/entities/appointment.dart';

class AppointmentModel extends Appointment {
  const AppointmentModel({
    required super.id,
    required super.personalId,
    required super.personalName,
    required super.personalPhotoUrl,
    required super.userId,
    required super.userName,
    required super.date,
    required super.time,
    required super.type,
    super.status,
    super.notes,
    super.personalNotes,
    required super.createdAt,
    super.updatedAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] ?? '',
      personalId: json['personalId'] ?? '',
      personalName: json['personalName'] ?? '',
      personalPhotoUrl: json['personalPhotoUrl'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      time: json['time'] ?? '',
      type: AppointmentType.values.firstWhere(
        (e) => e.toString() == 'AppointmentType.${json['type']}',
        orElse: () => AppointmentType.inPerson,
      ),
      status: AppointmentStatus.values.firstWhere(
        (e) => e.toString() == 'AppointmentStatus.${json['status']}',
        orElse: () => AppointmentStatus.pending,
      ),
      notes: json['notes'],
      personalNotes: json['personalNotes'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personalId': personalId,
      'personalName': personalName,
      'personalPhotoUrl': personalPhotoUrl,
      'userId': userId,
      'userName': userName,
      'date': date.toIso8601String(),
      'time': time,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'notes': notes,
      'personalNotes': personalNotes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  AppointmentModel copyWith({
    String? id,
    String? personalId,
    String? personalName,
    String? personalPhotoUrl,
    String? userId,
    String? userName,
    DateTime? date,
    String? time,
    AppointmentType? type,
    AppointmentStatus? status,
    String? notes,
    String? personalNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      personalId: personalId ?? this.personalId,
      personalName: personalName ?? this.personalName,
      personalPhotoUrl: personalPhotoUrl ?? this.personalPhotoUrl,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      date: date ?? this.date,
      time: time ?? this.time,
      type: type ?? this.type,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      personalNotes: personalNotes ?? this.personalNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 