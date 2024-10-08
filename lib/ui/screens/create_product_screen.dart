import 'package:flutter/material.dart';
import '../../data/models/producto.dart';
import '../../data/repositories/producto_creation_repository.dart';

class CreateProductScreen extends StatefulWidget {
  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _descriptionController = TextEditingController();
  final _stockController = TextEditingController();
  final _priceController = TextEditingController();

  final productoCreationRepository = ProductoCreationRepository();

  void _crearProducto() async {
    final description = _descriptionController.text;
    final stock = int.tryParse(_stockController.text) ?? 0;
    final price = _priceController.text;

    final producto = Producto(
      id: 0, // El ID será generado por el servidor
      description: description,
      stock: stock,
      price: price,
    );

    try {
      await productoCreationRepository.crearProducto(producto);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Producto creado con éxito',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear producto')),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Nuevo Producto',
            style: TextStyle(color: Colors.blueGrey[100])),
        backgroundColor: Colors.blueGrey, // Color juvenil para la AppBar
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 600, // Limita el ancho del contenido
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _stockController,
                    decoration: InputDecoration(
                      labelText: 'Stock',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: 'Precio',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: _crearProducto,
                    child: Text('Guardar Producto'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blueGrey[50],
                      backgroundColor: Colors.blueGrey,
                      minimumSize:
                          Size(double.infinity, 50), // Botón a ancho completo
                      padding: EdgeInsets.symmetric(
                          vertical: 14.0), // Padding vertical
                      textStyle: TextStyle(
                        fontSize: 16,
                      ),

                      elevation: 5, // Sombra sutil
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
