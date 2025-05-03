class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    String categoryName = '';
    if (json['category'] != null && json['category'] is Map) {
      categoryName = json['category']['name'] ?? '';
    } else if (json['category'] != null && json['category'] is String) {
      categoryName = json['category'];
    }

    List<String> imagesList = [];
    if (json['images'] != null) {
      if (json['images'] is List) {
        imagesList = List<String>.from(
          (json['images'] as List).map((image) => image.toString()),
        );
      } else if (json['images'] is String) {
        imagesList = [json['images']];
      }
    }

    if (imagesList.isEmpty) {
      imagesList = ['https://placehold.co/600x400'];
    }

    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      description: json['description'] ?? '',
      category: categoryName,
      images: imagesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'images': images,
    };
  }
}

