import 'package:flutter/material.dart';
import 'package:qr_creator/features/home/models/product.dart';
import 'package:qr_creator/features/home/services/product_service.dart';

class ProductController {
  final ProductService _productService;

  ProductController(this._productService);

  // Método para obtener productos desde el servicio
  Future<List<Product>> fetchProducts() async {
    try { return await _productService.getProducts();}
    catch (e) {
      debugPrint('Error en el controlador: $e');
      return [];
    }
  }

  // Método para cargar productos
  Future<void> loadProducts({
    required ValueNotifier<List<Product>> products,
  }) async {
    try {
      final fetchedProducts = await fetchProducts();
      products.value = fetchedProducts;
    } catch (e) {
      debugPrint('Error cargando productos: $e');
    }
  }
}
