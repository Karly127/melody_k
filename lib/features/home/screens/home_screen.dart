import 'package:flutter/material.dart';
import '../../auth/screens/login_screen.dart';
import '../../users/screens/users_screen.dart';
import '../../products/screens/products_screen.dart';
import '../../search/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> usuarioActual;

  const HomeScreen({super.key, required this.usuarioActual});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _indiceActual = 0;
  late Map<String, dynamic> _usuarioActual;

  @override
  void initState() {
    super.initState();
    _usuarioActual = widget.usuarioActual;
  }

  // Función para actualizar el estado del nombre en tiempo real si el admin se edita a sí mismo
  void _actualizarDatosUsuario(Map<String, dynamic> usuarioActualizado) {
    if (_usuarioActual['id'] == usuarioActualizado['id']) {
      setState(() {
        _usuarioActual = usuarioActualizado;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool esAdmin = (_usuarioActual['es_admin'] ?? 0) == 1;

    // Lista de las 3 pantallas principales
    final List<Widget> pantallas = [
      const SearchScreen(),
      const ProductsScreen(),
      UsersScreen(
        esAdmin: esAdmin, 
        usuarioActual: _usuarioActual,
        onUsuarioEditado: _actualizarDatosUsuario,
      ),
    ];

    return Scaffold(
      body: pantallas[_indiceActual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceActual,
        onTap: (index) {
          setState(() {
            _indiceActual = index;
          });
        },
        backgroundColor: const Color(0xFF151515),
        selectedItemColor: Theme.of(context).primaryColor, // Rojo
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Escanear',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Inventario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Cuenta',
          ),
        ],
      ),
    );
  }
}