import 'package:flutter/material.dart';
import '../../data/models/producto.dart';
import '../../data/repositories/producto_update_repository.dart';

class EditProductScreen extends StatefulWidget {
  final Producto producto;

  EditProductScreen({required this.producto});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _descriptionController = TextEditingController();
  final _stockController = TextEditingController();
  final _priceController = TextEditingController();

  final productoUpdateRepository = ProductoUpdateRepository();

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.producto.description;
    _stockController.text = widget.producto.stock.toString();
    _priceController.text = widget.producto.price;
  }

  void _updateProduct() async {
    final updatedProducto = Producto(
      id: widget.producto.id,
      description: _descriptionController.text,
      stock: int.tryParse(_stockController.text) ?? 0,
      price: _priceController.text,
    );

    try {
      await productoUpdateRepository.actualizarProducto(updatedProducto);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Producto actualizado con éxito',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ),
      );
      // Retorna el producto actualizado al cerrar la pantalla
      Navigator.pop(context, updatedProducto);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar producto')),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Producto',
            style: TextStyle(color: Colors.blueGrey[100])),
        backgroundColor: Colors.blueGrey, // Estilo juvenil para la AppBar
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 600, // Limitar ancho del contenido
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
                    onPressed: _updateProduct,
                    child: Text('Guardar Cambios'),
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
