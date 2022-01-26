import 'package:flutter/material.dart';
import 'package:qr_scanner/qrview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Escaneador de Codigo QR',
      home: QRScanScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
