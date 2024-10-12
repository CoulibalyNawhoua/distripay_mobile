import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../pages/auth/login.dart';

width(context) => MediaQuery.of(context).size.width;
height(context) => MediaQuery.of(context).size.height;

route(context, widget, {bool close = false}) => close
    ? Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => widget), (route) => false)
    : Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => widget),
      );

String getInitials(String name) {
  // Divise le nom en parties et prend les deux premières lettres
  List<String> nameParts = name.split(' ');
  if (nameParts.length >= 2) {
    return nameParts[0][0] + nameParts[1][0]; // Combine les premières lettres des deux parties
  } else if (nameParts.isNotEmpty) {
    return nameParts[0].substring(0, 2); // Si une seule partie, prend les deux premières lettres
  }
  return '';
}
Route routeAnimation(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page, 
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.decelerate;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

// Généré un code
generateTransactionIdtring () {
  String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  String randomString = generateRandomString(6); // Génère une chaîne aléatoire de 6 caractères
  return '$timestamp$randomString';
}
String generateRandomString(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  Random rnd = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}

//formater le prix
formatPrice(String montant) {
  final currencyFormatter = NumberFormat("#,##0 XOF", "fr_FR");
  return currencyFormatter.format(double.parse(montant));
}

//fonction validation champ phone
String? validatePhone(String? value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez entrer votre numéro de téléphone';
  } else if (value.length != 10) {
    return 'Le numéro de téléphone doit contenir 10 chiffres';
  }
  return null;
}

//fonction validation champ password
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez saisir un mot de passe';
  }
  return null;
}

//deconnexion
void deconnectUser() {
  Get.defaultDialog(
    title: "Déconnexion",
    middleText: "Voulez-vous vraiment vous déconnecter ?",
    backgroundColor: Colors.white,
    radius: 0,
    confirm: TextButton(
      onPressed: () {
        // GetStorage().remove("access_token");
        Get.offAll(() => const LoginPage());
      },
      child: const Text(
        "Oui",
        style: TextStyle(color: Colors.red),
      ),
    ),
    cancel: TextButton(
      onPressed: () {
        Get.back();
      },
      child: const Text(
        "Annuler",
        style: TextStyle(color: Colors.black),
      ),
    ),
  );
}