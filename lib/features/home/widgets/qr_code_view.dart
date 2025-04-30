import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeView extends HookWidget {
  final String qrData;
  final VoidCallback onBack;

  const QRCodeView({super.key, required this.qrData, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final qrKey = useMemoized(() => GlobalKey(), []);
    final isSaving = useState(false);

    void simulateSaveQR() {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      isSaving.value = true;

      // Simular una pequeña demora
      Future.delayed(const Duration(milliseconds: 800), () {
        isSaving.value = false;

        // Mostrar mensaje de éxito
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('QR code saved successfully'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
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
                              onPressed: () => simulateSaveQR(),
                              child: const Text('Save'),
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
