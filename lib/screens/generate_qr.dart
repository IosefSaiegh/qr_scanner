import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class QrGeneratePage extends StatefulWidget {
  const QrGeneratePage({Key? key}) : super(key: key);

  @override
  State<QrGeneratePage> createState() => _QrGeneratePageState();
}

class _QrGeneratePageState extends State<QrGeneratePage> {
  TextEditingController qrDataTextController = TextEditingController();
  String? dummyData = '';
  late Uint8List _imageFile;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'QR Scanner',
          style: GoogleFonts.raleway(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Column(
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
              onChanged: (value) {
                setState(() {
                  dummyData = value;
                  dummyData = qrDataTextController.text == ""
                      ? null
                      : qrDataTextController.text;
                });
              },
            ),
          ),
          Visibility(
            visible: dummyData != null,
            child: ElevatedButton(
              child: Text(
                'Save QR Image',
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
                  screenshotController.capture().then((Uint8List? image) {
                    setState(() {
                      _imageFile = image!;
                    });
                    _save();
                  }).catchError((onError) {
                    print(onError);
                  });
                });
              },
            ),
          ),
          const SizedBox(height: 30),
          (dummyData == null || dummyData == '')
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Enter some text to display qr code...',
                      style: GoogleFonts.raleway(fontSize: 23),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Column(
                  children: [
                    Screenshot(
                      controller: screenshotController,
                      child: Container(
                        color: Colors.white,
                        child: QrImage(
                          data: dummyData.toString(),
                          gapless: true,
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  _save() async {
    final result = await ImageGallerySaver.saveImage(
      _imageFile,
      quality: 60,
      name: '${qrDataTextController.text} Code',
    );
    print(result);
  }
}
