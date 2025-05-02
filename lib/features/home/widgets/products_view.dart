import 'package:flutter/material.dart';
import 'package:qr_creator/features/home/models/product.dart';
import 'package:qr_creator/features/home/widgets/product_card.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final product = products[index];
              return ProductCard(product: product);
            }, childCount: products.length),
          ),
        ),
      ],
    );
  }
}
