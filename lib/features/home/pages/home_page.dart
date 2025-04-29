import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:qr_creator/features/home/models/data_json.dart';
import 'package:qr_creator/features/home/widgets/shopping_cart_button.dart';
import 'package:qr_creator/features/home/widgets/products_view.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final products = useState<List<Product>>([]);
    final selectedProducts = useState<List<Product>>([]);
    final isLoading = useState(true);
    final selectedCategory = useState<String>('all');
    final showQR = useState(false);

    Future<void> fetchProducts() async {
      try {
        final List<Product> fetchedProducts =
            productosSupermercado
                .map((json) => Product.fromJson(json))
                .toList();
        products.value = fetchedProducts;
      } catch (e) {
        debugPrint('Error cargando productos: $e');
      } finally {
        isLoading.value = false;
      }
    }

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guapli Store'),
        actions: [
          ShoppingCartButton(
            selectedProducts: selectedProducts.value,
            onGenerateQR: () => showQR.value = true,
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
                onCategoryChanged: (category) => selectedCategory.value = category,
                getQRData: getQRData,
              ),
    );
  }
}
