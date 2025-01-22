class AppConfig {
  // Base URL for API
  static String baseUrl = 'http://10.131.77.247:3000';

  // Function to update the base URL dynamically
  static void updateBaseUrl(String newBaseUrl) {
    baseUrl = newBaseUrl;
  }
}
