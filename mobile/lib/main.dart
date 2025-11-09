import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/menu_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/reservation_screen.dart';
import 'screens/my_reservations_screen.dart';
import 'screens/edit_reservation_screen.dart';
import 'screens/admin_reservations_screen.dart';
import 'screens/profile_screen.dart';
import 'theme/app_theme.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Very Dark Kitchen',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: '/menu',
      routes: {
        '/menu': (context) => const MenuScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/reservation': (context) => const ReservationScreen(),
        '/my-reservations': (context) => const MyReservationsScreen(),
        '/edit-reservation': (context) => const EditReservationScreen(),
        '/admin-reservations': (context) => const AdminReservationsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
