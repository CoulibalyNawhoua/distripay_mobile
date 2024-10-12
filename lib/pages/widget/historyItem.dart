import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constantes/constantes.dart';
import '../../fonctions/fonctions.dart';

class HistoryItem extends StatelessWidget {
  final String title;
  final int montant;
  final DateTime date;
  final String status;
  final VoidCallback onPressed; 

  const HistoryItem({
    super.key,
    required this.title,
    required this.montant,
    required this.date,
    required this.status,
    required this.onPressed,
  });

  // String formatPrice(String montant) {
  //   final currencyFormatter = NumberFormat("#,##0 XOF", "fr_FR");
  //   return currencyFormatter.format(double.parse(montant));
  // }

  @override
  Widget build(BuildContext context) {
    String statusText;
    Color statusColor;
    // Définir le texte et la couleur en fonction du statut
    if (status == "ACCEPTED") {
      statusText = "accepté";
      statusColor = Colors.green;
    } else if (status == "REFUSED") {
      statusText = "refusé";
      statusColor = Colors.red;
    } else if (status == "PENDING") {
      statusText = "En attente";
      statusColor = Colors.yellow;
    } else {
      statusText = "inconnu";
      statusColor = Colors.black;
    }
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey[400],
                        child: const Icon(
                          Icons.repeat,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 10.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,style: TextStyle(fontSize: 16.0),),
                          Text(
                            DateFormat('dd MMMM yyyy: HH\'h\'mm','fr_FR').format(date),
                            style: TextStyle(fontSize: 10.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatPrice(montant.toString()),
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0
                        ),
                      ),
                      Text(
                        statusText,
                        style: TextStyle(fontSize: 10.0, color: statusColor),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
