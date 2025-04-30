import 'package:flutter/material.dart';
import 'package:qr_creator/features/home/models/data_json.dart';

/// Widget que representa una tarjeta de producto en la cuadrícula de productos
class ProductCard extends StatelessWidget {
  final Product product;
  final Function(Product) onGenerateQR;

  const ProductCard({
    super.key,
    required this.product,
    required this.onGenerateQR,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_buildProductImage(), _buildProductInfo()],
      ),
    );
  }

  Widget _buildProductImage() {
    return Expanded(
      child: Image.network(
        product.images.isNotEmpty
            ? product.images[0]
            : 'https://placehold.co/600x400',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.image_not_supported, size: 50));
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value:
                  loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(
            '\$${product.price}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildQRButton(),
        ],
      ),
    );
  }

  Widget _buildQRButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.qr_code),
        label: const Text('Generar QR', style: TextStyle(fontSize: 12)),
        onPressed: () => onGenerateQR(product),
      ),
    );
  }
}
