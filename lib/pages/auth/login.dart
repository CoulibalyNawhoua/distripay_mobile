
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../constantes/constantes.dart';
import '../../controllers/auth.dart';
import '../../fonctions/fonctions.dart';
import '../widget/base.dart';
import '../widget/button.dart';
import '../widget/password_input.dart';
import '../widget/text_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscurityText = true;

 @override
  void initState() {
  super.initState();
  // authenticateController.TokenExpired();
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    String?  token = GetStorage().read("access_token");
    inspect(token);
    if (token != null ) {
      Get.offAll(() => const RootApp());
    }
  });
}


  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      String phone = phoneController.text;
      String password = passwordController.text;
      // print(phone);
      // print(password);
      await authenticateController.login(phone: phone, password: password);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _header(context),
                    const SizedBox(height: 30),
                    _page(context)
                  ],
                ),
              ),
            ),
            // child: _page()
          )
        ),

      ),
    );
  }
  Widget _page(contex) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextInput(
            inputType: TextInputType.phone, 
            hint: "Entrez votre numero de téléphone", 
            icon: Icons.phone, 
            controller: phoneController, 
            validator: validatePhone,
          ),
          const SizedBox(height: 20),
          PasswordInput(
            inputType: TextInputType.text, 
            hint: "Entrez votre mot de passe", 
            icon: Icons.lock, 
            controller: passwordController, 
            validator: validatePassword
          ),
          const SizedBox(height: 50),
          Obx(() {
            return CButton(
              title: "CONNEXION",
              isLoading: authenticateController.isLoading.value,
              onPressed: () async {
                submit();
              },
            );
          }),
        ],
      )
    );
  }

  _header(context) {
    return Column(
      children: [
        Image.asset("assets/images/logo.png"),
        Text("Connectez-vous à votre compte"),
      ],
    );
  }
  // Widget _logo() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       border: Border.all(color: Colors.white, width: 2),
  //       shape: BoxShape.circle),
  //     child: const Icon(Icons.person, color: Colors.white, size: 120),
  //   );
  // }
}
