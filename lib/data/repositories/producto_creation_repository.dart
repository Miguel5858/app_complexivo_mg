import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';

class ProductoCreationRepository {
  final String url = 'http://192.168.3.16:8000/api/products/mutate';

  Future<void> crearProducto(Producto producto) async {
    final Map<String, dynamic> requestBody = {
      'mutate': [
        {
          'operation': 'create',
          'attributes': {
            'id':
                '', // El ID será generado por el servidor o puede ser opcional
            'description': producto.description,
            'stock': producto.stock.toString(), // Convertir el stock a String
            'price': producto.price,
          },
          'relations': []
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
        print('Producto creado: ${response.body}');
      } else {
        final responseBody = jsonDecode(response.body);
        final errorMessage = responseBody['error'] ?? 'Error desconocido';
        throw Exception(
            'Error al crear el producto: ${response.statusCode} - $errorMessage');
      }
    } catch (e) {
      print('Error al crear producto: $e');
      throw Exception('Error al crear el producto: $e');
    }
  }
}
