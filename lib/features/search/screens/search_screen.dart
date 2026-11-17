import 'package:flutter/material.dart';
import '../../../core/storage/local_storage_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<Map<String, dynamic>> _resultados = [];
  bool _busquedaRealizada = false;
  bool _modoCamara = false; // Alternar entre cámara y manual

  void _realizarBusqueda(String query) async {
    if (query.trim().isEmpty) return;
    final resultados = await LocalStorageService.instance.buscarProductos(query);
    setState(() {
      _resultados = resultados;
      _busquedaRealizada = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Búsqueda por Escaneo', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Selector Cámara / Manual
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _modoCamara = true),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _modoCamara ? Theme.of(context).primaryColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('Cámara', style: TextStyle(color: _modoCamara ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _modoCamara = false),
                      child: Container(
                        decoration: BoxDecoration(
                          color: !_modoCamara ? Theme.of(context).primaryColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('Manual', style: TextStyle(color: !_modoCamara ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Contenido dinámico según el modo seleccionado
            if (_modoCamara)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.redAccent, width: 2),
                ),
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, color: Colors.white54, size: 48),
                    SizedBox(height: 8),
                    Text('Alinee el código de barras dentro del marco', style: TextStyle(color: Colors.white54)),
                  ],
                ),
              )
            else
              TextField(
                controller: _searchCtrl,
                onSubmitted: _realizarBusqueda,
                decoration: InputDecoration(
                  hintText: 'Ej. Teclado Roland XPS-30...',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchCtrl.clear();
                      setState(() {
                        _resultados = [];
                        _busquedaRealizada = false;
                      });
                    },
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Coincidencia Encontrada', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                if (_resultados.isNotEmpty)
                  TextButton(
                    onPressed: () {}, 
                    child: const Text('Escanear de Nuevo', style: TextStyle(color: Colors.redAccent))
                  )
              ],
            ),
            const SizedBox(height: 12),

            // Lista de Resultados
            Expanded(
              child: _resultados.isEmpty
                  ? Center(child: Text(_busquedaRealizada ? 'Sin resultados' : '', style: const TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: _resultados.length,
                      itemBuilder: (context, index) {
                        final item = _resultados[index];
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: 60, height: 60, color: Colors.grey[800],
                                      child: const Icon(Icons.music_note, color: Colors.white54),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item['nombre'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                        Text('${item['marca']} • ${item['categoria']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Divider(color: Colors.white12, height: 1),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Precio Venta', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                      Text('\$${item['precio_venta']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text('Disponibilidad', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                      Row(
                                        children: [
                                          Icon(Icons.circle, color: item['existencia'] > 0 ? Colors.greenAccent : Colors.redAccent, size: 10),
                                          const SizedBox(width: 4),
                                          Text('${item['existencia']} u.', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}