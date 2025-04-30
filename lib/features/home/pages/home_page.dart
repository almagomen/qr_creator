import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:qr_creator/features/home/controllers/product_controller.dart';
import 'package:qr_creator/features/home/models/data_json.dart';
import 'package:qr_creator/features/home/widgets/products_view.dart';
import 'package:qr_creator/features/home/widgets/qr_code_view.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el controlador usando Modular
    final productController = Modular.get<ProductController>();

    // Estados que serán observados por la UI
    final products = useState<List<Product>>([]);
    final isLoading = useState<bool>(true);

    // Usamos un efecto para cargar los productos al iniciar
    useEffect(() {
      productController.loadProducts(isLoading: isLoading, products: products);
      return null;
    }, []);

    // Función para generar QR de un solo producto
    void showProductQR(Product product) {
      final qrData =
          {
            'id': product.id,
            'title': product.title,
            'price': product.price,
            'category': product.category,
          }.toString();

      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => QRCodeView(
                qrData: qrData,
                onBack: () => Navigator.of(context).pop(),
              ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Guapli Store')),
      body:
          isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : ProductsView(products: products.value, onGenerateQR: showProductQR),
    );
  }
}
