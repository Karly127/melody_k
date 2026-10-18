import 'package:flutter/material.dart';
import 'features/auth/screens/login_screen.dart';

void main() {
  runApp(const MelodyKApp());
}

class MelodyKApp extends StatelessWidget {
  const MelodyKApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Melody-K',
      debugShowCheckedModeBanner: false,
      // Configuración de Material Design basada en los mockups
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF181818), // Fondo oscuro
        primaryColor: const Color(0xFFE53935), // Botones rojos
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE53935),
          secondary: Color(0xFFE53935),
          surface: Color(0xFF222222), // Cajas de texto y tarjetas
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}