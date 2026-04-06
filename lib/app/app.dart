import 'package:flutter/material.dart';
import 'package:my_project/app/app_routes.dart';
import 'package:my_project/screens/home/home_screen.dart';
import 'package:my_project/screens/login/login_screen.dart';
import 'package:my_project/screens/profile/profile_screen.dart';
import 'package:my_project/screens/register/register_screen.dart';
import 'package:my_project/screens/splash/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Room State',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splash,
      routes: <String, WidgetBuilder>{
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
      },
    );
  }
}
