import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';

/// Servicio encargado de guardar imágenes QR en la galería
class QrGalleryService {
  /// Guarda una imagen QR en la galería del dispositivo usando una clave global
  /// que referencia al widget RepaintBoundary que contiene el QR
  Future<bool> saveQrToGallery({
    required GlobalKey qrKey,
    required BuildContext context,
    required ValueNotifier<bool> isSaving,
  }) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    isSaving.value = true;

    try {
      // Verificar y solicitar permisos
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          _showErrorMessage(
            scaffoldMessenger,
            'Permission denied to save to gallery',
          );
          return false;
        }
      }

      // Capturar la imagen del QR
      final boundary =
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData != null) {
        final Uint8List pngBytes = byteData.buffer.asUint8List();

        // Guardar en la galería
        try {
          await Gal.putImageBytes(pngBytes);
          _showSuccessMessage(scaffoldMessenger, 'QR code saved to gallery');
          return true;
        } catch (e) {
          _showErrorMessage(
            scaffoldMessenger,
            'Error saving to gallery: ${e.toString()}',
          );
          return false;
        }
      }

      return false;
    } catch (e) {
      _showErrorMessage(
        scaffoldMessenger,
        'Error capturing QR: ${e.toString()}',
      );
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  /// Muestra un mensaje de éxito
  void _showSuccessMessage(
    ScaffoldMessengerState scaffoldMessenger,
    String message,
  ) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Muestra un mensaje de error
  void _showErrorMessage(
    ScaffoldMessengerState scaffoldMessenger,
    String message,
  ) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
