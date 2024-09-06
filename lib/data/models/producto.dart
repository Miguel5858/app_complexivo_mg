class Producto {
  final int id;
  final String description;
  final int stock;
  final String price;

  Producto({
    required this.id,
    required this.description,
    required this.stock,
    required this.price,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      description: json['description'],
      stock: json['stock'],
      price: json['price'],
    );
  }
}
