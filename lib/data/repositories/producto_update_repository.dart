import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';

class ProductoUpdateRepository {
  final String url = 'http://192.168.3.90:8000/api/products/mutate';

  Future<void> actualizarProducto(Producto producto) async {
    final Map<String, dynamic> requestBody = {
      'mutate': [
        {
          'operation': 'update',
          'key': producto.id, // ID del producto a actualizar
          'attributes': {
            'description': producto.description,
            'stock': producto.stock.toString(), // Convertir el stock a String
            'price': producto.price,
          },
        }
      ]
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Considerar 200 OK o 201 Created como respuestas exitosas
        print('Producto actualizado: ${response.body}');
      } else {
        final responseBody = jsonDecode(response.body);
        final errorMessage = responseBody['error'] ?? 'Error desconocido';
        throw Exception(
            'Error al actualizar el producto: ${response.statusCode} - $errorMessage');
      }
    } catch (e) {
      print('Error al actualizar producto: $e');
      throw Exception('Error al actualizar el producto: $e');
    }
  }
}
