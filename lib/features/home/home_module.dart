import 'package:flutter_modular/flutter_modular.dart';
import 'package:qr_creator/features/home/controllers/product_controller.dart';
import 'package:qr_creator/features/home/pages/home_page.dart';
import 'package:qr_creator/features/home/services/product_service.dart';
import 'package:qr_creator/features/home/widgets/qr_code_view.dart';

class HomeModule extends Module {
  @override
  void binds(i) {
    i.add(ProductService.new);
    i.add(ProductController.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const HomePage());
    r.child('/qr', child: (context) =>
      QRCodeView(
        qrData: r.args.data, 
        onBack: () => Modular.to.pop()),
    );
  }
}
