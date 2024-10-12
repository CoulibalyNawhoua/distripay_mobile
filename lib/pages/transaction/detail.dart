import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../constantes/constantes.dart';
import '../../controllers/auth.dart';
import '../../controllers/transaction.dart';
import '../../fonctions/fonctions.dart';
import '../../model/transaction.dart';

class DetailEncaissement extends StatefulWidget {
  final String transactionId;

  const DetailEncaissement({super.key, required this.transactionId});

  @override
  State<DetailEncaissement> createState() => _DetailEncaissementState();
}

class _DetailEncaissementState extends State<DetailEncaissement> {
  final TransactionController transactionController = Get.put(TransactionController());
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
      
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      transactionController.fetchTransactionDetails(widget.transactionId);
      authenticateController.checkAccessToken();
    });
  }

Future<void> genererPdfEtPartager(Transaction transaction) async {
  final pdf = pw.Document();
  final image = pw.MemoryImage(
    (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),
  );

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(
                image,
                width: 100,
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    "Reçu d'Encaissement",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    DateFormat('dd MMMM yyyy HH\'h\'mm', 'fr_FR').format(DateTime.now()),
                    style: pw.TextStyle(fontSize: 12.0),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 50),
          pw.Container(
            padding: pw.EdgeInsets.all(10),
            child: pw.Column(
              children: [
                buildDetailRowPdf("Montant encaissé:", "${transaction.montantInitial} FCFA"),
                buildDetailRowStatusPdf("Status:", transaction.statusPayment),
                buildDetailRowPdf("Date & Heure:", DateFormat('dd MMMM yyyy HH\'h\'mm', 'fr_FR').format(transaction.dateTrans)),
                buildDetailRowPdf("Référence:", transaction.transactionId),
                buildDetailRowPdf("Opérateur:", transaction.operateur),
                buildDetailRowPdf("Numero débité:", transaction.telPayment),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  final output = await getTemporaryDirectory();
  final file = File("${output.path}/reçu_encaissement.pdf");
  await file.writeAsBytes(await pdf.save());

  final xfile = XFile(file.path);
  await Share.shareXFiles([xfile], text: 'Reçu d\'encaissement');
}


  pw.Widget buildDetailRowPdf(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: pw.TextStyle(color: PdfColors.grey)),
        pw.SizedBox(height: 20),
        pw.Text(value,),
      ],
    );
  }

    pw.Widget buildDetailRowStatusPdf(String label, String value) {
      String statusText;
      PdfColor statusColor;
      if (value == "ACCEPTED") {
        statusText = "accepter";
        statusColor = PdfColors.green;
      } else if (value == "REFUSED") {
        statusText = "refuser";
        statusColor = PdfColors.red;
      } else if (value == "PENDING") {
        statusText = "En attente";
        statusColor = PdfColors.yellow;
      } else {
        statusText = "inconnu";
        statusColor = PdfColors.black;
      }
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: pw.TextStyle(color: PdfColors.grey)),
        pw.SizedBox(height: 20),
        pw.Text(statusText,style: pw.TextStyle(color: statusColor)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Détails Encaissement",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: height(context) * 0.05,
              horizontal: width(context) * 0.05),
          child: Obx(() {
            if (transactionController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (transactionController.transactionDetails.value == null) {
              return Center(child: Text("Aucun détail de transaction disponible"));
            }

            final transaction = transactionController.transactionDetails.value!;

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(
                          formatPrice(transaction.montantInitial.toString()),
                          style: TextStyle( fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(transaction.customerName),
                            // if (transaction.telPayment != null)
                              Text(transaction.telPayment),
                          ],
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundImage:  AssetImage(getLogoImageForOperator(transaction.operateur),),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  width: width(context),
                  height: height(context) * 0.3,
                  decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildDetailRow("Montant retiré:","${transaction.montantInitial} FCFA"),
                      buildDetailRowStatus("Status:", transaction.statusPayment),
                      buildDetailRow("Date & Heure:",DateFormat('dd MMMM yyyy HH\'h\'mm', 'fr_FR').format(transaction.dateTrans)),
                      buildDetailRow("Référence:", transaction.transactionId),
                      buildDetailRow("Opérateur:", transaction.operateur),
                      buildDetailRow("Numero débité:", transaction.telPayment),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: height(context) * 0.1),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (transactionController.transactionDetails.value != null) {
                        genererPdfEtPartager(transactionController.transactionDetails.value!);
                      } else {
                        // Gérer le cas où les détails de la transaction ne sont pas disponibles
                        print("Détails de transaction non disponibles");
                      }
                    },
                    child: Text(
                      "Partager",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(345, 55)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

Widget buildDetailRow(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(color: Colors.grey),
      ),
      Text(
        value,
        // style: isSuccess ? TextStyle(color: Colors.green) : null,
      ),
    ],
  );
}

Widget buildDetailRowStatus(
  String label,
  String value,
) {
  String statusText;
  Color statusColor;
  if (value == "ACCEPTED") {
    statusText = "accepté";
    statusColor = Colors.green;
  } else if (value == "REFUSED") {
    statusText = "refusé";
    statusColor = Colors.red;
  } else if (value == "PENDING") {
    statusText = "En attente";
    statusColor = Colors.yellow;
  } else {
    statusText = "inconnu";
    statusColor = Colors.black;
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(color: Colors.grey),
      ),
      Text(
        statusText,
        style: TextStyle(color: statusColor),
        // style: isSuccess ? TextStyle(color: Colors.green) : null,
      ),
    ],
  );
}

String getLogoImageForOperator(String operateur) {
  switch (operateur) {
    case 'OM':
      return "assets/images/orange-money-logo.webp";
    case 'MOMO':
      return "assets/images/momo.jpg";
    case 'FLOOZ':
      return "assets/images/Moov_Africa_logo.png";
    default:
      return "assets/images/wave.png";
  }
}
