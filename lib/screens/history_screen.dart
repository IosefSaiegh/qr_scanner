import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:qr_scanner/models/qr_result_model.dart';
import 'package:qr_scanner/qr_result_database.dart';
import 'package:share/share.dart';

class QrHistoryScreen extends StatefulWidget {
  const QrHistoryScreen({Key? key}) : super(key: key);

  @override
  State<QrHistoryScreen> createState() => _QrHistoryScreenState();
}

class _QrHistoryScreenState extends State<QrHistoryScreen> {
  late List<QrResult?>? results;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'QR Scanner',
            style: GoogleFonts.raleway(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: QrResultDatabase.instance.readAllQrResults(),
            builder: (BuildContext context,
                AsyncSnapshot<List<QrResult?>> snapshot) {
              if (snapshot.hasData) {
                results = snapshot.data;
                return ListView.builder(
                  itemCount: results?.length,
                  itemBuilder: (BuildContext context, int index) {
                    QrResult result = results![index]!;
                    int minute = result.createTime.minute;
                    String time =
                        '${result.createTime.hour}:${minute < 10 ? '0$minute' : minute}';
                    String date =
                        '${result.createTime.day}.${result.createTime.month}.${result.createTime.year}';
                    return ListTile(
                      title: Text(result.data),
                      subtitle: Text(
                        '$date $time',
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          PhosphorIcons.share,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          Share.share(result.data);
                        },
                      ),
                      leading: result.type == 'Website'
                          ? const Icon(
                              PhosphorIcons.globe,
                              size: 25,
                              color: Colors.blue,
                            )
                          : result.type == 'Product'
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
                    );
                  },
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Center(
                  child: Text(
                    'No data',
                    style: GoogleFonts.raleway(fontSize: 20),
                  ),
                );
              }
            }),
      ),
    );
  }
}
