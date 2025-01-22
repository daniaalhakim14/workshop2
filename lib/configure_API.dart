class AppConfig {
  // Base URL for API
  static String baseUrl = 'http://192.168.132.198:3000';

  // Function to update the base URL dynamically
  static void updateBaseUrl(String newBaseUrl) {
    baseUrl = newBaseUrl;
  }
}
