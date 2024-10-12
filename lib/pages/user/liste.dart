import 'package:distripay_mobile/constantes/constantes.dart';
import 'package:distripay_mobile/pages/widget/appBar.dart';
import 'package:distripay_mobile/pages/widget/userItem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth.dart';
import '../../controllers/user.dart';
import '../../fonctions/fonctions.dart';
import '../../model/user.dart';

class UserListePage extends StatefulWidget {
  const UserListePage({super.key});

  @override
  State<UserListePage> createState() => _UserListePageState();
}

class _UserListePageState extends State<UserListePage> {
  final UserController userController  = Get.put(UserController());
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CAppBar(title: "Liste des contacts"),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: height(context)*0.01, horizontal: width(context)*0.05),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: height(context)*0.03),
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
            ),
            SizedBox(height: 20.0,),
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