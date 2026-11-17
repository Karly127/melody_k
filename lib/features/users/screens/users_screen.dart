import 'package:flutter/material.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../auth/screens/login_screen.dart';

class UsersScreen extends StatefulWidget {
  final bool esAdmin;
  final Map<String, dynamic> usuarioActual;
  final Function(Map<String, dynamic>) onUsuarioEditado;

  const UsersScreen({
    super.key, 
    required this.esAdmin, 
    required this.usuarioActual,
    required this.onUsuarioEditado
  });

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<Map<String, dynamic>> _usuarios = [];

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  Future<void> _cargarUsuarios() async {
    final datos = await LocalStorageService.instance.obtenerUsuarios();
    setState(() => _usuarios = datos);
  }

  void _abrirFormularioUsuario([Map<String, dynamic>? usuario]) {
    final nombreCtrl = TextEditingController(text: usuario?['nombre'] ?? '');
    final usuarioCtrl = TextEditingController(text: usuario?['usuario'] ?? '');
    final passwordCtrl = TextEditingController(text: usuario?['password'] ?? '');
    bool esAdminCheck = (usuario?['es_admin'] ?? 0) == 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF222222),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            top: 24, left: 24, right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(usuario == null ? 'Nuevo Usuario' : 'Editar Usuario', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre completo', filled: true)),
              const SizedBox(height: 12),
              TextField(controller: usuarioCtrl, decoration: const InputDecoration(labelText: 'Nombre de usuario', filled: true)),
              const SizedBox(height: 12),
              TextField(controller: passwordCtrl, decoration: const InputDecoration(labelText: 'Contraseña', filled: true), obscureText: true),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('¿Es Administrador?'),
                value: esAdminCheck,
                onChanged: (val) => setModalState(() => esAdminCheck = val),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
                onPressed: () async {
                  final datosUser = {
                    'nombre': nombreCtrl.text,
                    'usuario': usuarioCtrl.text,
                    'password': passwordCtrl.text,
                    'es_admin': esAdminCheck ? 1 : 0,
                  };

                  if (usuario == null) {
                    await LocalStorageService.instance.insertarUsuario(datosUser);
                  } else {
                    await LocalStorageService.instance.actualizarUsuario(usuario['id'], datosUser);
                    // Disparar la actualización en tiempo real si el usuario editado es el activo
                    if (widget.usuarioActual['id'] == usuario['id']) {
                      widget.onUsuarioEditado({...datosUser, 'id': usuario['id']});
                    }
                  }

                  if (!mounted) return;
                  Navigator.pop(ctx);
                  _cargarUsuarios();
                },
                child: Text(usuario == null ? 'Guardar' : 'Actualizar', style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuenta', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
          )
        ],
      ),
      floatingActionButton: widget.esAdmin ? FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => _abrirFormularioUsuario(),
        child: const Icon(Icons.add, color: Colors.white),
      ) : null,
      body: Column(
        children: [
          // Tarjeta de perfil del usuario actual
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const CircleAvatar(radius: 30, backgroundColor: Colors.redAccent, child: Icon(Icons.person, size: 36, color: Colors.white)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.usuarioActual['nombre'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text(widget.esAdmin ? 'Administrador' : 'Empleado', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Align(alignment: Alignment.centerLeft, child: Text('Todos los usuarios', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _usuarios.length,
              itemBuilder: (context, index) {
                final u = _usuarios[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151515),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: ListTile(
                    title: Text(u['nombre'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    subtitle: Text('@${u['usuario']}', style: const TextStyle(color: Colors.grey)),
                    trailing: widget.esAdmin ? IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white54),
                      onPressed: () => _abrirFormularioUsuario(u),
                    ) : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}