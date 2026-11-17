import 'package:flutter/material.dart';
import '../../../core/storage/local_storage_service.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Map<String, dynamic>> _productos = [];

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    final datos = await LocalStorageService.instance.obtenerProductos();
    setState(() {
      _productos = datos;
    });
  }

  InputDecoration _inputEstilo(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFF222222), // Fondo oscuro para los inputs del modal
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
    );
  }

  void _abrirFormularioProducto() {
    final codigoCtrl = TextEditingController();
    final nombreCtrl = TextEditingController();
    final marcaCtrl = TextEditingController();
    final categoriaCtrl = TextEditingController();
    final precioCompraCtrl = TextEditingController();
    final precioVentaCtrl = TextEditingController();
    final existenciaCtrl = TextEditingController();
    final stockMinimoCtrl = TextEditingController();
    final descripcionCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF181818),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          top: 24, left: 24, right: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Registrar Producto', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              
              // Botón para agregar imagen en el formulario de registro
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF222222),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white12),
                ),
                child: TextButton.icon(
                  onPressed: () {
                    // TODO: Lógica para adjuntar imagen en la creación
                  },
                  icon: const Icon(Icons.add_a_photo, color: Colors.grey),
                  label: const Text('Agregar Imagen del Producto', style: TextStyle(color: Colors.grey)),
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                ),
              ),
              const SizedBox(height: 16),
              
              TextField(controller: codigoCtrl, decoration: _inputEstilo('Código de Barras')),
              const SizedBox(height: 12),
              TextField(controller: nombreCtrl, decoration: _inputEstilo('Nombre de Producto')),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextField(controller: marcaCtrl, decoration: _inputEstilo('Marca'))),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: categoriaCtrl, decoration: _inputEstilo('Categoría'))),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextField(controller: precioCompraCtrl, keyboardType: TextInputType.number, decoration: _inputEstilo('Precio Compra (\$)'))),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: precioVentaCtrl, keyboardType: TextInputType.number, decoration: _inputEstilo('Precio Venta (\$)'))),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextField(controller: existenciaCtrl, keyboardType: TextInputType.number, decoration: _inputEstilo('Cant. Existente'))),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: stockMinimoCtrl, keyboardType: TextInputType.number, decoration: _inputEstilo('Stock Mínimo'))),
                ],
              ),
              const SizedBox(height: 12),
              TextField(controller: descripcionCtrl, maxLines: 2, decoration: _inputEstilo('Descripción')),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  await LocalStorageService.instance.insertarProducto({
                    'codigo_barras': codigoCtrl.text,
                    'nombre': nombreCtrl.text,
                    'marca': marcaCtrl.text,
                    'categoria': categoriaCtrl.text,
                    'precio_compra': double.tryParse(precioCompraCtrl.text) ?? 0.0,
                    'precio_venta': double.tryParse(precioVentaCtrl.text) ?? 0.0,
                    'existencia': int.tryParse(existenciaCtrl.text) ?? 0,
                    'stock_minimo': int.tryParse(stockMinimoCtrl.text) ?? 0,
                    'descripcion': descripcionCtrl.text,
                  });

                  if (!mounted) return;
                  Navigator.pop(ctx);
                  _cargarProductos();
                },
                child: const Text('Guardar Producto', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
        title: const Text('Inventario de Productos', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent, // Fondo transparente en lugar del color primario
        elevation: 0,
        centerTitle: true, // Título centrado
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: _abrirFormularioProducto,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: _productos.isEmpty
          ? const Center(child: Text('No hay productos en inventario', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _productos.length,
              itemBuilder: (context, index) {
                final p = _productos[index];
                return GestureDetector(
                  onTap: () {
                    // Abrir pantalla de detalle y recargar lista al volver
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          producto: p,
                          onUpdate: _cargarProductos, 
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A), // Tarjeta oscura
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.music_note, color: Colors.redAccent, size: 32),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p['nombre'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                              const SizedBox(height: 4),
                              Text('${p['marca']} • ${p['categoria']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              Text('Código: ${p['codigo_barras']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('\$${p['precio_venta']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text('Stock: ${p['existencia']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}