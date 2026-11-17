import 'package:flutter/material.dart';
import '../../../core/storage/local_storage_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> producto;
  final VoidCallback onUpdate;

  const ProductDetailScreen({super.key, required this.producto, required this.onUpdate});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Map<String, dynamic> _producto;

  @override
  void initState() {
    super.initState();
    _producto = widget.producto;
  }

  void _eliminarProducto() async {
    await LocalStorageService.instance.eliminarProducto(_producto['id']);
    widget.onUpdate();
    if (mounted) Navigator.pop(context);
  }

  // Modal para editar la información (reutiliza el diseño del registro)
  void _abrirFormularioEdicion() {
    final codigoCtrl = TextEditingController(text: _producto['codigo_barras']);
    final nombreCtrl = TextEditingController(text: _producto['nombre']);
    final marcaCtrl = TextEditingController(text: _producto['marca']);
    final categoriaCtrl = TextEditingController(text: _producto['categoria']);
    final precioCompraCtrl = TextEditingController(text: _producto['precio_compra'].toString());
    final precioVentaCtrl = TextEditingController(text: _producto['precio_venta'].toString());
    final existenciaCtrl = TextEditingController(text: _producto['existencia'].toString());
    final stockMinimoCtrl = TextEditingController(text: _producto['stock_minimo'].toString());
    final descripcionCtrl = TextEditingController(text: _producto['descripcion']);

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
              const Text('Editar Producto', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              
              // Botón temporal para agregar imagen en el formulario
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Lógica futura para seleccionar imagen de galería
                },
                icon: const Icon(Icons.image_outlined, color: Colors.redAccent),
                label: const Text('Cambiar Imagen', style: TextStyle(color: Colors.redAccent)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: Colors.redAccent),
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
                style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: () async {
                  final datosActualizados = {
                    'codigo_barras': codigoCtrl.text,
                    'nombre': nombreCtrl.text,
                    'marca': marcaCtrl.text,
                    'categoria': categoriaCtrl.text,
                    'precio_compra': double.tryParse(precioCompraCtrl.text) ?? 0.0,
                    'precio_venta': double.tryParse(precioVentaCtrl.text) ?? 0.0,
                    'existencia': int.tryParse(existenciaCtrl.text) ?? 0,
                    'stock_minimo': int.tryParse(stockMinimoCtrl.text) ?? 0,
                    'descripcion': descripcionCtrl.text,
                  };

                  await LocalStorageService.instance.actualizarProducto(_producto['id'], datosActualizados);
                  
                  if (!mounted) return;
                  setState(() {
                    _producto = {..._producto, ...datosActualizados};
                  });
                  widget.onUpdate();
                  Navigator.pop(ctx);
                },
                child: const Text('Actualizar Producto', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputEstilo(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFF222222),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
    );
  }

  Widget _buildFilaDetalle(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(etiqueta, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(valor, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool enExistencia = _producto['existencia'] > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Producto', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Caja del código de barras superior
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  const Icon(Icons.barcode_reader, color: Colors.redAccent),
                  const SizedBox(width: 8),
                  Text('Código: ${_producto['codigo_barras']}', style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Imagen del producto (Placeholder)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 180, height: 180,
                color: const Color(0xFF222222),
                child: const Icon(Icons.music_note, size: 80, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            
            // Nombre y Categoría
            Text(_producto['nombre'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text('${_producto['marca']} • ${_producto['categoria']}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 16),
            
            // Píldora de estado de existencia
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: enExistencia ? Colors.greenAccent.withOpacity(0.1) : Colors.redAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: enExistencia ? Colors.greenAccent : Colors.redAccent),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 10, color: enExistencia ? Colors.greenAccent : Colors.redAccent),
                  const SizedBox(width: 8),
                  Text(enExistencia ? 'En Existencia' : 'Agotado', style: TextStyle(color: enExistencia ? Colors.greenAccent : Colors.redAccent, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Tabla de especificaciones
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  _buildFilaDetalle('Marca', _producto['marca']),
                  const Divider(color: Colors.white12),
                  _buildFilaDetalle('Categoría', _producto['categoria']),
                  const Divider(color: Colors.white12),
                  _buildFilaDetalle('Precio Compra', '\$${_producto['precio_compra']}'),
                  const Divider(color: Colors.white12),
                  _buildFilaDetalle('Precio Venta', '\$${_producto['precio_venta']}'),
                  const Divider(color: Colors.white12),
                  _buildFilaDetalle('Cantidad Existente', '${_producto['existencia']} unidades'),
                  const Divider(color: Colors.white12),
                  _buildFilaDetalle('Stock Mínimo', '${_producto['stock_minimo']} unidades'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Botones de acción inferiores
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _abrirFormularioEdicion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Editar Producto', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: _eliminarProducto,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Eliminar', style: TextStyle(color: Colors.redAccent, fontSize: 16)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}