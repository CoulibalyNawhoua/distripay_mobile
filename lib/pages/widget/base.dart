import 'package:distripay_mobile/pages/transaction/liste.dart';
import 'package:distripay_mobile/pages/home.dart';
import 'package:flutter/material.dart';

import '../../constantes/constantes.dart';
import '../../fonctions/fonctions.dart';
import '../user/liste.dart';

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: getFooter(),
      body: getBody(),
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: const [
        HomePage(),
        HistoryPage(),
        UserListePage(),
      ],
    );
  }

  Widget getFooter() {
    List<Map<String, dynamic>> items = [
      {
        "icon": Icons.home,
        "text": "Accueil"
      },
      {
        "icon": Icons.compare_arrows,
        "text": "Encaissement"
      },
       {
        "icon": Icons.account_circle,
        "text": "Contacts"
      },
    ];
    // List items = [
    //   Icons.home,
    //   Icons.dashboard,
    //   Icons.shopping_cart,
    //   Icons.settings
    // ];
    return Container(
      width: width(context),
      height: 80,
      decoration: BoxDecoration(
        // color: AppColors.primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          items.length,
          (index) {
            return InkWell(
              onTap: () {
                setState(() {
                  pageIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    children: [
                      Icon(
                        items[index]["icon"],
                        size: 35,
                        color: pageIndex == index
                          ? AppColors.primaryColor //  couleur(quand le bouton est activé)
                          : AppColors.secondaryColor,
                      ),
                      Text(
                        items[index]["text"],
                        style: TextStyle(
                          fontSize: 14,
                          color: pageIndex == index
                            ? AppColors.primaryColor  // couleur(quand le bouton est activé)
                            : AppColors.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
