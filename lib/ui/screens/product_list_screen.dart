import 'package:flutter/material.dart';
import '../../data/models/producto.dart';
import '../../data/repositories/producto_repository.dart';
import 'create_product_screen.dart';
import 'details_product_screen.dart'; // Asegúrate de que el import sea correcto

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Producto> _allProducts = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await obtenerProductos();
      setState(() {
        _allProducts = products;
      });
    } catch (e) {
      print('Error loading products: $e');
    }
  }

  Future<void> _refreshProductos() async {
    await _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Productos'),
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: _refreshProductos,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                DataTable(
                  columns: const [
                    DataColumn(
                        label: Text('ID')), // Cambiar de Descripción a ID
                    DataColumn(label: Text('Descripción')),
                    DataColumn(label: Text('Stock')),
                  ],
                  rows: _allProducts.map((producto) {
                    return DataRow(
                      cells: [
                        DataCell(Text(producto.id.toString())), // Mostrar el ID
                        DataCell(Text(producto.description)),
                        DataCell(Text(producto.stock.toString())),
                      ],
                      onSelectChanged: (selected) {
                        if (selected != null && selected) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsProductoScreen(
                                producto: producto,
                              ),
                            ),
                          );
                        }
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateProductScreen()),
          );
          _refreshProductos();
        },
        child: Icon(Icons.add),
        tooltip: 'Nuevo Producto',
      ),
    );
  }
}
