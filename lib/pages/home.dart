import 'dart:developer';

import 'package:distripay_mobile/pages/user/checkUser.dart';
import 'package:distripay_mobile/pages/transaction/detail.dart';
import 'package:distripay_mobile/pages/widget/button.dart';
import 'package:distripay_mobile/pages/widget/historyItem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../constantes/constantes.dart';
import '../controllers/auth.dart';
import '../controllers/transaction.dart';
import '../fonctions/fonctions.dart';
import '../model/transaction.dart';
import '../model/user.dart';
import 'widget/appBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TransactionController transactionController = Get.put(TransactionController());
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  bool isObscured = true;
  bool isObscured1 = true;
  User? user;

  void toggleVisibility() {
    setState(() {
      isObscured = !isObscured;
    });
  }
  void toggleVisibility1() {
    setState(() {
      isObscured1 = !isObscured1;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authenticateController.checkAccessToken();
      transactionController.fetchTransactionRecente();
      getUserData();
    });
    
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
      backgroundColor: AppColors.bgColor,
      appBar: CAppBarHome(name: user != null ? user!.nom : "John Doe"),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _containerbuild(context),
              SizedBox(height: 20,),
              _container(context),
              SizedBox(height: 15.0,),
              const Text("Encaissement récents"),
              Container(
                height: height(context)*0.39,
                margin: EdgeInsets.only(top: 10),
                color: Colors.white,
                child: Obx(() {
                  if (transactionController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (transactionController.transactionsRecents.isEmpty) {
                    return const Center(child: Text('Vous n\'avez pas effectué d\'encaissement aujourd\'hui',style: TextStyle(fontSize: 12,color: Colors.red),));
                  } else{
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: transactionController.transactionsRecents.length,
                      itemBuilder: (BuildContext context, int index) {
                        Transaction transaction = transactionController.transactionsRecents[index];
                        return HistoryItem(
                          title: transaction.customerName,
                          montant: transaction.montantInitial,
                          date: transaction.dateTrans,
                          status: transaction.statusPayment,
                          onPressed: () {
                            Get.to(DetailEncaissement(transactionId: transaction.transactionId));
                          },
                        );
                      },
                    );
                  }
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _container(BuildContext context) {
    return Container(
      width: width(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title: Row(
          children: [
            Text(
              isObscured ? formatPrice(transactionController.sumTransactionByDay.value.toString()) : "Afficher",
              style: const TextStyle(
                // fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: toggleVisibility,
              child: Icon(
                isObscured
                  ? Icons.visibility
                  : Icons.visibility_off,
                color: AppColors.primaryColor,
                size: 20,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Encaissement du Jour",
              style: TextStyle(
                fontSize: 10.0,
                color: Colors.red
              ),
            ),
            SizedBox(height: 10.0,),
            _textButton(context),
          ],
        ),
      ),
    );
  }

  Widget _textButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Get.to(const CheckUserPage());
        // showModalBottomSheet(
        //   isScrollControlled: true,
        //   // shape: const RoundedRectangleBorder(
        //   //   borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        //   // ),
        //   context: context,
        //   builder: (BuildContext context) {
        //     return const CheckUserPage();
        //   },
        // );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(AppColors.primaryColor), // Couleur du bouton
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(8.0)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.add,
            color: Colors.white,
          ),
          SizedBox(width: 8.0),
          Text(
            "Faire un encaissement",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _containerbuild(BuildContext context) {
    return Container(
      width: width(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Row(
              children: [
                Text(
                  isObscured1 ? formatPrice(transactionController.sumTransactionMonth.value.toString()) : "Afficher",
                  style: const TextStyle(
                    // fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: toggleVisibility1,
                  child: Icon(
                    isObscured1
                      ? Icons.visibility
                      : Icons.visibility_off,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                  
                ),
              ],
            ),
            subtitle: Text(
              "Total Encaissement du Mois",
              style: TextStyle(
                fontSize: 10.0,
                color: Colors.red
              ),
            )
          )
        ],
      ),
    );
  }
}
