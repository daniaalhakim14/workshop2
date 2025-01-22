class AppConfig {
  // Base URL for API
<<<<<<< HEAD
  static String baseUrl = 'http://192.168.132.198:3000';
=======
  static String baseUrl = 'http://10.131.77.247:3000';
>>>>>>> 47229b6 (update account page)

  // Function to update the base URL dynamically
  static void updateBaseUrl(String newBaseUrl) {
    baseUrl = newBaseUrl;
  }
}
