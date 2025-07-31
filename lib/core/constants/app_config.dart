class AppConfig {
  // Configuração para alternar entre mock local e API real do mockapi.io
  // use true para usar a API real e false para usar o mock local
  static const bool useRealApi = true;
  
  // Configurações de debug
  static const bool enableApiLogs = false;
  static const bool enableMockErrors = false; // Só funciona com mock local
  
  // Timeouts
  static const int connectionTimeoutSeconds = 10;
  static const int receiveTimeoutSeconds = 10;
  
  // Retry configuration
  static const int maxRetries = 3;
  static const int retryDelayMilliseconds = 1000;
} 