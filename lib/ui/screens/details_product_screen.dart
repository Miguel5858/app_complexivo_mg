import 'package:flutter/material.dart';
import 'package:app_complexivo_mg/data/models/producto.dart';

class DetailsProductoScreen extends StatelessWidget {
  final Producto producto;

  DetailsProductoScreen({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Mostrar el icono del producto
                  Icon(
                    Icons
                        .production_quantity_limits, // Cambia este icono según sea necesario
                    size: 100, // Ajusta el tamaño según sea necesario
                    color:
                        Colors.blueGrey, // Cambia el color según sea necesario
                  ),
                  SizedBox(height: 16),
                  // Información del producto
                  Text(
                    'Descripción: ${producto.description}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text('Stock: ${producto.stock}',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Precio: ${producto.price}',
                      style: TextStyle(fontSize: 18)),
                  // Agrega más campos si es necesario
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
