/// Application pages configuration
///
/// Purpose:
/// - Define all application routes
/// - Configure route bindings
/// - Set up route middleware
///
/// Usage:
/// ```dart
/// GetMaterialApp(
///   initialRoute: AppPages.INITIAL,
///   getPages: AppPages.routes,
/// )
/// ```
library;

import 'package:chat_app/app/modules/auth/view/signup_google.dart';
import 'package:chat_app/app/modules/auth/view/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/modules/auth/view/signup_form_view.dart';
import '../../app/modules/chat/view/chat_view.dart';
import 'routes_name.dart';

class HAppRoutes {
  // This is the initial route of your app
  static const initial = HRoutesName.splash;

  // App pages configuration
  static final routes = [
    // Auth Pages
    GetPage(name: HRoutesName.splash, page: () => const SplashView()),
    GetPage(name: HRoutesName.signUp, page: () => const SignUpGoogleView()),
    GetPage(name: HRoutesName.signUpForm, page: () => const SignUpFormView()),
    GetPage(name: HRoutesName.chatView, page: () => const ChatView()),

    // Default route for undefined routes
    GetPage(
      name: HRoutesName.notFound,
      page: () => Scaffold(backgroundColor: Colors.white, body: Center(child: Text('Screen does not exist: ${Get.currentRoute}', style: const TextStyle(fontSize: 18)))),
    ),
  ];
}
