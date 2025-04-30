import 'package:flutter/material.dart';
import 'package:qr_creator/features/home/models/data_json.dart';
import 'package:qr_creator/features/home/services/product_service.dart';

class ProductController {
  final ProductService _productService;

  ProductController(this._productService);

  // Método para obtener productos desde el servicio
  Future<List<Product>> fetchProducts() async {
    try {
      return await _productService.getProducts();
    } catch (e) {
      debugPrint('Error en el controlador: $e');
      return [];
    }
  }
}
