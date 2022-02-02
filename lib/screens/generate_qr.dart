import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrGeneratePage extends StatefulWidget {
  QrGeneratePage({Key? key}) : super(key: key);

  @override
  State<QrGeneratePage> createState() => _QrGeneratePageState();
}

class _QrGeneratePageState extends State<QrGeneratePage> {
  TextEditingController qrDataTextController = TextEditingController();
  String? dummyData = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextField(
            controller: qrDataTextController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              hintText: 'Enter web url',
              labelText: 'URL',
              hintStyle: GoogleFonts.raleway(),
              labelStyle: GoogleFonts.raleway(),
            ),
          ),
        ),
        ElevatedButton(
          child: Text(
            'Create QR',
            style: GoogleFonts.raleway(),
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
          onPressed: () {
            setState(() {
              dummyData = qrDataTextController.text == ""
                  ? null
                  : qrDataTextController.text;
            });
          },
        ),
        SizedBox(height: 30),
        (dummyData == null || dummyData == '')
            ? Center(
                child: Text(
                  'Enter some text to display qr code...',
                  style: GoogleFonts.raleway(fontSize: 23),
                ),
              )
            : QrImage(
                data: dummyData.toString(),
                gapless: true,
              ),
      ],
    );
  }
}
