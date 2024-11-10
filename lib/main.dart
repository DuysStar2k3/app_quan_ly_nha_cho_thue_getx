import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/routes/app_pages.dart';
import 'app/core/theme/app_theme.dart';
import 'app/modules/auth/bindings/auth_binding.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Quản Lý Nhà Trọ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialBinding: AuthBinding(),
      initialRoute: Routes.SPLASH,
      getPages: AppPages.routes,
    );
  }
}
