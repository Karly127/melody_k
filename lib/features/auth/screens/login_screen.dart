import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _iniciarSesion() {
    if (_formKey.currentState!.validate()) {
      // Aquí se conectará posteriormente con SQLite para validar credenciales
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Validando credenciales...')),
      );
    }
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Ícono representativo de la tienda de música
                  const Icon(
                    Icons.music_note,
                    size: 100,
                    color: Color(0xFFE53935),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Melody-K',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Gestión de Inventario',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Campo de Usuario
                  TextFormField(
                    controller: _userController,
                    decoration: InputDecoration(
                      labelText: 'Usuario',
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu usuario';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Campo de Contraseña
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu contraseña';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  
                  // Botón de Inicio de Sesión
                  ElevatedButton(
                    onPressed: _iniciarSesion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}