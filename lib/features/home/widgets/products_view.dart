import 'package:flutter/material.dart';
import 'package:qr_creator/features/home/models/data_json.dart';
import 'package:qr_creator/features/home/widgets/product_card.dart';

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
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(10),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final product = products[index];
              return ProductCard(product: product, onGenerateQR: onGenerateQR);
            }, childCount: products.length),
          ),
        ),
      ],
    );
  }
}
