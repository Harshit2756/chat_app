import 'package:chat_app/app/data/services/auth/auth_service.dart';
import 'package:chat_app/core/routes/routes_name.dart';
import 'package:chat_app/core/utils/helpers/logger.dart';
import 'package:chat_app/core/widgets/snackbar/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find<SignUpController>();

  /// Variables
  final hidePassword = true.obs;
  final isLoading = false.obs;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final postalCodeController = TextEditingController();
  final birthController = TextEditingController();
  final genderController = TextEditingController(text: 'Prefer not to say');
  final genderValue = 'Prefer not to say'.obs;
  final AuthService _authService = Get.find<AuthService>();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  /// Focus Nodes
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final addressFocusNode = FocusNode();
  final countryFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final postalCodeFocusNode = FocusNode();

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    nameFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize phone number for India
    phoneController.text = '';
  }

  Future<void> signUpWithGoogle() async {
    try {
      isLoading.value = true;
      final response = await _authService.signInWithGoogle();

      if (response.success) {
        final user = response.data;
        nameController.text = user!.displayName ?? '';
        emailController.text = user.email;
        Get.offAllNamed(HRoutesName.signUpForm);
        HSnackbars.showSnackbar(type: SnackbarType.success, message: response.message ?? 'Login successful');
      }
    } catch (e) {
      HLoggerHelper.error("Login failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp() async {
    if (!_validateInputs()) return;

    try {
      isLoading.value = true;
      final user = {
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone_number": phoneController.text.trim(),
        "address": addressController.text.trim(),
        "city": cityController.text.trim(),
        "state": stateController.text.trim(),
        "date_of_birth": birthController.text.trim(),
        "gender": genderController.text.trim(),
      };
      final response = await _authService.signUp(user);

      if (response.success) {
        Get.offAllNamed(HRoutesName.chatView);
        HSnackbars.showSnackbar(type: SnackbarType.success, message: response.message ?? 'Congratulations! Your account has been created successful');
      } else {
        HSnackbars.showSnackbar(type: SnackbarType.error, message: response.message ?? 'Something went wrong');
        HLoggerHelper.error("Sign up failed: ${response.message}");
      }
    } catch (e) {
      HLoggerHelper.error(" failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    hidePassword.value = !hidePassword.value;
  }

  bool _validateInputs() {
    if (!loginFormKey.currentState!.validate()) {
      return false;
    }
    return true;
  }
}
