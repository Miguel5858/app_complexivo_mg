import 'package:flutter/material.dart';
import '../../data/models/producto.dart';
import '../../data/repositories/producto_repository.dart';
import 'create_product_screen.dart';
import 'details_product_screen.dart';
import 'edit_product_screen.dart'; // Asegúrate de que el import sea correcto

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

  Future<void> _deleteProduct(Producto producto) async {
    try {
      await eliminarProducto(producto.id);
      await _refreshProductos();
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  Future<void> _editProduct(Producto producto) async {
    final updatedProduct = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(producto: producto),
      ),
    );

    if (updatedProduct != null) {
      // Si se devolvió un producto actualizado, recargar la lista
      await _refreshProductos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Productos',
          style: TextStyle(color: Colors.blueGrey[100]),
        ),
        backgroundColor: Colors.blueGrey, // Color juvenil para la AppBar
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: _refreshProductos,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DataTable(
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Descripción')),
                        DataColumn(label: Text('Stock')),
                        DataColumn(label: Text('Acciones')),
                      ],
                      rows: _allProducts.map((producto) {
                        return DataRow(
                          cells: [
                            DataCell(Text(producto.id.toString())),
                            DataCell(Text(producto.description)),
                            DataCell(Text(producto.stock.toString())),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: Colors.blueGrey[300]),
                                    onPressed: () {
                                      _editProduct(
                                          producto); // Llamar a la función de editar
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Colors.blueGrey[300]),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Eliminar Producto'),
                                          content: Text(
                                              '¿Estás seguro de que deseas eliminar el producto ${producto.description}?'),
                                          actions: [
                                            TextButton(
                                              child: Text('Cancelar'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Eliminar'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                _deleteProduct(producto);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
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
        backgroundColor: Colors.blueGrey, // Color juvenil para el botón
        foregroundColor: Colors.blueGrey[50], // Color del ícono
        elevation: 6, // Sombra para un efecto flotante más pronunciado
        tooltip: 'Nuevo Producto',
      ),
    );
  }
}
