import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../../core/utils/helpers/logger.dart';
import '../../../data/models/network/auth/user_model.dart';
import '../../../data/models/response_model.dart';
import '../../../data/repositories/base_repository.dart';
import '../../../data/services/local_db/storage_keys.dart';
import '../../../data/services/local_db/storage_service.dart';
import '../../../data/services/network_db/api_endpoint.dart';
import '../../../data/services/network_db/api_service.dart';

class AuthRepository extends BaseRepository {
  final StorageService _storageService = Get.find<StorageService>();
  final ApiService _apiService = Get.find<ApiService>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<ResponseModel<GoogleSignInAccount>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return ResponseModel.error("Google sign in was canceled");
      }

      HLoggerHelper.info("Google sign in successful: ${googleUser.email}");
      return ResponseModel.success(googleUser, "Google sign-in successful");
    } catch (e) {
      HLoggerHelper.error("Google sign in failed: $e");
      return ResponseModel.error("Google sign in failed: $e");
    }
  }

  Future<ResponseModel<UserModel>> signUp(Map<String, dynamic> data) async {
    HLoggerHelper.info("Attempting to sign up user");
    final response = await _apiService.post<String>(ApiEndpoints.signUp, data);

    if (response.success && response.data != null) {
      final responseData = response.data as String;

      // Extract token and user data
      final String token = responseData;

      // Create user model from the registration data

      // Save user data and token
      await setUserToken(token);

      // get user data from the server
      final userResponse = await _apiService.get<List<dynamic>>(ApiEndpoints.getUser);
      if (userResponse.success && userResponse.data != null) {
        final userData = userResponse.data as List<dynamic>;
        final UserModel user = UserModel.fromJson(userData.isNotEmpty ? userData[0] : {});
        await saveCurrentUser(user);

        HLoggerHelper.debug("User data: $data");
        return ResponseModel.success(user, response.message ?? "Registration successful");
      }
    }

    return ResponseModel.error(response.message ?? "Registration failed");
  }

  UserModel? getCurrentUser() {
    final value = _storageService.read<Map<String, dynamic>>(StorageKeys.currentUser);
    UserModel? user = value != null ? UserModel.fromJson(value) : null;
    HLoggerHelper.debug("Retrieved current user: \${user?.toJson()}");
    return user;
  }

  Future<void> saveCurrentUser(UserModel user) async {
    await _storageService.write<Map<String, dynamic>>(StorageKeys.currentUser, user.toJson());
    HLoggerHelper.debug("Saved current user: \${user.toJson()}");
  }

  Future<ResponseModel<bool>> logout() async {
    await _storageService.clear();
    HLoggerHelper.info("User logged out successfully.");
    return ResponseModel.success(true, "Logout successful");
  }

  Future<void> setUserToken(String token) async {
    await _storageService.write<String>(StorageKeys.userToken, token);
    _apiService.setAuthToken(token);
    HLoggerHelper.debug("User token set: \$token");
  }

  String? getUserToken() {
    final token = _storageService.read<String>(StorageKeys.userToken);
    HLoggerHelper.debug("Retrieved user token: \$token");
    return token;
  }

  void updateHeader() {
    final String? token = getUserToken();
    if (token != null) {
      _apiService.setAuthToken(token);
      HLoggerHelper.debug("Updated API header with token: \$token");
    } else {
      HLoggerHelper.info("No token found to update API header.");
    }
  }
}
