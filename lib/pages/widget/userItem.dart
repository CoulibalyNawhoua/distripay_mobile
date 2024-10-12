import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  final String name;
  final String phone;
  final VoidCallback? onPressed; 

  const UserItem({
    super.key,
    required this.name,
    required this.phone,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage("assets/images/avatar.png"),
          ),
          Expanded(
            child: ListTile(
              title: Text(name),
              subtitle: Text(
               phone,
                style: TextStyle(fontSize: 12.0),
              ),
            )
          )
        ],
      ),
    );
  }
}