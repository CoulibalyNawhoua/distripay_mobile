import 'package:distripay_mobile/fonctions/fonctions.dart';
import 'package:distripay_mobile/pages/widget/appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth.dart';

class RecuEncaissementPage extends StatefulWidget {
  const RecuEncaissementPage({super.key});

  @override
  State<RecuEncaissementPage> createState() => _RecuEncaissementPage();
}

class _RecuEncaissementPage extends State<RecuEncaissementPage> {
   final AuthenticateController authenticateController = Get.put(AuthenticateController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authenticateController.checkAccessToken();
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAppBar(title: "title"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  width: width(context) * 0.4,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Reçu d'Encaissement",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "24 Mai 2024 à 10h00",
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
           
            Container(
              margin: EdgeInsets.only(top: 50.0),
              padding: EdgeInsets.all(10),
              height: height(context)*0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Montant retiré:",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "100 000F",
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Status:",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "Effectué",
                        style: TextStyle(color: Colors.green),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date & Heure:",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "24 Mai 2024 à 10h00",
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Référence:",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "DISTRIPAY01234AZERTY",
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Opérateur:",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "Orange",
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Numero débité:",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "+225 0102030405",
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
