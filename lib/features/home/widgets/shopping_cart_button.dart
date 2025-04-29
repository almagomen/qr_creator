import 'package:flutter/material.dart';
import 'package:qr_creator/features/home/models/data_json.dart';

class ShoppingCartButton extends StatelessWidget {
  const ShoppingCartButton({
    super.key,
    required this.selectedProducts,
    required this.onGenerateQR,
    required this.onRemoveItem,
  });

  final List<Product> selectedProducts;
  final VoidCallback onGenerateQR;
  final Function(Product) onRemoveItem;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.shopping_cart),
      onPressed: () {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Carrito'),
                content: _buildCartItemsList(),
                actions: [
                  TextButton(
                    onPressed: () {
                      onGenerateQR();
                      Navigator.pop(context);
                    },
                    child: const Text('Generar QR'),
                  ),
                ],
              ),
        );
      },
    );
  }

  Widget _buildCartItemsList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...selectedProducts.map(
          (product) => ListTile(
            title: Text(product.title),
            subtitle: Text('\$${product.price}'),
            trailing: IconButton(
              icon: const Icon(Icons.remove_shopping_cart),
              onPressed: () => onRemoveItem(product),
            ),
          ),
        ),
      ],
    );
  }
}
