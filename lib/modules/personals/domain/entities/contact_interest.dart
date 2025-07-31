class ContactInterest {
  final String personalId;
  final String modality;
  final String frequency;
  final String userName;
  final double estimatedPrice;

  const ContactInterest({
    required this.personalId,
    required this.modality,
    required this.frequency,
    required this.userName,
    required this.estimatedPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'personalId': personalId,
      'modality': modality,
      'frequency': frequency,
      'userName': userName,
      'estimatedPrice': estimatedPrice,
    };
  }

  @override
  String toString() {
    return 'ContactInterest(personalId: $personalId, modality: $modality, frequency: $frequency, estimatedPrice: $estimatedPrice)';
  }
} 