import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:qr_creator/features/home/controllers/product_controller.dart';
import 'package:qr_creator/features/home/models/product.dart';
import 'package:qr_creator/features/home/pages/home_page.dart';
import 'package:qr_creator/features/home/services/product_service.dart';
import 'package:qr_creator/features/home/services/qr_gallery_service.dart';
import 'package:qr_creator/features/home/widgets/qr_code_example.dart';
import 'package:qr_creator/features/home/widgets/qr_code_view.dart';

class HomeModule extends Module {
  @override
  void binds(i) {
    i.add(ProductService.new);
    i.add(ProductController.new);
    i.add(QrGalleryService.new);
  }

  @override
  void routes(r) {
    // Crear un producto de ejemplo para el QR
    final exampleProduct = Product(
      id: 1,
      title: 'Producto de ejemplo',
      price: 29.99,
      description: 'Este es un producto de ejemplo para mostrar el código QR',
      category: 'Ejemplo',
      images: ['https://placehold.co/600x400'],
    );

    // Convertir el producto a JSON y luego a String para el QR
    final productJson = jsonEncode({
      'id': exampleProduct.id,
      'title': exampleProduct.title,
      'price': exampleProduct.price,
      'description': exampleProduct.description,
      'category': exampleProduct.category,
      'images': exampleProduct.images,
    });

    r.child('/example', child: (context) => QrCodeExample(data: productJson));
    r.child('/', child: (context) => const HomePage());
    r.child('/qr', child: (context) => QRCodeView(qrData: r.args.data));
  }
}
