import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:qr_creator/features/home/models/data_json.dart';

class ProductService {
  final Dio _dio;

  ProductService() : _dio = Dio();

  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get(
        'https://api.escuelajs.co/api/v1/products',
      );

      if (response.statusCode == 200 && response.data is List) {
        final List<Product> products =
            (response.data as List)
                .map((json) => Product.fromJson(json))
                .toList();

        return products;
      
      } else {
        debugPrint('Error: Respuesta inesperada de la API');
        return [];
      }
    } catch (e) {
      debugPrint('Error cargando productos: $e');
      return [];
    }
  }
}
