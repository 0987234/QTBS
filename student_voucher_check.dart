import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../Authentication/models/User_model.dart';
import '../../Student/Payment/BoardingPass.dart';

import 'package:flutter/material.dart';
import '../../Student/Payment/BoardingPass.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Student/Payment/BoardingPass.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'authentic_user_voucher.dart';

// class YourController {
//   Future<List<UserModel>> getUserData() async {
//     List<UserModel> userList = [];
//
//     try {
//       QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance.collection('Users').get();
//
//       for (QueryDocumentSnapshot doc in querySnapshot.docs) {
//         userList.add(UserModel.fromSnapshot(doc));
//       }
//     } catch (e) {
//       print('Error fetching user records: $e');
//     }
//
//     return userList;
//   }
// }
//
// class Vouchercheck extends StatefulWidget {
//   @override
//   State<Vouchercheck> createState() => _VouchercheckState();
// }
//
// class _VouchercheckState extends State<Vouchercheck> {
//   late YourController controller;
//
//   @override
//   void initState() {
//     super.initState();
//     controller = YourController();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Manager Screen'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: FutureBuilder<List<UserModel>>(
//           future: controller.getUserData(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return Center(child: Text('No user records found.'));
//             } else {
//               List<UserModel> userRecords = snapshot.data!;
//
//               return SingleChildScrollView(
//                 scrollDirection: Axis.vertical,
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: DataTable(
//                     columns: [
//                       DataColumn(label: Text('User Name')),
//                       DataColumn(label: Text('User Email')),
//                       DataColumn(label: Text('Upload Voucher')),
//                     ],
//                     rows: List.generate(userRecords.length, (index) {
//                       UserModel userRecord = userRecords[index];
//
//                       return DataRow(cells: [
//                         DataCell(Text(userRecord.fullName)),
//                         DataCell(Text(userRecord.email)),
//                         DataCell(
//                           ElevatedButton(
//                             onPressed: () {
//                               // Navigate to the AuthenticUserVoucherScreen with the selected user information
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => authenticuser(
//                                     user: userRecord,
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: Text('Upload Voucher'),
//                           ),
//                         ),
//                       ]);
//                     }),
//                   ),
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
//
// // class AcceptVoucherScreen extends StatefulWidget {
// //   final UserModel user;
// //
// //   AcceptVoucherScreen({required this.user});
// //
// //   @override
// //   State<AcceptVoucherScreen> createState() => _AcceptVoucherScreenState();
// // }
// //
// // class _AcceptVoucherScreenState extends State<AcceptVoucherScreen> {
// //   late YourController controller;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     controller = YourController();
// //   }
// //
// //   @override
// //   // Widget build(BuildContext context) {
// //   //   // You can use the user information to fetch and display the user's uploaded voucher
// //   //   return Scaffold(
// //   //     appBar: AppBar(
// //   //       title: Text('Accept Voucher Screen'),
// //   //     ),
// //   //     body: Center(
// //   //       child: Column(
// //   //         mainAxisAlignment: MainAxisAlignment.center,
// //   //         crossAxisAlignment: CrossAxisAlignment.center,
// //   //         children: [
// //   //           Text('User Name: ${widget.user.fullName}'),
// //   //           Text('User Email: ${widget.user.email}'),
// //   //           Text('Implement your voucher upload logic here'),
// //   //         ],
// //   //       ),
// //   //     ),
// //   //   );
// //   // }
// //
// //   Widget build(BuildContext context) {
// //     String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Accept Voucher Screen'),
// //       ),
// //       body: FutureBuilder<DocumentSnapshot>(
// //         future: FirebaseFirestore.instance
// //             .collection('Vouchers')
// //             .doc(widget.user
// //                 .uid) // Assuming user.uid is the unique identifier for each user
// //             .get(),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return Center(child: CircularProgressIndicator());
// //           } else if (snapshot.hasError) {
// //             return Center(child: Text('Error: ${snapshot.error}'));
// //           } else if (!snapshot.hasData || !snapshot.data!.exists) {
// //             return Center(child: Text('No voucher found for this user.'));
// //           } else {
// //             // Display the voucher image using the URL from Firestore
// //             final voucherURL = snapshot.data!['voucherURL'];
// //             return Image.network(
// //               voucherURL,
// //               width: 360,
// //               height: 340,
// //               fit: BoxFit.cover,
// //             );
// //           }
// //         },
// //       ),
// //     );
// //   }
// // }
//
// class AcceptVoucherScreen extends StatefulWidget {
//   final UserModel user;
//
//   const AcceptVoucherScreen({required this.user});
//
//   @override
//   State<AcceptVoucherScreen> createState() => _AcceptVoucherScreenState();
// }
//
// class _AcceptVoucherScreenState extends State<AcceptVoucherScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Accept Voucher Screen'),
//       ),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: FirebaseFirestore.instance
//             .collection('Vouchers')
//             .doc(widget.user.Sapid) // Use the UID of the selected user
//             .get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || !snapshot.data!.exists) {
//             return Center(child: Text('No voucher found for this user.'));
//           } else {
//             // Display the voucher image using the URL from Firestore
//             final voucherURL = snapshot.data!['voucherURL'];
//             return Image.network(
//               voucherURL,
//               width: 360,
//               height: 340,
//               fit: BoxFit.cover,
//             );
//           }
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class Vouchercheck extends StatefulWidget {
//   @override
//   State<Vouchercheck> createState() => _VouchercheckState();
// }
//
// class _VouchercheckState extends State<Vouchercheck> {
//   late CollectionReference busesCollection;
//
//   @override
//   void initState() {
//     super.initState();
//     busesCollection = FirebaseFirestore.instance.collection('BusRegistrations');
//   }
//
//   Future<List<Map<String, dynamic>>?> fetchBusRegistrations() async {
//     try {
//       QuerySnapshot querySnapshot = await busesCollection.get();
//
//       if (querySnapshot.docs.isNotEmpty) {
//         List<Map<String, dynamic>> busRegistrations = [];
//         querySnapshot.docs.forEach((doc) {
//           Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//           data['id'] = doc.id;
//           data['voucherURL'] =
//               data['voucherURL'] ?? ''; // Null check for voucherURL
//           busRegistrations.add(data);
//         });
//         return busRegistrations;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print('Error fetching bus registrations: $e');
//       return null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Check Voucher"),
//       ),
//       body: FutureBuilder(
//         future: fetchBusRegistrations(),
//         builder:
//             (context, AsyncSnapshot<List<Map<String, dynamic>>?> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Text('No bus registrations found.');
//           } else {
//             List<Map<String, dynamic>> busRegistrations = snapshot.data!;
//
//             return SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: DataTable(
//                   dataRowHeight: 60,
//                   columns: <DataColumn>[
//                     DataColumn(
//                       label: Text('Email'),
//                     ),
//                     DataColumn(
//                       label: Text('Bus Number'),
//                     ),
//                     DataColumn(
//                       label: Text('Route'),
//                     ),
//                     DataColumn(
//                       label: Text('Voucher'),
//                     )
//                   ],
//                   rows: busRegistrations.map((registration) {
//                     return DataRow(
//                       cells: <DataCell>[
//                         DataCell(Text(registration['userEmail'].toString())),
//                         DataCell(Text(registration['busNumber'].toString())),
//                         DataCell(Text(registration['Route'].toString())),
//                         DataCell(
//                           ElevatedButton(
//                             onPressed: () async {
//                               print('userId: ${registration['userId']}');
//
//                               // Check if there is a voucher for the user in the 'Vouchers' collection
//                               DocumentSnapshot voucherSnapshot =
//                                   await FirebaseFirestore.instance
//                                       .collection('Vouchers')
//                                       .doc(registration['userId'])
//                                       .get();
//
//                               if (voucherSnapshot.exists) {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => VoucherDisplayScreen(
//                                       voucherDocumentID: voucherSnapshot.id,
//                                       voucherURL: voucherSnapshot['voucherURL'],
//                                     ),
//                                   ),
//                                 );
//                               } else {
//                                 // Handle the case where there is no voucher for the user
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) {
//                                     return AlertDialog(
//                                       title: Text('Error'),
//                                       content: Text(
//                                           'No voucher found for this user.'),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () {
//                                             Navigator.pop(context);
//                                           },
//                                           child: Text('OK'),
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 );
//                               }
//                             },
//                             child: Text('Upload Voucher'),
//                           ),
//                         ),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class Vouchercheck extends StatefulWidget {
//   @override
//   State<Vouchercheck> createState() => _VouchercheckState();
// }
//
// class _VouchercheckState extends State<Vouchercheck> {
//   late CollectionReference busesCollection;
//
//   @override
//   void initState() {
//     super.initState();
//     busesCollection = FirebaseFirestore.instance.collection('BusRegistrations');
//   }
//
//   Future<List<Map<String, dynamic>>?> fetchBusRegistrations() async {
//     try {
//       QuerySnapshot querySnapshot = await busesCollection.get();
//
//       if (querySnapshot.docs.isNotEmpty) {
//         List<Map<String, dynamic>> busRegistrations = [];
//         querySnapshot.docs.forEach((doc) {
//           Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//           data['id'] = doc.id;
//           data['voucherURL'] =
//               data['voucherURL'] ?? ''; // Null check for voucherURL
//           busRegistrations.add(data);
//         });
//         return busRegistrations;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print('Error fetching bus registrations: $e');
//       return null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Check Voucher"),
//       ),
//       body: FutureBuilder(
//         future: fetchBusRegistrations(),
//         builder:
//             (context, AsyncSnapshot<List<Map<String, dynamic>>?> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Text('No bus registrations found.');
//           } else {
//             List<Map<String, dynamic>> busRegistrations = snapshot.data!;
//
//             return SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: DataTable(
//                   dataRowHeight: 60,
//                   columns: <DataColumn>[
//                     DataColumn(
//                       label: Text('Email'),
//                     ),
//                     DataColumn(
//                       label: Text('Bus Number'),
//                     ),
//                     DataColumn(
//                       label: Text('Route'),
//                     ),
//                     DataColumn(
//                       label: Text('Voucher'),
//                     )
//                   ],
//                   rows: busRegistrations.map((registration) {
//                     return DataRow(
//                       cells: <DataCell>[
//                         DataCell(Text(registration['userEmail'].toString())),
//                         DataCell(Text(registration['busNumber'].toString())),
//                         DataCell(Text(registration['Route'].toString())),
//                         DataCell(
//                           ElevatedButton(
//                             onPressed: () async {
//                               print('userId: ${registration['userId']}');
//
//                               // Check if there is a voucher for the user in the 'Vouchers' collection
//                               DocumentSnapshot voucherSnapshot =
//                                   await FirebaseFirestore.instance
//                                       .collection('Vouchers')
//                                       .doc(registration['userId'])
//                                       .get();
//
//                               if (voucherSnapshot.exists) {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => VoucherDisplayScreen(
//                                       voucherDocumentID: voucherSnapshot.id,
//                                       voucherURL: voucherSnapshot['voucherURL'],
//                                     ),
//                                   ),
//                                 );
//                               } else {
//                                 // Handle the case where there is no voucher for the user
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) {
//                                     return AlertDialog(
//                                       title: Text('Error'),
//                                       content: Text(
//                                           'No voucher found for this user.'),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () {
//                                             Navigator.pop(context);
//                                           },
//                                           child: Text('OK'),
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 );
//                               }
//                             },
//                             child: Text('Upload Voucher'),
//                           ),
//                         ),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

class Vouchercheck extends StatefulWidget {
  @override
  State<Vouchercheck> createState() => _VouchercheckState();
}

class _VouchercheckState extends State<Vouchercheck> {
  late CollectionReference busesCollection;

  @override
  void initState() {
    super.initState();
    busesCollection = FirebaseFirestore.instance.collection('BusRegistrations');
  }

  Future<List<Map<String, dynamic>>?> fetchBusRegistrations() async {
    try {
      QuerySnapshot querySnapshot = await busesCollection.get();

      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> busRegistrations = [];
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          data['voucherURL'] =
              data['voucherURL'] ?? ''; // Null check for voucherURL
          busRegistrations.add(data);
        });
        return busRegistrations;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching bus registrations: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Check Voucher"),
      ),
      body: FutureBuilder(
        future: fetchBusRegistrations(),
        builder:
            (context, AsyncSnapshot<List<Map<String, dynamic>>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No bus registrations found.');
          } else {
            List<Map<String, dynamic>> busRegistrations = snapshot.data!;

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  dataRowHeight: 60,
                  columns: <DataColumn>[
                    DataColumn(
                      label: Text('Email'),
                    ),
                    DataColumn(
                      label: Text('Bus Number'),
                    ),
                    DataColumn(
                      label: Text('Route'),
                    ),
                    DataColumn(
                      label: Text('Voucher'),
                    )
                  ],
                  rows: busRegistrations.map((registration) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(registration['userEmail'].toString())),
                        DataCell(Text(registration['busNumber'].toString())),
                        DataCell(Text(registration['Route'].toString())),
                        DataCell(
                          GestureDetector(
                            onTap: () async {
                              print('userId: ${registration['userId']}');

                              // Check if there is a voucher for the user in the 'Vouchers' collection
                              DocumentSnapshot voucherSnapshot =
                                  await FirebaseFirestore.instance
                                      .collection('Vouchers')
                                      .doc(registration['userId'])
                                      .get();

                              if (voucherSnapshot.exists) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VoucherDisplayScreen(
                                      voucherDocumentID: voucherSnapshot.id,
                                      voucherURL: voucherSnapshot['voucherURL'],
                                    ),
                                  ),
                                );
                              } else {
                                // Handle the case where there is no voucher for the user
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Error'),
                                      content: Text(
                                          'No voucher found for this user.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: Text(
                              'Submitted Voucher',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
