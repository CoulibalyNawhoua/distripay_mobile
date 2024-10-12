import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constantes/api.dart';
import '../model/user.dart';

class UserController extends GetxController {
  final isLoading = false.obs;
  final token = GetStorage().read("access_token");
  RxList<UserContact> listUserContact = <UserContact>[].obs;
  RxList<UserContact> filteredListUserContact = <UserContact>[].obs;

  Future<void> createUser({
    required String name,
    required String phone,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        'name': name,
        'tel': phone,
      };
      var response = await http.post(
        Uri.parse(Api.createUser),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: data,
      );
      if (response.statusCode == 200) {
        isLoading.value = false;
        Get.snackbar(
          'Succès',
          'Enregistré avec succès',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          forwardAnimationCurve: Curves.elasticInOut,
          reverseAnimationCurve: Curves.easeOut,
        );
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Erreur',
          'L\'enregistrement a échoué',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          forwardAnimationCurve: Curves.elasticInOut,
          reverseAnimationCurve: Curves.easeOut,
        );

      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> fetchUserContact() async {
    try {
      isLoading.value = true;
      listUserContact.clear();
      var response = await http.get(Uri.parse(Api.listUser), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        isLoading.value = false;
        var responseBody = jsonDecode(response.body);

        List<dynamic> data = responseBody['data'];
        List<UserContact> UserContactList = data.map((json) => UserContact.fromJson(json)).toList();
        listUserContact.assignAll(UserContactList);
        

      } else {
        isLoading.value = false;

        if (kDebugMode) {
          print("Erreur lors de la récupération des utilisateurs");
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

  void filterUsers(String query) {
    if (query.isEmpty) {
      filteredListUserContact.assignAll(listUserContact);
    } else {
      var filtered = listUserContact.where((user) {
        return user.name.toLowerCase().contains(query.toLowerCase()) ||
               user.tel.toLowerCase().contains(query.toLowerCase());
      }).toList();
      filteredListUserContact.assignAll(filtered);
    }
  }
}