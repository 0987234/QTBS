import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//
// class voucherstatus extends StatefulWidget {
//   const voucherstatus({Key? key}) : super(key: key);
//
//   @override
//   State<voucherstatus> createState() => _voucherstatusState();
// }
//
// class _voucherstatusState extends State<voucherstatus> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final CollectionReference _voucherCollection =
//       FirebaseFirestore.instance.collection('Vouchers');
//   final CollectionReference _voucherStatusCollection =
//       FirebaseFirestore.instance.collection('VouchersStatus');
//   DateTime parsedDate = DateTime.now();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Voucher Status"),
//       ),
//       body: FutureBuilder(
//         future: fetchVoucherData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
//             return Center(child: Text('No voucher status found'));
//           } else {
//             List<Map<String, dynamic>> VouchersStatus =
//                 snapshot.data as List<Map<String, dynamic>>;
//
//             return SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: DataTable(
//                   dataRowHeight: 60,
//                   columns: <DataColumn>[
//                     DataColumn(
//                       label: Text('Name'),
//                     ),
//                     DataColumn(
//                       label: Text('YY/MM/DD'),
//                     ),
//                     DataColumn(
//                       label: Text('Route'),
//                     ),
//                     DataColumn(
//                       label: Text('Payment'),
//                     ),
//                     DataColumn(
//                       label: Text('Fine'),
//                     ),
//                     // DataColumn(
//                     //   label: Text('Status'), // New DataColumn for Status
//                     // ),
//                   ],
//                   rows: VouchersStatus.map((voucher) => DataRow(
//                         cells: <DataCell>[
//                           DataCell(Text(voucher['name'].toString())),
//                           DataCell(Text(voucher['date'].toString())),
//                           DataCell(Text(voucher['route'].toString())),
//                           DataCell(Text(voucher['fee'].toString())),
//                           DataCell(Text(voucher['fine'].toString())),
//                           // DataCell(Text(voucher['status'].toString())),
//                         ],
//                       )).toList(),
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
//
//   // Function to fetch a list of bus registrations
//   Future<List<Map<String, dynamic>>> fetchVoucherData() async {
//     final user = _auth.currentUser;
//     if (user == null) {
//       return []; // Return an empty list in case of an error
//     }
//
//     final userId = user.uid;
//
//     try {
//       final querySnapshot = await _voucherStatusCollection
//           .where('userId', isEqualTo: userId)
//           .get();
//
//       if (querySnapshot.docs.isNotEmpty) {
//         final data = querySnapshot.docs
//             .map((doc) => doc.data() as Map<String, dynamic>)
//             .toList();
//         print('Fetched data: $data');
//         return data;
//       }
//     } catch (error) {
//       // Handle errors here if needed
//       print('Error fetching Firestore data: $error');
//     }
//
//     return []; // Return an empty list if any error occurs
//   }
//
//   Future<String> fetchStatusFromVouchers(String voucherId) async {
//     try {
//       final querySnapshot = await _voucherCollection
//           .where('voucherId', isEqualTo: voucherId)
//           .get();
//
//       if (querySnapshot.docs.isNotEmpty) {
//         return querySnapshot.docs.first['status'].toString();
//       }
//     } catch (error) {
//       // Handle errors here if needed
//       print('Error fetching Firestore data: $error');
//     }
//
//     return ''; // Return an empty string if any error occurs
//   }
// }

class voucherstatus extends StatefulWidget {
  const voucherstatus({Key? key}) : super(key: key);

  @override
  State<voucherstatus> createState() => _voucherstatusState();
}

class _voucherstatusState extends State<voucherstatus> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _voucherCollection =
      FirebaseFirestore.instance.collection('Vouchers');
  final CollectionReference _voucherStatusCollection =
      FirebaseFirestore.instance.collection('VouchersStatus');
  DateTime parsedDate = DateTime.now();
  Future<List<Map<String, dynamic>>> fetchVoucherData() async {
    final user = _auth.currentUser;
    if (user == null) {
      return []; // Return an empty list in case of an error
    }

    final userId = user.uid;

    try {
      final querySnapshot = await _voucherStatusCollection
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        print('Fetched data: $data');
        return data;
      }
    } catch (error) {
      // Handle errors here if needed
      print('Error fetching Firestore data: $error');
    }

    return []; // Return an empty list if any error occurs
  }

  Future<String> fetchStatusFromVouchers(String voucherId) async {
    try {
      final querySnapshot = await _voucherCollection
          .where('voucherId', isEqualTo: voucherId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['status'].toString();
      }
    } catch (error) {
      // Handle errors here if needed
      print('Error fetching Firestore data: $error');
    }

    return ''; // Return an empty string if any error occurs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Voucher Status"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Image.asset('assets/voucher.png', width: 400),
            // Replace with your image
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align content to the left
                children: [
                  SizedBox(height: 20), // Add spacing

                  // Reservation table
                  Padding(
                    padding: EdgeInsets.only(top: 270),
                  ),
                  SizedBox(height: 10), // Add spacing
                  FutureBuilder(
                    future: fetchVoucherData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData ||
                          (snapshot.data as List).isEmpty) {
                        return Center(child: Text('No voucher status found'));
                      } else {
                        List<Map<String, dynamic>> VouchersStatus =
                            snapshot.data as List<Map<String, dynamic>>;

                        //         scrollDirection: Axis.vertical,
                        //         child: SingleChildScrollView(
                        //           scrollDirection: Axis.horizontal,
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: VouchersStatus.length,
                          itemBuilder: (context, index) {
                            final voucher = VouchersStatus[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Hello!",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "${voucher['name']}",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 8),
                                            Column(
                                              children: [
                                                Text("Date"),
                                                Text(
                                                  "${voucher['date']}",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 46,
                                        ),
                                        Row(children: [
                                          Icon(
                                            Icons.payment,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(width: 31),
                                          Column(
                                            children: [
                                              Text("Fee"),
                                              Text(
                                                "${voucher['fee']}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      children: [
                                        Row(children: [
                                          Icon(
                                            Icons.attach_money,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(width: 8),
                                          Column(
                                            children: [
                                              Text("Fine"),
                                              Text(
                                                " ${voucher['fine']}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Row(children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(width: 8),
                                          Column(
                                            children: [
                                              Text("Route"),
                                              Text(
                                                "${voucher['route']}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
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

  // Function to fetch a list of bus registrations
}
