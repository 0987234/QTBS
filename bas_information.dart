import 'package:flutter/material.dart';
//
// class BusInformation extends StatefulWidget {
//   const BusInformation({Key? key}) : super(key: key);
//
//   @override
//   State<BusInformation> createState() => _BusInformationState();
// }
//
// class _BusInformationState extends State<BusInformation> {
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Bus Information"),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(20),
//         child: Stack(
//           alignment: Alignment.topLeft,
//           children: [
//             Image.asset('assets/driverinfoo.png', width: 700),
//             SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(top: 270),
//                     child: Text(
//                       "Bus Information:",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: 1, // Set the number of items you want to display
//                     itemBuilder: (BuildContext context, int index) {
//                       return Card(
//                         margin: EdgeInsets.symmetric(vertical: 10),
//                         child: Padding(
//                           padding: EdgeInsets.all(16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Icon(
//                                         Icons.work_outline,
//                                         color: Colors.grey,
//                                       ),
//                                       SizedBox(width: 8),
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text("Operating Hours:"),
//                                           Text(
//                                             "6:20 AM - 12:00 PM",
//                                             style: TextStyle(
//                                               fontSize: 10,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(width: 46),
//                                   Row(
//                                     children: [
//                                       Icon(
//                                         Icons.directions_bus,
//                                         color: Colors.grey,
//                                       ),
//                                       SizedBox(width: 2),
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text("Bus Number"),
//                                           Text(
//                                             " ANJS68",
//                                             style: TextStyle(
//                                               fontSize: 10,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 20),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.location_on,
//                                     color: Colors.grey,
//                                   ),
//                                   SizedBox(width: 8),
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text("Route"),
//                                       Text(
//                                         "Islamabad Express Way",
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BusInformation extends StatefulWidget {
  final String selectRoute;
  final String fees;
  final String busnumber;

  BusInformation({
    required this.selectRoute,
    required this.fees,
    required this.busnumber,
  });

  // const BusInformation({Key? key}) : super(key: key);

  @override
  State<BusInformation> createState() => _BusInformationState();
}

class _BusInformationState extends State<BusInformation> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> busInfo;

  @override
  void initState() {
    super.initState();
    busInfo = fetchBusInformation();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchBusInformation() async {
    // Replace 'your_firestore_path_here' with your actual Firestore path
    final DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.doc('/driverRoute/E_FSectorGSector');
    return await documentReference.get();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bus Information"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Image.asset('assets/driverinfoo.png', width: 700),
            SingleChildScrollView(
              child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: busInfo,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final data = snapshot.data!.data();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 270),
                          child: Text(
                            "Bus Information:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Card(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.work_outline,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Operating Hours:"),
                                            Text(
                                              data!['time'],
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 46),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.directions_bus,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 2),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Bus Number"),
                                            Text(
                                              data['busnumber'],
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Route"),
                                        Text(
                                          data['route'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
