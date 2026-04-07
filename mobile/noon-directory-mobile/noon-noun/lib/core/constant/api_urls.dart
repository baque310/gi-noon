class ApiUrls {
  // ===== دليل نون API =====
  static const baseUrl = 'https://api.noon-iraq.com'; // Production
  // static const baseUrl = 'http://10.0.2.2:3003'; // For Android Emulator loopback
  // static const baseUrl = 'http://10.185.64.163:3003'; // Local API (WiFi)

  static const String apiKey = 'noon_directory_api_key_2024_secure';

  // ===== Public Endpoints (No Auth) =====
  static const filesUrl = '$baseUrl/uploads';
  static const bannersUrl = '$baseUrl/public/banner';
  static const directoryListingUrl = '$baseUrl/public/directory-listing';
  static const notificationsUrl = '$baseUrl/public/notifications';
  static const adRequestUrl = '$baseUrl/public/ad-request';
  static const jobSeekerUrl = '$baseUrl/public/job-seeker';
}
