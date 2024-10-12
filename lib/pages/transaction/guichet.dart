import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../constantes/constantes.dart';
import '../../controllers/auth.dart';
import '../../controllers/transaction.dart';

class Guichet extends StatefulWidget {
  final String url;
  final String transactionId;


  const Guichet({super.key, required this.url, required this.transactionId});

  @override
  State<Guichet> createState() => _GuichetState();
}

class _GuichetState extends State<Guichet> {
  final TransactionController transactionController = Get.put(TransactionController());
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  late WebViewController controller;



  Future<void> onClearCookies(BuildContext context) async {
    await WebViewCookieManager().clearCookies();
  }

  Future<void> onClearCache(BuildContext context) async {
    await WebViewController().clearCache();
    await WebViewController().clearLocalStorage();
  }

  

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url)
    );
    onClearCookies(context);
    onClearCache(context);
    authenticateController.checkAccessToken();
    transactionController.checkPayment(widget.transactionId);
  }

  @override
  Widget build(BuildContext context) {
    inspect(widget.transactionId);
    return Scaffold(
     appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Guichet paiement",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            // Get.to(() => const CheckUserPage());
            Get.back();
            //  Get.to(() => const RootApp());
          },
        ),
        
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}