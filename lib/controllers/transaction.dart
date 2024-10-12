import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:distripay_mobile/pages/transaction/liste.dart';
import 'package:distripay_mobile/pages/widget/base.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constantes/api.dart';
import '../model/transaction.dart';
import '../pages/transaction/guichet.dart';

class TransactionController extends GetxController {
  final isLoading = false.obs;
  final token = GetStorage().read("access_token");
  final montant = 0.obs;
  var searchQuery = ''.obs; // Variable pour le terme de recherche
  RxList<Transaction> transactions = <Transaction>[].obs;
  RxList<Transaction> transactionsRecents = <Transaction>[].obs;
  RxList<Transaction> filteredTransactions = <Transaction>[].obs; // Liste filtrée
  Rx<Transaction?> transactionDetails = Rx<Transaction?>(null);
  RxInt sumTransactionMonth = 0.obs;
  RxInt sumTransactionByDay = 0.obs;
  

  Future<void> fetchTransaction() async {
    try {
      isLoading.value = true;
      transactions.clear();
      var response = await http.get(Uri.parse(Api.listTransaction), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        isLoading.value = false;
        var responseBody = jsonDecode(response.body);
        List<dynamic> data = responseBody['data'];
        List<Transaction> transactionList = data.map((json) => Transaction.fromJson(json)).toList();
        transactions.assignAll(transactionList);
      } else {
        isLoading.value = false;

        if (kDebugMode) {
          print("Erreur lors de la récupération des transactions");
        }

        if (kDebugMode) {
          print(json.decode(response.body));
        }
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTransactionRecente() async {
    try {
      isLoading.value = true;
      transactionsRecents.clear();
      var response = await http.get(Uri.parse(Api.transactionRecente), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        isLoading.value = false;
        var responseBody = jsonDecode(response.body);

        List<dynamic> data = responseBody['data'];
        List<Transaction> recentTransactionList = data.map((json) => Transaction.fromJson(json)).toList();
        transactionsRecents.assignAll(recentTransactionList);
      } else {
        isLoading.value = false;

        if (kDebugMode) {
          print("Erreur lors de la récupération des transactions");
        }

        if (kDebugMode) {
          print(json.decode(response.body));
        }
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> payment(data) async {
    try {
      isLoading.value = true;
      var response = await http.post(
        Uri.parse(Api.payment),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: data,
      );
      // inspect(response);
      if (response.statusCode == 200) {
        isLoading.value = false;
        var responseBody = jsonDecode(response.body)['data'];
        Get.to(Guichet(
          url: responseBody["payment_url"],
          transactionId: data["transaction_id"],
        ));
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Echec : ',
          "echec du paiement",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> checkPayment(String transactionId) async {
    Timer timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      var data = {
        "apiKey": "262425053964adkcz02q1x.7323710",
        "site_id": "6076583",
        "transaction_id": transactionId,
      };

      var response = await http.post(
        Uri.parse("https://pay.distriforce.shop/api/check/verify"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        if (responseBody["code"] == 00 || responseBody["code"] == 600) {
          if (responseBody["code"] == 00) {
            Get.snackbar(
              'Succès',
              'Paiement effectué avec succès.',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          } else if (responseBody["code"] == 600) {
            Get.snackbar(
              'Echec',
              'Paiement échoué.',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
          Future.delayed(const Duration(seconds: 3), () {
            Get.to(() => RootApp());
          });

          timer.cancel();
        } else {
          inspect(responseBody);
          print("annule");
        }
      } else {
        timer.cancel();
      }
    });

    // Future.delayed(const Duration(seconds: 300), () {
    //   timer.cancel();
    // });
  }

  Future<void> FetchTotalTransaction() async {
    try {
      isLoading.value = true;
      var response = await http.post(
        Uri.parse(Api.transactionTotal),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        isLoading.value = false;

        var responseBody = jsonDecode(response.body);
        sumTransactionMonth.value = responseBody['sum_transaction_month'];
        sumTransactionByDay.value = responseBody['sum_transaction_by_day'];
      } else {
        isLoading.value = false;
        if (kDebugMode) {
          print("Erreur lors de la récupération des montants des transactions");
        }
        if (kDebugMode) {
          print(json.decode(response.body));
        }
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

  // void filterTransactions(String query) {
  //   searchQuery.value = query;
  //   if (query.isEmpty) {
  //     filteredTransactions.assignAll(transactions);
  //   } else {
  //     filteredTransactions.assignAll(
  //       transactions.where((transaction) =>
  //         transaction.customerName.toLowerCase().contains(query.toLowerCase())
  //       ).toList()
  //     );
  //   }
  // }

  void filterTransactions(String query) {
    if (query.isEmpty) {
      filteredTransactions.assignAll(transactions);
    } else {
      var filtered = filteredTransactions.where((transaction) {
        return transaction.customerName
          .toLowerCase()
          .contains(query.toLowerCase()) ||
          transaction.montantInitial
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase());
      }).toList();
      filteredTransactions.assignAll(filtered);
    }
  }

  Future<void> fetchTransactionDetails(String transactionId) async {
    try {
      isLoading.value = true;
      var response = await http.get(
        Uri.parse(Api.transactionDetails(transactionId)),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var transactionData = responseBody['data'];
        transactionDetails.value = Transaction.fromJson(transactionData);
      } else {
        Get.snackbar(
          'Erreur',
          'Erreur lors de la récupération des détails de la transaction',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

  void filterTransactionsByMonth(int month) {
    filteredTransactions.assignAll(transactions.where((transaction) {
      // Assuming 'dateTrans' is a DateTime property in your Transaction model
      return transaction.dateTrans.month == month;
    }).toList());
  }
}
