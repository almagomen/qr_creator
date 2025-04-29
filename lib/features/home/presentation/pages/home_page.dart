import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:dio/dio.dart';

class Product {
  final int id;
  final String title;
  final double price;
  final String category;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      category: json['category'],
      image: json['image'],
    );
  }
}

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final products = useState<List<Product>>([]);
    final selectedProducts = useState<List<Product>>([]);
    final isLoading = useState(true);
    final selectedCategory = useState<String>('all');
    final showQR = useState(false);

    Future<void> fetchProducts() async {
      try {
        final dio = Dio();
        final response = await dio.get(
          'https://api.escuelajs.co/api/v1/products',
        );
        final List<Product> fetchedProducts =
            (response.data as List)
                .map((json) => Product.fromJson(json))
                .toList();
        products.value = fetchedProducts;
      } catch (e) {
        print('Error fetching products: $e');
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      fetchProducts();
      return null;
    }, []);

    List<Product> getFilteredProducts() {
      if (selectedCategory.value == 'all') {
        return products.value;
      }
      return products.value
          .where((product) => product.category == selectedCategory.value)
          .toList();
    }

    void toggleProductSelection(Product product) {
      if (selectedProducts.value.contains(product)) {
        selectedProducts.value =
            selectedProducts.value.where((p) => p.id != product.id).toList();
      } else {
        selectedProducts.value = [...selectedProducts.value, product];
      }
    }

    String getQRData() {
      return selectedProducts.value
          .map(
            (product) => {
              'id': product.id,
              'title': product.title,
              'price': product.price,
              'category': product.category,
            },
          )
          .toList()
          .toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Platzi Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Carrito'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...selectedProducts.value.map(
                            (product) => ListTile(
                              title: Text(product.title),
                              subtitle: Text('\$${product.price}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.remove_shopping_cart),
                                onPressed:
                                    () => toggleProductSelection(product),
                              ),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            showQR.value = true;
                            Navigator.pop(context);
                          },
                          child: const Text('Generar QR'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body:
          isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ChoiceChip(
                          label: const Text('Todos'),
                          selected: selectedCategory.value == 'all',
                          onSelected: (_) => selectedCategory.value = 'all',
                        ),
                        ...products.value
                            .map((product) => product.category)
                            .toSet()
                            .map(
                              (category) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: ChoiceChip(
                                  label: Text(category),
                                  selected: selectedCategory.value == category,
                                  onSelected:
                                      (_) => selectedCategory.value = category,
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemCount: getFilteredProducts().length,
                      itemBuilder: (context, index) {
                        final product = getFilteredProducts()[index];
                        return Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Image.network(
                                  product.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '\$${product.price}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        selectedProducts.value.contains(product)
                                            ? Icons.check_circle
                                            : Icons.add_shopping_cart,
                                      ),
                                      onPressed:
                                          () => toggleProductSelection(product),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  if (showQR.value)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: QrImageView(
                        data: getQRData(),
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                ],
              ),
    );
  }
}
