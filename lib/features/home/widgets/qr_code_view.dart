import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_creator/features/home/services/qr_gallery_service.dart';

class QRCodeView extends HookWidget {
  final String qrData;
  const QRCodeView({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el servicio de galería usando Modular
    final qrGalleryService = Modular.get<QrGalleryService>();

    // Hooks para estado y referencias
    final qrKey = useMemoized(() => GlobalKey(), []);
    final isSaving = useState(false);

    // Intentamos decodificar los datos del QR para mostrar información
    Map<String, dynamic>? productData;
    String productTitle = "Producto";
    try {
      productData = jsonDecode(qrData) as Map<String, dynamic>;
      productTitle = productData?['title'] ?? "Producto";
    } catch (e) {
      // Si hay error al decodificar, usamos valores por defecto
    }

    // Función para guardar el QR utilizando el servicio
    Future<void> saveQRToGallery() async {
      await qrGalleryService.saveQrToGallery(
        qrKey: qrKey,
        context: context,
        isSaving: isSaving,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Código QR: $productTitle'),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Modular.to.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título y descripción
              Card(
                margin: const EdgeInsets.only(bottom: 24),
                elevation: 0,
                color: const Color(0xFFF9F9F9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.qr_code,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Código QR generado",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              productTitle,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Código QR
              Expanded(
                child: Center(
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: RepaintBoundary(
                        key: qrKey,
                        child: QrImageView(
                          data: qrData,
                          version: QrVersions.auto,
                          size: 250,
                          backgroundColor: Colors.white,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.circle,
                            color: Color.fromARGB(255, 130, 0, 121),
                          ),
                          embeddedImage: NetworkImage(
                            'https://th.bing.com/th/id/OIP.-JoHf34bh-bLDHAA6gG4FwHaHa?rs=1&pid=ImgDetMain',
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.circle,
                            color: Color.fromARGB(255, 139, 0, 116),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Botón de guardar
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child:
                      isSaving.value
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                            onPressed: saveQRToGallery,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save_alt),
                                SizedBox(width: 8),
                                Text(
                                  'Guardar en Galería',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
