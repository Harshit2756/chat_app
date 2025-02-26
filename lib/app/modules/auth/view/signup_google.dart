import 'package:chat_app/core/utils/constants/sizes.dart';
import 'package:chat_app/core/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../core/utils/media/assets.dart';
import '../controller/sign_up_controller.dart';

class SignUpGoogleView extends StatelessWidget {
  const SignUpGoogleView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    return Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage(HAssets.signUpBackground), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: HSizes.spaceBtwItems24),
          child: Center(child: CustomButton(isLoading: controller.isLoading.value, text: 'Sign In with Google', onPressed: controller.signUpWithGoogle, prefix: Brand(Brands.google, size: 24))),
        ),
      ),
    );
  }
}
