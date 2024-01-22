import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'allote_buses.dart';
//
// class driverroute extends StatefulWidget {
//   final String selectregion;
//   final String selectedRoute;
//
//   driverroute({required this.selectregion, required this.selectedRoute});
//
//   @override
//   State<driverroute> createState() => _driverrouteState();
// }
//
// class _driverrouteState extends State<driverroute> {
//   Future<List<QueryDocumentSnapshot>> _fetchRoute() async {
//     final querySnapshot = await FirebaseFirestore.instance
//         .collection('Region')
//         .doc(widget.selectregion)
//         .collection('Route')
//         .get();
//
//     final routeDataList = querySnapshot.docs.toList();
//     print("My Debug: $routeDataList");
//
//     return routeDataList;
//   }
//
//   Future<List<QueryDocumentSnapshot>> _fetchBuses(String routeName) async {
//     final querySnapshot = await FirebaseFirestore.instance
//         .collection('Region')
//         .doc(widget.selectregion)
//         .collection('Route')
//         .doc(routeName)
//         .collection('Buses')
//         .get();
//
//     final busDataList = querySnapshot.docs.toList();
//     print("My Debug Buses: $busDataList");
//
//     return busDataList;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Choose Route"),
//         backgroundColor: Colors.blue[400],
//       ),
//       body: ConstrainedBox(
//         constraints: BoxConstraints(
//           maxHeight: MediaQuery.of(context).size.height,
//         ),
//         child: FutureBuilder<List<QueryDocumentSnapshot>>(
//           future: _fetchRoute(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.done) {
//               if (snapshot.hasData) {
//                 final routeDataList = snapshot.data!;
//                 return SingleChildScrollView(
//                   child: Column(
//                     children: routeDataList.map((document) {
//                       final routeName = document.id;
//                       final fee = document.get('fees');
//
//                       return Container(
//                         margin: EdgeInsets.symmetric(vertical: 10),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8.0),
//                           border: Border.all(
//                             width: 1.0,
//                           ),
//                           gradient: LinearGradient(
//                             colors: [
//                               Colors.blue.shade400,
//                               Colors.blue.shade700,
//                             ],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                         ),
//                         child: Card(
//                           elevation: 4.0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           child: ListTile(
//                             title: Text(
//                               routeName,
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                             subtitle: Text(
//                               'Fee: $fee',
//                               style: TextStyle(
//                                 fontSize: 12,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                             onTap: () {
//                               // Fetch buses for the selected route
//                               _fetchBuses(routeName).then((busDataList) {
//                                 double parsedFee =
//                                     double.tryParse(fee.toString()) ?? 0.0;
//                                 // Now you can navigate to a new screen or
//                                 // do something with the bus data
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => allotebuses(
//                                       routeName: routeName,
//                                       fee: parsedFee,
//                                       busDataList: busDataList,
//                                       selectregion: '',
//                                     ),
//                                   ),
//                                 );
//                               });
//                             },
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 );
//               } else {
//                 return Center(child: Text('No route data available'));
//               }
//             } else {
//               return Center(child: CircularProgressIndicator());
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
