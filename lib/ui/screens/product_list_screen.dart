import 'package:app_complexivo_mg/ui/screens/create_product_screen.dart';
import 'package:flutter/material.dart';
import '../../data/models/producto.dart';
import '../../data/repositories/producto_repository.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Producto>> futureProductos;

  @override
  void initState() {
    super.initState();
    futureProductos = obtenerProductos();
  }

  Future<void> _refreshProductos() async {
    setState(() {
      futureProductos = obtenerProductos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Productos'),
      ),
      body: Center(
        child: FutureBuilder<List<Producto>>(
          future: futureProductos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return RefreshIndicator(
                onRefresh: _refreshProductos,
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var producto = snapshot.data![index];
                    return ListTile(
                      title: Text(producto.description),
                      subtitle: Text('Precio: ${producto.price}'),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navegar a la pantalla de creación de productos y esperar a que vuelva
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateProductScreen()),
          );
          // Después de regresar, actualizar la lista de productos
          _refreshProductos();
        },
        child: Icon(Icons.add),
        tooltip: 'Nuevo Producto',
      ),
    );
  }
}
