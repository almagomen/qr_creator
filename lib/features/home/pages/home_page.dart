import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:qr_creator/features/home/controllers/product_controller.dart';
import 'package:qr_creator/features/home/models/product.dart';
import 'package:qr_creator/features/home/widgets/products_view.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el controlador usando Modular
    final productController = Modular.get<ProductController>();

    // Estado que será observado por la UI
    final products = useState<List<Product>>([]);
    
    // Usamos un efecto para cargar los productos al iniciar
    useEffect(() {
      productController.loadProducts(products: products);
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(title: const Text('Guapli Store')),
      body: ProductsView(products: products.value),
    );
  }
}
