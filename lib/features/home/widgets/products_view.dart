import 'package:flutter/material.dart';
import 'package:qr_creator/features/home/models/data_json.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({
    super.key,
    required this.products,
    required this.onGenerateQR,
  });

  final List<Product> products;
  final Function(Product) onGenerateQR;

  @override
  Widget build(BuildContext context) {
    return Column(children: [_buildProductsGrid()]);
  }

  Widget _buildProductsGrid() {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.network(
                    product.images.isNotEmpty
                        ? product.images[0]
                        : 'https://placehold.co/600x400',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.image_not_supported, size: 50),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${product.price}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.qr_code),
                          label: const Text(
                            'Generar QR',
                            style: TextStyle(fontSize: 12),
                          ),
                          onPressed: () => onGenerateQR(product),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
