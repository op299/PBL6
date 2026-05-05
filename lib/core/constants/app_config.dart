class AppConfig {
  static const String ipAddress = '192.168.10.155';
  static const String port = '8000';

  static const String baseUrl = 'http://$ipAddress:$port';
  static const String wsUrl = 'ws://$ipAddress:$port/api/v1/ws/app';
  static const String historyUrl = "$baseUrl/api/v1/history";
  static const String authUrl = "$baseUrl/api/v1/auth";
  static String getVocabularyUrl(String word) =>
      '$baseUrl/api/v1/objects/$word';

  static String getAudioUrl(String relativePath) => '$baseUrl$relativePath';
}
