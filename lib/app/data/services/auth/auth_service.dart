/// Authentication service
///
/// Purpose:
/// - Manage auth state
/// - Handle user session
/// - Provide auth utilities
library;

import 'package:chat_app/core/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../models/network/auth/user_model.dart';
import '../../models/response_model.dart';
import '../../../modules/auth/repository/auth_repository.dart';
import '../base_service.dart';

class AuthService extends BaseService {
  static AuthService get instance => Get.find();

  final AuthRepository _repository = Get.find<AuthRepository>();

  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  final Rx<String?> _token = Rx<String?>(null);

  UserModel? get currentUser => _currentUser.value;

  bool get isLoggedIn => _currentUser.value != null && _token.value != null;
  String get token => _token.value ?? '';

  /// Method to handle route redirection
  String handleRouteRedirection() {
    if (isLoggedIn) {
      return HRoutesName.chatView;
    } else {
      return HRoutesName.signUp;
    }
  }

  Future<ResponseModel<GoogleSignInAccount>> signInWithGoogle() async {
    return await _repository.signInWithGoogle();
  }

  Future<ResponseModel> signUp(Map<String, dynamic> data) async {
    final response = await _repository.signUp(data);
    if (response.success && response.data != null) {
      _currentUser.value = response.data;
      _token.value = _repository.getUserToken();
      return response;
    }
    return ResponseModel.error(response.message!);
  }

  Future<void> logout() async {
    await _repository.logout();
    _currentUser.value = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offAllNamed(HRoutesName.signUp);
    });
  }

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  Future<void> _loadUser() async {
    _currentUser.value = _repository.getCurrentUser();
    _token.value = _repository.getUserToken();
    _repository.updateHeader();
  }
}
