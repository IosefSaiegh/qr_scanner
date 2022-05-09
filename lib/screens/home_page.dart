import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:qr_scanner/screens/generate_qr.dart';
import 'package:qr_scanner/screens/history_screen.dart';
import 'package:qr_scanner/screens/qrview_screen.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({Key? key}) : super(key: key);

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  late final List<Widget> _widgetOptions = [
    const QRScanPage(),
    const QrGeneratePage(),
    const QrHistoryScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.scan),
              label: 'Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.plusCircle),
              label: 'Create QR',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.clockCounterClockwise),
              label: 'History',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
          showUnselectedLabels: false,
          selectedLabelStyle: GoogleFonts.raleway(),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
