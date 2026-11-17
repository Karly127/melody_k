import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'features/auth/screens/login_screen.dart';

void main() {
  // Asegura que las vinculaciones de Flutter estén listas antes de iniciar SQLite
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar SQLite para entornos de escritorio (Windows, Linux, macOS)
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MelodyKApp());
}

class MelodyKApp extends StatelessWidget {
  const MelodyKApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Melody-K',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF181818),
        primaryColor: const Color(0xFFE53935),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE53935),
          secondary: Color(0xFFE53935),
          surface: Color(0xFF222222),
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}