import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../constantes/constantes.dart';
import '../../controllers/auth.dart';
import '../../controllers/transaction.dart';
import '../../fonctions/fonctions.dart';
import '../../model/user.dart';

class EncaissementForm extends StatefulWidget {
  final String name;
  final String phone;

  const EncaissementForm({required this.name, required this.phone, Key? key}) : super(key: key);

  @override
  State<EncaissementForm> createState() => _EncaissementFormState();
}

class _EncaissementFormState extends State<EncaissementForm> {
  final TransactionController transactionController = Get.put(TransactionController());
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController montantController;
  final formKey = GlobalKey<FormState>();
  bool isButtonEnabled = false;
  User? user;

  @override
  void initState() {
    super.initState();
    authenticateController.checkAccessToken();
    nameController = TextEditingController(text: widget.name);
    phoneController = TextEditingController(text: widget.phone);
    montantController = TextEditingController();
    getUserData();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void verifierMontant(String valeur) {
    if (valeur.isNotEmpty) {
      double montant = double.tryParse(valeur) ?? 0;
      setState(() {
        isButtonEnabled = montant > 49;
      });
    } else {
      setState(() {
        isButtonEnabled = false;
      });
    }
  }
Future<void> getUserData() async {
    var userData = GetStorage().read<Map<String, dynamic>>("user");
    if (userData != null) {
      setState(() {
        user = User.fromJson(userData);
      });
    }
  }


  
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: Padding(
       padding: EdgeInsets.symmetric(vertical: height(context)*0.05, horizontal: width(context)*0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: (){
                Get.back();
              }, 
              icon: const Icon(Icons.close, color: Colors.black),
            ),
            SizedBox(height: 20.0),
            Text(
              "${widget.name}",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            Text(
              "${widget.phone}",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: montantController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Montant à débiter'),
                    onChanged: verifierMontant,
                  ),
                ),
                const SizedBox(width: 10),
                const Text("fcfa"),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: isButtonEnabled ? () async {
                String transaction_id = generateTransactionIdtring();
                var data = {
                  "apiKey": "262425053964adkcz02q1x.7323710",
                  "site_id": "6076583",
                  "transaction_id": transaction_id,
                  "amount": montantController.text,
                  "currency": "XOF",
                  "description": "Encaissement point de vente",
                  "customer_id": "17",
                  "customer_name": widget.name,
                  "customer_surname": "",
                  "customer_email": "",
                  "customer_phone_number": widget.phone,
                  "customer_address": "",
                  "customer_country": "ci",
                  "lang": "fr",
                  "plateforme_name": "DISTRIPAY_MOBILE",
                  "user_id": user!.id.toString(),
                };
                await transactionController.payment(data);
              } : null,
              child: Obx(() {
                return transactionController.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      "Envoyer",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                );
              }),
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(Size(345, 55)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(isButtonEnabled ? AppColors.primaryColor : Colors.blue.shade200),
              ),
             
            ),

          ],
        ),
      ),
      
    );
  }
}
