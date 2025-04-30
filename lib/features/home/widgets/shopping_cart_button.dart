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
        // Crear una copia local de los productos seleccionados
        List<Product> localSelectedProducts = List.from(selectedProducts);

        showDialog(
          context: context,
          builder:
              (context) => StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: const Text('Carrito'),
                    content:
                        localSelectedProducts.isEmpty
                            ? Text('El carrito está vacío')
                            : ListView.builder(
                              shrinkWrap: true,
                              itemCount: localSelectedProducts.length,
                              itemBuilder: (context, index) {
                                final product = localSelectedProducts[index];
                                return ListTile(
                                  title: Text(product.title),
                                  subtitle: Text('\$${product.price}'),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.remove_shopping_cart,
                                    ),
                                    onPressed: () {
                                      // Llamar a la función de eliminación
                                      onRemoveItem(product);

                                      // Actualizar la lista local
                                      setState(() {
                                        localSelectedProducts.removeWhere(
                                          (p) => p.id == product.id,
                                        );
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                    actions: [
                      TextButton(
                        onPressed:
                            localSelectedProducts.isEmpty
                                ? null
                                : () {
                                  Navigator.of(context).pop();
                                  onGenerateQR();
                                },
                        child: const Text('Generar QR'),
                      ),
                    ],
                  );
                },
              ),
        );
      },
    );
  }
}
