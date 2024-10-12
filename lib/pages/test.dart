// import 'package:flutter/material.dart';

// import '../constantes/constantes.dart';
// import '../fonctions/fonctions.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bgColor,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     CircleAvatar(
//                       backgroundColor: AppColors.primaryColor,
//                       child: Text(
//                         getInitials('John Doe'),
//                         style: const TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     Stack(
//                       children: [
//                         IconButton(
//                           onPressed: () {},
//                           icon: const Icon(
//                             Icons.notifications,
//                             color: Colors.black,
//                           )
//                         ),
//                         const Positioned(
//                           top: 12.0,
//                           right: 12.0,
//                           child: Stack(
//                             children: [
//                               Icon(
//                                 Icons.brightness_1,
//                                 color: Colors.red,
//                                 size: 12.0,
//                               )
//                             ],
//                           )
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//                 const SizedBox(height: 20,),
//                 Stack(
//                   children: [
//                     Container(
//                       height: 250,
//                       width: width(context),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
                      
//                     )
//                   ],
//                 ),
//               ],
//             ),
//         )),
//       ),
//     );
//   }
// }
