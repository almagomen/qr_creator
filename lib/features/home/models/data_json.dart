class Product {
  final int id;
  final String title;
  final double price;
  final String category;
  final String image;
  final int stock;
  final String unit;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.image,
    required this.stock,
    required this.unit,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['titulo'],
      price: json['precio'].toDouble(),
      category: json['categoria'],
      image: json['imagen'],
      stock: json['stock'],
      unit: json['unidad'],
    );
  }
}

final List<Map<String, dynamic>> productosSupermercado = [
  {
    'id': 1,
    'titulo': 'Leche Entera',
    'precio': 2.99,
    'categoria': 'Lácteos',
    'imagen':
        'https://th.bing.com/th?q=Leche+Entera+Con+Calcio&w=80&h=80&c=7&o=5&dpr=1.3&pid=1.7&mkt=es-XL&cc=VE&setlang=es&adlt=moderate&t=1',
    'stock': 50,
    'unidad': 'litro',
  },
  {
    'id': 2,
    'titulo': 'Pan Integral',
    'precio': 1.99,
    'categoria': 'Panadería',
    'imagen':
        'https://th.bing.com/th/id/OSK.04c14f8f98df7fd7b4ded9e82203464c?w=80&h=80&c=7&o=6&dpr=1.3&pid=SANGAM',
    'stock': 30,
    'unidad': 'unidad',
  },
  {
    'id': 3,
    'titulo': 'Manzanas',
    'precio': 0.50,
    'categoria': 'Frutas',
    'imagen':
        'https://th.bing.com/th?q=Manzanas+Verdes&w=100&h=100&c=7&o=5&dpr=1.3&pid=1.7&mkt=es-XL&cc=VE&setlang=es&adlt=moderate&t=1',
    'stock': 100,
    'unidad': 'kg',
  },
  {
    'id': 4,
    'titulo': 'Atún en Lata',
    'precio': 1.75,
    'categoria': 'Conservas',
    'imagen':
        'https://th.bing.com/th?q=Sardina+En+Lata&w=100&h=100&c=7&o=5&dpr=1.3&pid=1.7&mkt=es-XL&cc=VE&setlang=es&adlt=moderate&t=1',
    'stock': 80,
    'unidad': 'lata',
  },
  {
    'id': 5,
    'titulo': 'Papel Higiénico',
    'precio': 5.99,
    'categoria': 'Hogar',
    'imagen':
        'https://th.bing.com/th/id/OSK.f8a5a118d9cce39d2779c421fe342182?w=80&h=80&c=7&o=6&dpr=1.3&pid=SANGAM',
    'stock': 40,
    'unidad': 'paquete',
  },
  {
    'id': 6,
    'titulo': 'Arroz',
    'precio': 2.50,
    'categoria': 'Granos',
    'imagen':
        'https://th.bing.com/th/id/OSK.985b865638d34fed8f181d19797154f5?w=80&h=80&c=7&o=6&dpr=1.3&pid=SANGAM',
    'stock': 60,
    'unidad': 'kg',
  },
  {
    'id': 7,
    'titulo': 'Detergente',
    'precio': 4.99,
    'categoria': 'Limpieza',
    'imagen':
        'https://th.bing.com/th?q=Detergente+antibacterial&w=100&h=100&c=7&o=5&dpr=1.3&pid=1.7&mkt=es-XL&cc=VE&setlang=es&adlt=moderate&t=1',
    'stock': 45,
    'unidad': 'litro',
  },
  {
    'id': 8,
    'titulo': 'Yogurt Natural',
    'precio': 1.25,
    'categoria': 'Lácteos',
    'imagen':
        'https://th.bing.com/th/id/OSK.079109e3c4bb00332fbd7bd50429a32e?w=80&h=80&c=7&o=6&dpr=1.3&pid=SANGAM',
    'stock': 35,
    'unidad': 'unidad',
  },
];
