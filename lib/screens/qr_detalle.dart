import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:qr_scanner/models/qr_code.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class QRDetalleScreen extends StatefulWidget {
  const QRDetalleScreen({
    Key? key,
    required this.args,
  }) : super(key: key);
  final QrCodeModel args;
  @override
  State<QRDetalleScreen> createState() => _QRDetalleScreenState();
}

class _QRDetalleScreenState extends State<QRDetalleScreen> {
  late InterstitialAd interstitialAd;
  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-5614231101856807/7204816416',
    size: AdSize.fullBanner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );
  late final adWidget = AdWidget(
    ad: myBanner,
  );
  @override
  void initState() {
    super.initState();
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-5614231101856807/4608247709',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
    myBanner.load();
  }

  @override
  void dispose() {
    interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('%ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
      onAdImpression: (InterstitialAd ad) => print('$ad impression occurred.'),
    );
    super.dispose();
  }

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
                          widget.args.type == 'Website'
                              ? const Icon(
                                  PhosphorIcons.globe,
                                  size: 25,
                                  color: Colors.blue,
                                )
                              : widget.args.type == 'Product'
                                  ? const Icon(
                                      PhosphorIcons.globe,
                                      size: 25,
                                      color: Colors.blue,
                                    )
                                  : const Icon(
                                      PhosphorIcons.question,
                                      size: 25,
                                      color: Colors.blue,
                                    ),
                          Text(
                            widget.args.type,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.raleway(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.args.data,
                          style: GoogleFonts.raleway(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
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
                  onPressed: () async {
                    final data = ClipboardData(text: widget.args.data);
                    Clipboard.setData(data);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Copied to Clipboard!',
                        style: GoogleFonts.raleway(),
                      ),
                      duration: const Duration(seconds: 10),
                    ));
                    await interstitialAd.show();
                  },
                  elevation: 0,
                  child: const Icon(PhosphorIcons.clipboard),
                ),
                if (widget.args.type == 'Website')
                  FloatingActionButton(
                    onPressed: () {
                      launch(widget.args.data);
                    },
                    elevation: 0,
                    child: const Icon(PhosphorIcons.arrowSquareOut),
                  )
              ],
            ),
            adWidget,
          ],
        ),
      ),
    );
  }

  _onShareData(BuildContext context) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    {
      await Share.share(
        widget.args.data,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
      );
    }
  }
}
