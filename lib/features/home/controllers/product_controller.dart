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

  // Método para cargar productos y manejar estados
  Future<void> loadProducts({
    required ValueNotifier<bool> isLoading,
    required ValueNotifier<List<Product>> products,
  }) async {
    isLoading.value = true;
    try {
      final fetchedProducts = await fetchProducts();
      products.value = fetchedProducts;
    } catch (e) {
      debugPrint('Error cargando productos: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
