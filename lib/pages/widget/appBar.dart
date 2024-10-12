import 'package:flutter/material.dart';

import '../../constantes/constantes.dart';
import '../../fonctions/fonctions.dart';

class CAppBarHome extends StatelessWidget implements PreferredSizeWidget {

  final String name;

  const CAppBarHome({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryColor,
            child: Text(
              getInitials(name),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: () {deconnectUser();},
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
            )
          ),
        ],
      ),
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}


class CAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  // final VoidCallback onPressed;

  const CAppBar({
    super.key,
    required this.title,
    // required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      // elevation: 0.0,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold,color: AppColors.secondaryColor),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      // leading: IconButton(
      //   icon: const Icon(Icons.arrow_back,color: AppColors.primaryColor,),
      //   onPressed: onPressed,
      //   // onPressed: () {
      //   //   Get.back();
      //   // },
      // ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}