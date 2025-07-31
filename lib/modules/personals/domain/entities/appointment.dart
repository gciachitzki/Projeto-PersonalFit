enum AppointmentStatus {
  pending,    // Pendente de confirmação
  confirmed,  // Confirmado
  completed,  // Concluído
  cancelled,  // Cancelado
  noShow,     // Não compareceu
}

enum AppointmentType {
  inPerson,   // Presencial
  online,     // Online
  home,       // Domiciliar
}

class Appointment {
  final String id;
  final String personalId;
  final String personalName;
  final String personalPhotoUrl;
  final String userId;
  final String userName;
  final DateTime date;
  final String time;
  final AppointmentType type;
  final AppointmentStatus status;
  final String? notes; // Observações do usuário
  final String? personalNotes; // Observações do personal
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Appointment({
    required this.id,
    required this.personalId,
    required this.personalName,
    required this.personalPhotoUrl,
    required this.userId,
    required this.userName,
    required this.date,
    required this.time,
    required this.type,
    this.status = AppointmentStatus.pending,
    this.notes,
    this.personalNotes,
    required this.createdAt,
    this.updatedAt,
  });

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final appointmentDate = DateTime(date.year, date.month, date.day);
    
    if (appointmentDate == today) {
      return 'Hoje';
    } else if (appointmentDate == today.add(const Duration(days: 1))) {
      return 'Amanhã';
    } else {
      final days = appointmentDate.difference(today).inDays;
      return 'Em $days dias';
    }
  }

  String get formattedDateTime {
    final dayNames = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    final monthNames = [
      'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
    ];
    
    return '${dayNames[date.weekday - 1]}, ${date.day} ${monthNames[date.month - 1]} às $time';
  }

  String get statusText {
    switch (status) {
      case AppointmentStatus.pending:
        return 'Pendente';
      case AppointmentStatus.confirmed:
        return 'Confirmado';
      case AppointmentStatus.completed:
        return 'Concluído';
      case AppointmentStatus.cancelled:
        return 'Cancelado';
      case AppointmentStatus.noShow:
        return 'Não compareceu';
    }
  }

  String get typeText {
    switch (type) {
      case AppointmentType.inPerson:
        return 'Presencial';
      case AppointmentType.online:
        return 'Online';
      case AppointmentType.home:
        return 'Domiciliar';
    }
  }

  bool get isUpcoming {
    final now = DateTime.now();
    final appointmentDateTime = DateTime(
      date.year, date.month, date.day,
      int.parse(time.split(':')[0]),
      int.parse(time.split(':')[1]),
    );
    return appointmentDateTime.isAfter(now);
  }

  bool get isPast {
    final now = DateTime.now();
    final appointmentDateTime = DateTime(
      date.year, date.month, date.day,
      int.parse(time.split(':')[0]),
      int.parse(time.split(':')[1]),
    );
    return appointmentDateTime.isBefore(now);
  }

  bool get canBeCancelled {
    return status == AppointmentStatus.pending || 
           status == AppointmentStatus.confirmed;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Appointment && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Appointment(id: $id, date: $date, time: $time, status: $status)';
  }
} 