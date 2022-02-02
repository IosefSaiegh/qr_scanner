import 'package:flutter/material.dart';
import 'package:qr_scanner/screens/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'QR Scanner',
      home: QrScanScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
