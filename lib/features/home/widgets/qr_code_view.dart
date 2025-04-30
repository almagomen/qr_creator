import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gal/gal.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:typed_data';

class QRCodeView extends HookWidget {
  final String qrData;
  final VoidCallback onBack;

  const QRCodeView({super.key, required this.qrData, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final qrKey = useMemoized(() => GlobalKey(), []);
    final isSaving = useState(false);

    Future<void> saveQRToGallery() async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      isSaving.value = true;

      try {
        // Verificar y solicitar permisos
        final hasAccess = await Gal.hasAccess();
        if (!hasAccess) {
          final granted = await Gal.requestAccess();
          if (!granted) {
            scaffoldMessenger.showSnackBar(
              const SnackBar(
                content: Text('Permission denied to save to gallery'),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
            isSaving.value = false;
            return;
          }
        }

        // Capturar la imagen del QR
        RenderRepaintBoundary boundary =
            qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData = await image.toByteData(
          format: ui.ImageByteFormat.png,
        );

        if (byteData != null) {
          final Uint8List pngBytes = byteData.buffer.asUint8List();

          // Guardar en la galería
          try {
            await Gal.putImageBytes(pngBytes);

            // Mostrar mensaje de éxito
            scaffoldMessenger.showSnackBar(
              const SnackBar(
                content: Text('QR code saved to gallery'),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          } catch (e) {
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text('Error saving to gallery: ${e.toString()}'),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      } catch (e) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Error capturing QR: ${e.toString()}'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } finally {
        isSaving.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My QR code')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: RepaintBoundary(
                key: qrKey,
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 250.0,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onBack,
                      child: const Text('Back'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child:
                        isSaving.value
                            ? const Center(child: CircularProgressIndicator())
                            : OutlinedButton(
                              onPressed: () => saveQRToGallery(),
                              child: const Text('Save to Gallery'),
                            ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
