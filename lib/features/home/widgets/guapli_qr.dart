import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GuapliQr extends StatelessWidget {
  const GuapliQr({
    super.key,
    required this.qrData,
  });

  final String qrData;

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: qrData,
      version: QrVersions.auto,
      size: 250,
      backgroundColor: Colors.white,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.circle,
        color: Colors.blue,
      ),
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.circle,
        color: Colors.blue,
      ),
    );
  }
}