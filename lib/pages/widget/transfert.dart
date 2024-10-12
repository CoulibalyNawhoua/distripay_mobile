import 'package:distripay_mobile/constantes/constantes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransfertItems extends StatelessWidget {

  final String title;
  final int montant;
  // final DateTime date;
  final VoidCallback onPressed; 

  const TransfertItems({
    super.key,
    required this.title,
    required this.montant,
    // required this.date,
    required this.onPressed,
  });

  String formatPrice(String montant) {
    final currencyFormatter = NumberFormat("#,##0 FCFA", "fr_FR");
    return currencyFormatter.format(double.parse(montant));
  }
  

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      splashColor: Color.fromARGB(255, 199, 205, 247),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[400],
                  child: const Icon(
                    Icons.repeat,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(title),
                    subtitle: const Text("22 mai 2024:11h30",style: TextStyle(fontSize: 10.0),),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      formatPrice(montant.toString()),
                      style: const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5.0,),
                    const Icon(Icons.keyboard_arrow_right)
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}