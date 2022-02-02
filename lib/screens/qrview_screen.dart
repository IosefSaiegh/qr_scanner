import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_scanner/models/qr_code.dart';
import 'package:qr_scanner/screens/qr_detalle.dart';
import 'package:r_scan/r_scan.dart';
import 'package:url_launcher/url_launcher.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  RScanResult? resultPath;
  String? pathFile;
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: Colors.blue,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: scanArea,
          ),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
          cameraFacing: CameraFacing.back,
        ),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //TODO: Importar imagen de dispositivo
                  IconButton(
                    onPressed: () async {
                      await controller?.toggleFlash();
                      setState(() {});
                    },
                    icon: FutureBuilder(
                      future: controller?.getFlashStatus(),
                      builder: (context, snapshot) {
                        return Icon(
                          snapshot.data == true
                              ? PhosphorIcons.flashlightFill
                              : PhosphorIcons.flashlight,
                          size: 30,
                          color: Colors.blue,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: IconButton(
                onPressed: () async {
                  await controller?.flipCamera();
                  setState(() {});
                },
                icon: FutureBuilder(
                  future: controller?.getCameraInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return const Icon(
                        PhosphorIcons.cameraRotate,
                        color: Colors.blue,
                        size: 30,
                      );
                    } else {
                      return const Text('Loading..');
                    }
                  },
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: IconButton(
                onPressed: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    XFile imageFile = XFile(image.path);
                    setState(() {
                      pathFile = image.path;
                    });
                    resultPath = await RScan.scanImagePath(pathFile.toString());
                  }
                },
                icon: FutureBuilder(
                  future: controller?.getCameraInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return const Icon(
                        PhosphorIcons.filePlus,
                        color: Colors.blue,
                        size: 40,
                      );
                    } else {
                      return const Text('Loading..');
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Without Permission')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(flex: 4, child: _buildQrView(context)),
          FittedBox(
            fit: BoxFit.contain,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (result != null)
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    onPressed: () {
                      //TODO: PROBAR EL result.format A VER SI SIRVE Y PROBAE EL PAQUETE BARCODE_SCAN
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRDetalleScreen(
                            args: QrCodeModel(
                              data: result!.code.toString(),
                              type: result!.code!.startsWith('http://') ||
                                      result!.code!.startsWith('https://')
                                  ? 'Website'
                                  : result!.code!.length == 12
                                      ? 'Product'
                                      : 'Other',
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'View QR Code',
                      style: GoogleFonts.raleway(),
                    ),
                  )
                else if (resultPath != null)
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    onPressed: () {
                      //TODO: PROBAR EL result.format A VER SI SIRVE Y PROBAE EL PAQUETE BARCODE_SCAN
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRDetalleScreen(
                            args: QrCodeModel(
                              data: resultPath!.message.toString(),
                              type:
                                  resultPath!.message!.startsWith('http://') ||
                                          resultPath!.message!
                                              .startsWith('https://')
                                      ? 'Website'
                                      : resultPath!.message!.length == 12
                                          ? 'Product'
                                          : 'Other',
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'View QR Code',
                      style: GoogleFonts.raleway(),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Scan a code',
                      style: GoogleFonts.raleway(fontSize: 30),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
