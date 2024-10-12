
import 'package:distripay_mobile/constantes/constantes.dart';
import 'package:distripay_mobile/controllers/user.dart';
import 'package:distripay_mobile/pages/transaction/form.dart';
import 'package:distripay_mobile/pages/widget/userItem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth.dart';
import '../../fonctions/fonctions.dart';
import '../../model/user.dart';


class CheckUserPage extends StatefulWidget {
  const CheckUserPage({super.key});

  @override
  State<CheckUserPage> createState() => _CheckUserPageState();
}

class _CheckUserPageState extends State<CheckUserPage> {
  
  final UserController userController  = Get.put(UserController());
  final AuthenticateController authenticateController = Get.put(AuthenticateController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      authenticateController.checkAccessToken();
      userController.fetchUserContact().then((_) {
      userController.filteredListUserContact.assignAll(userController.listUserContact);
      });
     searchController.addListener(() {
      userController.filterUsers(searchController.text);
      });
     
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void showAddNumberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Ajouter un nouveau numéro",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Entrez le nom",
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Entrez le numéro",
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      child: Text("Annuler",style: TextStyle(color: Colors.black),),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text("Ajouter",style: TextStyle(color: AppColors.primaryColor),),
                      onPressed: () async {
                        final name = nameController.text;
                        final phone = phoneController.text;
                        await userController.createUser(name: name, phone: phone);
                        nameController.clear();
                        phoneController.clear();
                        Navigator.of(context).pop();
                        userController.fetchUserContact();
                        Get.to(EncaissementForm(name: name, phone: phone),);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: height(context)*0.05, horizontal: width(context)*0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: (){
                Get.back();
                // Get.to(RootApp());
              }, 
              icon: const Icon(Icons.close, color: Colors.black),
            ),
            SizedBox(height: 20.0,),
            Text(
              "Numéro de compte à débiter",
              style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              ),
            ),
            Container(
              child: Row(
                children: [
                  const Icon(Icons.search),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        hintText: 'Recherchez un contact',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            GestureDetector(
              onTap: () {
                showAddNumberDialog(context);
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primaryColor,
                    radius: 15.0,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                  SizedBox(width: 10.0,),
                  Text(
                    "Ajouter un nouveau contact"
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Text(
              "Liste des utilisateurs",
              style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              ),
            ),
            SizedBox(height: 10.0,),
            Expanded(
              child: Obx(() {
                if (userController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (userController.filteredListUserContact.isEmpty) {
                  return const Center(child: Text('Aucun utilisateur ajouté',style: TextStyle(fontSize: 12,color: Colors.red),));
                } else{
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: userController.filteredListUserContact.length,
                    itemBuilder: (BuildContext context, int index) {
                    UserContact userContact = userController.filteredListUserContact[index];
                    return UserItem(
                      name: userContact.name,
                      phone: userContact.tel,
                      onPressed: () {
                         Get.to(EncaissementForm(name: userContact.name, phone: userContact.tel))
                              ?.then((_) {
                            // Actualiser la liste des utilisateurs quand on revient sur la page
                            userController.fetchUserContact();
                          });
                      },
                    );
                    },
                  );
                }
              })
            ),
          ],
        ),
      ),
    );
  }
}