import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_creator/features/home/models/data_json.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({
    super.key,
    required this.products,
    required this.selectedProducts,
    required this.selectedCategory,
    required this.showQR,
    required this.toggleProductSelection,
    required this.onCategoryChanged,
    required this.getQRData,
  });

  final List<Product> products;
  final List<Product> selectedProducts;
  final String selectedCategory;
  final bool showQR;
  final Function(Product) toggleProductSelection;
  final Function(String) onCategoryChanged;
  final String Function() getQRData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCategoryFilter(),
        _buildProductsGrid(),
        if (showQR) _buildQRCode(),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('Todos'),
            selected: selectedCategory == 'all',
            onSelected: (_) => onCategoryChanged('all'),
          ),
          ...products
              .map((product) => product.category)
              .toSet()
              .map(
                (category) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (_) => onCategoryChanged(category),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid() {
    final filteredProducts =
        products
            .where(
              (product) =>
                  selectedCategory == 'all' ||
                  product.category == selectedCategory,
            )
            .toList();

    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '\$${product.price}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(
                          selectedProducts.contains(product)
                              ? Icons.check_circle
                              : Icons.add_shopping_cart,
                        ),
                        onPressed: () => toggleProductSelection(product),
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

  Widget _buildQRCode() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: QrImageView(
        data: getQRData(),
        version: QrVersions.auto,
        size: 200.0,
      ),
    );
  }
}
