import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:qr_creator/features/home/models/product.dart';

class QRGenerateButton extends StatelessWidget {
  final Product product;

  const QRGenerateButton({super.key, required this.product});

  void _navegateQr() {
    final productMap = {
      'id': product.id,
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'category': product.category,
      'images': product.images[0],
    };
    final qrData = jsonEncode(productMap);
    Modular.to.pushNamed('/qr', arguments: qrData);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.qr_code),
        label: const Text('Generar QR', style: TextStyle(fontSize: 12)),
        onPressed: _navegateQr,
      ),
    );
  }
}
