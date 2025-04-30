import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:qr_creator/features/home/controllers/product_controller.dart';
import 'package:qr_creator/features/home/models/data_json.dart';
import 'package:qr_creator/features/home/widgets/products_view.dart';
import 'package:qr_creator/features/home/widgets/shopping_cart_button.dart';
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
    final selectedCategory = useState<String>('all');

    // Estados adicionales específicos de esta vista
    final selectedProducts = useState<List<Product>>([]);
    final showQR = useState(false);

    Future<void> fetchProducts() async {
      isLoading.value = true;
      try {
        final fetchedProducts = await productController.fetchProducts();
        products.value = fetchedProducts;
      } catch (e) {
        debugPrint('Error cargando productos: $e');
      } finally {
        isLoading.value = false;
      }
    }

    // Usamos un efecto para cargar los productos al iniciar
    useEffect(() {
      fetchProducts();
      return null;
    }, []);

    void toggleProductSelection(Product product) {
      if (selectedProducts.value.contains(product)) {
        selectedProducts.value =
            selectedProducts.value.where((p) => p.id != product.id).toList();
      } else {
        selectedProducts.value = [...selectedProducts.value, product];
      }
    }

    String getQRData() {
      return selectedProducts.value
          .map(
            (product) => {
              'id': product.id,
              'title': product.title,
              'price': product.price,
              'category': product.category,
            },
          )
          .toList()
          .toString();
    }

    void showQRCodeView() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => QRCodeView(
                qrData: getQRData(),
                onBack: () => Navigator.of(context).pop(),
              ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Platzi Store'),
        actions: [
          ShoppingCartButton(
            selectedProducts: selectedProducts.value,
            onGenerateQR: showQRCodeView,
            onRemoveItem: toggleProductSelection,
          ),
        ],
      ),

      body:
          isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : ProductsView(
                products: products.value,
                selectedProducts: selectedProducts.value,
                selectedCategory: selectedCategory.value,
                showQR: showQR.value,
                toggleProductSelection: toggleProductSelection,
                onCategoryChanged:
                    (category) => selectedCategory.value = category,
                getQRData: getQRData,
              ),
    );
  }
}
