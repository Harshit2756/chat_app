class ApiEndpoints {
  static const String baseUrl = 'https://spell.theanantkaal.com/api';
  //* Auth Endpoints
  static const String signUp = '$baseUrl/createglobaluser';
  static const String getUser = '$baseUrl/showglobaluser';
  static const String getMessages = '$baseUrl/showglobalchat';
  static const String sendMessage = '$baseUrl/createglobalchat';
  static const String sendImage  = '$baseUrl/save-Multipart-Image';

 

}
