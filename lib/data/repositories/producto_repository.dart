import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';

Future<List<Producto>> obtenerProductos() async {
  final Map<String, dynamic> requestBody = {
    "search": {
      "scopes": [],
      "filters": [],
      "sorts": [
        {"field": "id", "direction": "desc"}
      ],
      "selects": [
        {"field": "id"},
        {"field": "description"},
        {"field": "stock"},
        {"field": "price"}
      ],
      "includes": [],
      "aggregates": [],
      "instructions": [],
      "gates": ["create", "update", "delete"],
      "page": 1, // Siempre empieza desde la primera página
      "limit": 10 // Usar un valor alto para obtener todos los productos
    }
  };

  try {
    final response = await http.post(
      Uri.parse('http://192.168.3.90:8000/api/products/search'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse.containsKey('data')) {
        if (jsonResponse['data'] is List) {
          List<dynamic> productos = jsonResponse['data'];
          return productos.map((data) => Producto.fromJson(data)).toList();
        } else {
          throw Exception(
              'La estructura de la respuesta no contiene una lista de productos');
        }
      } else {
        throw Exception(
            'No se encontró la clave "data" en la respuesta de la API');
      }
    } else {
      // Imprime el cuerpo de la respuesta para depurar
      print('Respuesta del servidor: ${response.body}');
      throw Exception('Error al cargar los productos: ${response.statusCode}');
    }
  } catch (e) {
    // Imprime cualquier excepción que ocurra
    print('Excepción: $e');
    rethrow;
  }
}

Future<void> eliminarProducto(int productoId) async {
  // Construye el cuerpo de la solicitud con el ID del producto
  final Map<String, dynamic> requestBody = {
    "resources": [productoId]
  };

  try {
    // Envía la solicitud DELETE con el cuerpo
    final response = await http.delete(
      Uri.parse('http://192.168.3.90:8000/api/products/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Producto eliminado con éxito');
    } else {
      print('Respuesta del servidor: ${response.body}');
      throw Exception('Error al eliminar el producto: ${response.statusCode}');
    }
  } catch (e) {
    print('Excepción: $e');
    rethrow;
  }
}
