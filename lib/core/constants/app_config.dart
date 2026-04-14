class AppConfig {
  static const String ipAddress = '192.168.1.100';
  static const String port ='8000';

  static const String baseUrl = 'http://$ipAddress:$port';
  static const String wsUrl = 'ws://$ipAddress:$port/api/v1/ws/app';
  static String getVocabularyUrl(String word) => '$baseUrl/api/v1/vocabulary/$word';
  
  static String getAudioUrl(String relativePath) => '$baseUrl$relativePath';
}
