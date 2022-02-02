import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:qr_scanner/models/qr_code.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class QRDetalleScreen extends StatelessWidget {
  QRDetalleScreen({
    Key? key,
    required this.args,
  }) : super(key: key);
  final QrCodeModel args;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Result of the QR Code',
            style: GoogleFonts.raleway(),
          ),
          leading: IconButton(
            icon: const Icon(PhosphorIcons.arrowLeft),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 10,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          args.type == 'Website'?  
                          const Icon(
                            PhosphorIcons.globe,
                            size: 25,
                            color: Colors.blue,
                          ) : args.type == 'Product' ? const Icon(
                            PhosphorIcons.globe,
                            size: 25,
                            color: Colors.blue,
                          ) : const Icon(
                                      PhosphorIcons.question,
                                      size: 25,
                                      color: Colors.blue,
                                    ),
                          Text(
                            args.type,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.raleway(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        args.data,
                        style: GoogleFonts.raleway(fontSize: 15),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  elevation: 0,
                  child: const Icon(PhosphorIcons.share),
                  onPressed: () => _onShareData(context),
                ),
                FloatingActionButton(
                  onPressed: () {
                    final data = ClipboardData(text: args.data);
                    Clipboard.setData(data);
                  },
                  elevation: 0,
                  child: const Icon(PhosphorIcons.clipboard),
                ),
                if (args.type == 'Website')
                  FloatingActionButton(
                    onPressed: () {
                      launch(args.data);
                    },
                    elevation: 0,
                    child: const Icon(PhosphorIcons.arrowSquareOut),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }

  _onShareData(BuildContext context) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    {
      await Share.share(
        args.data,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
      );
    }
  }
}
