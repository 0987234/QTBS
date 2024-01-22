import 'package:flutter/material.dart';
import 'package:test_project/UI/widgets/roll_button.dart';
import 'package:test_project/utils.dart';

// class User extends StatelessWidget {
//   String email;
//   String role; // "student", "manager", "driver", "guardian"
//
//   User(this.email, this.role);
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Stack(children: [
//           Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("assets/user.png"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 100, top: 330),
//             child:
//                 Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//               Container(
//                 height: 45,
//                 width: 150,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.indigo,
//                 ),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => Start(),
//                       ),
//                     );
//                   },
//                   child: const Center(
//                     child: Text(
//                       'Student',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontFamily: "Oswald",
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),
//
//               Container(
//                 height: 45,
//                 width: 150,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.indigo,
//                 ),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => Start(),
//                       ),
//                     );
//                   },
//                   child: const Center(
//                     child: Text(
//                       'Driver',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontFamily: "Oswald",
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: 10),
//
//               Container(
//                 height: 45,
//                 width: 150,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.indigo,
//                 ),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => Start(),
//                       ),
//                     );
//                   },
//                   child: const Center(
//                     child: Text(
//                       'Guardain',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontFamily: "Oswald",
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: 10),
//
//               Container(
//                 height: 45,
//                 width: 150,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.indigo,
//                 ),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => Start(),
//                       ),
//                     );
//                   },
//                   child: const Center(
//                     child: Text(
//                       'Manager',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontFamily: "Oswald",
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               // ),
//             ]),
//           ),
//         ]),
//       ),
//     );
//   }
// }

class RollButton extends StatelessWidget {
  final String email;
  final String role;

  RollButton({required this.email, required this.role});

  // final user = RollButton(email: "user@example.com", role: "student");
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/user.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 100, top: 330),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoleButton(
                    role: "Student",
                    onPressed: () {
                      navigateToRole("student", context);
                    },
                  ),
                  SizedBox(height: 10),
                  RoleButton(
                    role: "Driver",
                    onPressed: () {
                      navigateToRole("driver", context);
                    },
                  ),
                  SizedBox(height: 10),
                  RoleButton(
                    role: "Guardian",
                    onPressed: () {
                      navigateToRole("guardian", context);
                    },
                  ),
                  SizedBox(height: 10),
                  RoleButton(
                    role: "Manager",
                    onPressed: () {
                      navigateToRole("manager", context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void navigateToRole(String role) {
  //   // Use Get.toNamed to navigate to the specified route
  //   if (role == "student") {
  //     Get.toNamed('/student');
  //   } else if (role == "driver") {
  //     Get.toNamed('/driver');
  //   } else if (role == "guardian") {
  //     Get.toNamed('/guardian');
  //   } else if (role == "manager") {
  //     Get.toNamed('/manager');
  //   }
  // }

//   void navigateToRole(
//     String role,
//   ) {
//     if (role == "student") {
//       Get.toNamed('/student');
//     } else if (role == "driver") {
//       Get.toNamed('/driver');
//     } else if (role == "guardian") {
//       Get.toNamed('/guardian');
//     } else if (role == "manager") {
//       Get.toNamed('/manager');
//     }
//   }
}
