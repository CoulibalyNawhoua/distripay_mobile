import 'package:distripay_mobile/constantes/constantes.dart';
import 'package:distripay_mobile/fonctions/fonctions.dart';
import 'package:distripay_mobile/pages/transaction/detail.dart';
import 'package:distripay_mobile/pages/widget/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../controllers/auth.dart';
import '../../controllers/transaction.dart';
import '../../model/transaction.dart';
import '../user/checkUser.dart';
import '../widget/historyItem.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final TransactionController transactionController = Get.put(TransactionController());
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  final TextEditingController searchController = TextEditingController();
  bool isObscured = true;
  int selectedMonthIndex = 0;

  void toggleVisibility() {
    setState(() {
      isObscured = !isObscured;
    });
  }

  final List<String> months = [
    'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
  ];

  void onMonthSelected(int index) {
    setState(() {
      selectedMonthIndex = index;
    });
    // Ici, vous pouvez appeler une fonction pour mettre à jour les transactions en fonction du mois sélectionné
    transactionController.filterTransactionsByMonth(index + 1);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authenticateController.checkAccessToken();
      transactionController.fetchTransaction().then((_) {
      transactionController.filteredTransactions.assignAll(transactionController.transactions);
      });
      searchController.addListener(() {
      transactionController.filterTransactions(searchController.text);
      });
      // transactionController.fetchTransaction();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CAppBar(title: "Liste des Encaissements"),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              _monthRow(),
              SizedBox(height: 10.0,),
              
              Column(
                children: [
                  _container(context),
                  _search(context),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    height: height(context)*0.39,
                    color: Colors.white,
                    child: Obx(() {
                      if (transactionController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (transactionController.transactions.isEmpty) {
                        return const Center(child: Text('Aucun encaissement effectué',style: TextStyle(fontSize: 12,color: Colors.red),));
                      } else{
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: transactionController.transactions.length,
                          itemBuilder: (BuildContext context, int index) {
                          Transaction transaction = transactionController.transactions[index];
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
                  ),
              
                ],
              ),
            ],
          ),
          
        ),
      ),
    );
  }

  Widget _monthRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: months.asMap().entries.map((entry) {
          int index = entry.key;
          String month = entry.value;
          return GestureDetector(
            onTap: () => onMonthSelected(index),
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: selectedMonthIndex == index ? AppColors.primaryColor : Colors.blue.shade100,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                month,
                style: TextStyle(color: selectedMonthIndex == index ? Colors.white : AppColors.primaryColor,)
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _search(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            const Icon(Icons.search),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                controller: searchController,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  hintText: 'Recherche',
                  border: InputBorder.none,
                ),
                onChanged: (value) {},
              ),
            ),
          ],
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
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     spreadRadius: 2,
        //     blurRadius: 5,
        //     offset: Offset(0, 3),
        //   ),
        // ],
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
              "Total des Encaissements",
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
}
