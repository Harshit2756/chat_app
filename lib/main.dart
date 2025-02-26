import 'package:chat_app/core/routes/routes_name.dart';
import 'package:chat_app/core/utils/theme/theme.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'core/routes/app_routes.dart';
import 'core/utils/theme/colors.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(systemNavigationBarColor: HColors.primary, systemNavigationBarIconBrightness: Brightness.light));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Attendance App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: HAppTheme.lightTheme,
      initialRoute: HAppRoutes.initial,
      getPages: HAppRoutes.routes,
      defaultTransition: Transition.fade,
      unknownRoute: HAppRoutes.routes.firstWhere((page) => page.name == HRoutesName.notFound),
    );
  }
}
