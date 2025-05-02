import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Este es un ejemplo de cómo se puede usar el QrImageContainer
/// en cualquier parte de la aplicación.
class QrCodeExample extends StatelessWidget {
  final String data;

  const QrCodeExample({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ejemplo de QR')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ejemplo básico con valores por defecto
                const Text(
                  'QR básico',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                QrImageView(data: data),

                const SizedBox(height: 40),

                // Ejemplo personalizado
                const Text(
                  'QR personalizado',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                QrImageView(
                  data: data,
                  size: 200.0,
                  // foregroundColor: Colors.blue,
                  backgroundColor: Colors.yellow.shade100,
                  // decoration: BoxDecoration(
                  //   color: Colors.yellow.shade100,
                  //   borderRadius: BorderRadius.circular(16),
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: Colors.black.withOpacity(0.2),
                  //       blurRadius: 10,
                  //       spreadRadius: 2,
                  //     ),
                  //   ],
                  // ),
                ),

                const SizedBox(height: 40),

                // Ejemplo con una clave global (GlobalKey) que permite capturar el widget como imagen
                // Esta técnica se usa en QRCodeView para guardar el QR en la galería
                const Text(
                  'QR con captura',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Este QR usa GlobalKey para poder convertir el widget en una imagen PNG. '
                    'Esto permite guardar el QR o compartirlo como imagen.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 10),
                Builder(
                  builder: (context) {
                    final captureKey = GlobalKey();

                    return Column(
                      children: [
                        QrImageView(
                          data: data,
                          
                          size: 150.0,
                          padding: const EdgeInsets.all(8.0),
                          // foregroundColor: Colors.green,
                        ),

                        const SizedBox(height: 10),

                        ElevatedButton(
                          onPressed: () {
                            // Aquí podría implementar la captura usando captureKey
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Esta instancia tiene una clave para captura',
                                ),
                              ),
                            );
                          },
                          child: const Text('Capturar QR'),
                        ),
                      ],
                    );
                  },
                ),

                // Añadir más ejemplos para demostrar scroll
                const SizedBox(height: 40),

                const Text(
                  'QR con colores personalizados',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                QrImageView(
                  data: data,
                  size: 180.0,
                  // foregroundColor: Colors.deepPurple,
                  backgroundColor: Colors.amber.shade50,
                  // decoration: BoxDecoration(
                  //   gradient: LinearGradient(
                  //     colors: [Colors.amber.shade100, Colors.amber.shade200],
                  //     begin: Alignment.topLeft,
                  //     end: Alignment.bottomRight,
                  //   ),
                  //   borderRadius: BorderRadius.circular(12),
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: Colors.deepPurple.withOpacity(0.2),
                  //       blurRadius: 8,
                  //       spreadRadius: 1,
                  //     ),
                  //   ],
                  // ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
