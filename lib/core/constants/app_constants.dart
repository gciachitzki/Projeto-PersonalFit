class AppConstants {
  // API URLs
  static const String baseUrl = 'https://6889f6f24c55d5c7395460c4.mockapi.io/api/v1';
  static const String personalsEndpoint = '/Personal';
  static const String contactInterestEndpoint = '/contact-interest';
  
  // App Info
  static const String appName = 'PersonalFit';
  static const String appVersion = '1.0.0';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double cardElevation = 4.0;
  
  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  
  // Error Messages
  static const String networkErrorMessage = 'Erro de conexão. Verifique sua internet.';
  static const String genericErrorMessage = 'Algo deu errado. Tente novamente.';
  static const String noPersonalsMessage = 'Nenhum personal encontrado.';
} 