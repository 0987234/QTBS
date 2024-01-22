import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'driver_region.dart';
//
// class BusInformationPage extends StatefulWidget {
//   @override
//   State<BusInformationPage> createState() => _BusInformationPageState();
// }
//
// class _BusInformationPageState extends State<BusInformationPage> {
//   Future<List<QueryDocumentSnapshot>> _fetchDrivers() async {
//     final querySnapshot = await FirebaseFirestore.instance
//         .collection('/Users') // Update with your actual path
//         .where('role',
//             isEqualTo: 'driver') // Add the condition to filter drivers
//         .get();
//
//     final driverList = querySnapshot.docs.where((doc) => doc.exists).toList();
//     print("My Debug Drivers: $driverList");
//
//     return driverList;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Bus Allocation',
//           style: GoogleFonts.poppins(
//             fontSize: 20,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blue[900],
//       ),
//       body: Stack(
//         children: [
//           Container(
//             color: Colors.grey[200],
//           ),
//           Center(
//             child: Container(
//               width: 500,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 5,
//                     blurRadius: 7,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(16),
//                     child: Text(
//                       'Bus Allocation',
//                       style: GoogleFonts.poppins(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: FutureBuilder<List<QueryDocumentSnapshot>>(
//                       future: _fetchDrivers(),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState == ConnectionState.done) {
//                           if (snapshot.hasData) {
//                             final driverList = snapshot.data!;
//                             return ListView.separated(
//                               padding: EdgeInsets.all(16),
//                               itemCount: driverList.length,
//                               itemBuilder: (context, index) {
//                                 final driverData = driverList[index].data()
//                                     as Map<String, dynamic>?;
//                                 final driverName =
//                                     driverData?['FullName'] ?? 'N/A';
//                                 return GestureDetector(
//                                   onTap: () {
//                                     // Handle card tap and navigate to another screen
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => DriverRouteBus()
//                                           //     DriverDetailsScreen(
//                                           //   driverData: driverData,
//                                           // ),
//
//                                           ),
//                                     );
//                                   },
//                                   child: Card(
//                                     elevation: 5,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(16),
//                                     ),
//                                     child: ListTile(
//                                       leading: CircleAvatar(
//                                         child: Icon(Icons.person),
//                                         backgroundColor: Colors.blue[400],
//                                         foregroundColor: Colors.white,
//                                       ),
//                                       title: Text(
//                                         // Use the actual data for the title
//                                         driverName,
//                                         style: GoogleFonts.poppins(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                       subtitle: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           // You may add more details here if needed
//                                         ],
//                                       ),
//                                       // trailing: Row(
//                                       //   mainAxisSize: MainAxisSize.min,
//                                       //   children: [
//                                       //     IconButton(
//                                       //       icon: Icon(Icons.edit),
//                                       //       onPressed: () {
//                                       //         // Handle edit button click
//                                       //       },
//                                       //     ),
//                                       //     IconButton(
//                                       //       icon: Icon(Icons.delete),
//                                       //       onPressed: () {
//                                       //         // Handle delete button click
//                                       //       },
//                                       //       color: Colors.redAccent,
//                                       //     ),
//                                       //   ],
//                                       // ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                               separatorBuilder: (context, index) =>
//                                   SizedBox(height: 16),
//                             );
//                           } else {
//                             return Center(child: Text('No drivers found'));
//                           }
//                         } else {
//                           return Center(child: CircularProgressIndicator());
//                         }
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//
// class BusInformationPage extends StatefulWidget {
//   @override
//   State<BusInformationPage> createState() => _BusInformationPageState();
// }
//
// class _BusInformationPageState extends State<BusInformationPage> {
//   Future<List<QueryDocumentSnapshot>> _fetchDrivers() async {
//     final querySnapshot = await FirebaseFirestore.instance
//         .collection('/Users')
//         .where('role', isEqualTo: 'driver')
//         .get();
//
//     final driverList = querySnapshot.docs.where((doc) => doc.exists).toList();
//     print("My Debug Drivers: $driverList");
//
//     // Store role in the driverinformation collection
//     for (final driverDoc in driverList) {
//       final driverData = driverDoc.data() as Map<String, dynamic>;
//       final driverId = driverDoc.id; // Use the driver's ID as the document ID
//       final driverName = driverData['FullName'] ?? 'N/A';
//       final driverRole = driverData['role'] ?? 'N/A';
//
//       // Create a document in the driverinformation collection with the driver's role
//       await FirebaseFirestore.instance
//           .collection('driverinformation')
//           .doc(driverId)
//           .set({
//         'driverId': driverId,
//         'driverName': driverName,
//         'role': driverRole,
//       });
//     }
//
//     return driverList;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Bus Allocation',
//           style: GoogleFonts.poppins(
//             fontSize: 20,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blue[900],
//       ),
//       body: Stack(
//         children: [
//           Container(
//             color: Colors.grey[200],
//           ),
//           Center(
//             child: Container(
//               width: 500,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 5,
//                     blurRadius: 7,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(16),
//                     child: Text(
//                       'Bus Allocation',
//                       style: GoogleFonts.poppins(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: FutureBuilder<List<QueryDocumentSnapshot>>(
//                       future: _fetchDrivers(),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState == ConnectionState.done) {
//                           if (snapshot.hasData) {
//                             final driverList = snapshot.data!;
//                             return ListView.separated(
//                               padding: EdgeInsets.all(16),
//                               itemCount: driverList.length,
//                               itemBuilder: (context, index) {
//                                 final driverData = driverList[index].data()
//                                     as Map<String, dynamic>?;
//                                 final driverName =
//                                     driverData?['FullName'] ?? 'N/A';
//                                 return GestureDetector(
//                                   onTap: () {
//                                     // Handle card tap and navigate to another screen
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => DriverRouteBus()
//                                           //     DriverDetailsScreen(
//                                           //   driverData: driverData,
//                                           // ),
//
//                                           ),
//                                     );
//                                   },
//                                   child: Card(
//                                     elevation: 5,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(16),
//                                     ),
//                                     child: ListTile(
//                                       leading: CircleAvatar(
//                                         child: Icon(Icons.person),
//                                         backgroundColor: Colors.blue[400],
//                                         foregroundColor: Colors.white,
//                                       ),
//                                       title: Text(
//                                         // Use the actual data for the title
//                                         driverName,
//                                         style: GoogleFonts.poppins(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                       subtitle: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           // You may add more details here if needed
//                                         ],
//                                       ),
//                                       // trailing: Row(
//                                       //   mainAxisSize: MainAxisSize.min,
//                                       //   children: [
//                                       //     IconButton(
//                                       //       icon: Icon(Icons.edit),
//                                       //       onPressed: () {
//                                       //         // Handle edit button click
//                                       //       },
//                                       //     ),
//                                       //     IconButton(
//                                       //       icon: Icon(Icons.delete),
//                                       //       onPressed: () {
//                                       //         // Handle delete button click
//                                       //       },
//                                       //       color: Colors.redAccent,
//                                       //     ),
//                                       //   ],
//                                       // ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                               separatorBuilder: (context, index) =>
//                                   SizedBox(height: 16),
//                             );
//                           } else {
//                             return Center(child: Text('No drivers found'));
//                           }
//                         } else {
//                           return Center(child: CircularProgressIndicator());
//                         }
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class DriverRouteBus extends StatefulWidget {
//   @override
//   State<DriverRouteBus> createState() => _DriverRouteBusState();
// }
//
// class _DriverRouteBusState extends State<DriverRouteBus> {
//   Future<List<QueryDocumentSnapshot>> _fetchRoute() async {
//     final querySnapshot = await FirebaseFirestore.instance
//         .collection('Region')
//         .doc('Islamabad')
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
//         .doc('Islamabad')
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
//                                     builder: (context) => BusListScreen(
//                                       routeName: routeName,
//                                       fee: parsedFee,
//                                       busDataList: busDataList,
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
//
// class BusListScreen extends StatelessWidget {
//   final String routeName;
//   final double fee;
//   final List<QueryDocumentSnapshot> busDataList;
//
//   BusListScreen({
//     required this.routeName,
//     required this.fee,
//     required this.busDataList,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Buses for $routeName"),
//         backgroundColor: Colors.blue[400],
//       ),
//       body: ListView.builder(
//         itemCount: busDataList.length,
//         itemBuilder: (context, index) {
//           final busData = busDataList[index].data() as Map<String, dynamic>?;
//           final busName = busData?['busname'] ?? 'N/A';
//           // final driverName = busData?['color'] ?? 'N/A';
//           final color = busData?['color'] ?? 'N/A';
//           final time = busData?['time'] ?? 'N/A';
//           final totalseats = busData?['totalseats'] ?? 'N/A';
//
//           return ListTile(
//             title: Text(busName),
//             subtitle: Text('Driver: $color'),
//             // Add more details if needed
//           );
//         },
//       ),
//     );
//   }
// }

class BusInformationPage extends StatefulWidget {
  @override
  State<BusInformationPage> createState() => _BusInformationPageState();
}

class _BusInformationPageState extends State<BusInformationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Bus Information', style: GoogleFonts.poppins(fontSize: 20)),
        centerTitle: true,
        // leading: IconButton(
        //   onPressed: () => Navigator.pop(context),
        //   // icon:icon.,
        // ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/reg manager.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Text('Bus Information',
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Card(
                      child: ListTile(
                        title: Text('Islamabad Expressway-Kasmir Highway'),
                        subtitle: Text('6:20 am-12:00pm'),
                        leading: CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        trailing: Text('Rizwan Ahmed'),
                      ),
                    ),
                    Column(
                      children: [
                        Card(
                          child: ListTile(
                            title: Text('Islamabad Expressway-Kasmir Highway'),
                            subtitle: Text('8:30 am-2:00pm'),
                            leading: CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            trailing: Text('Shafiq Khan'),
                          ),
                        ),
                      ],
                    ),
                    Card(
                      child: ListTile(
                        title: Text('Islamabad Expressway-Kasmir Highway'),
                        subtitle: Text('10:00 am-4:10pm'),
                        leading: CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        trailing: Text('Rana Waqas'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//
// return ListView.builder(
// shrinkWrap: true,
// itemCount: busRegistrations.length,
// itemBuilder: (context, index) {
// final registration = busRegistrations[index];
//
// return Card(
// margin: EdgeInsets.symmetric(vertical: 10),
// child: Padding(
// padding: EdgeInsets.all(16),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Row(
// children: [
// Row(
// children: [
// Icon(
// Icons.calendar_today,
// color: Colors.grey,
// ),
// SizedBox(width: 8),
// Column(
// children: [
// Text("Date"),
// Text(
// "${registration['registrationDate']}",
// style: TextStyle(
// fontSize: 12,
// fontWeight: FontWeight.bold,
// ),
// ),
// ],
// ),
// ],
// ),
// SizedBox(
// width: 46,
// ),
// Row(children: [
// Icon(
// Icons.payment,
// color: Colors.grey,
// ),
// SizedBox(width: 31),
// Column(
// children: [
// Text("Payment"),
// Text(
// "${registration['fees']}",
// style: TextStyle(
// fontSize: 12,
// fontWeight: FontWeight.bold,
// ),
// ),
// ],
// ),
// ]),
// ],
// ),
// SizedBox(
// height: 30,
// ),
// Row(
// children: [
// Row(children: [
// Icon(
// Icons.directions_bus,
// color: Colors.grey,
// ),
// SizedBox(width: 8),
// Column(
// children: [
// Text("Bus Number"),
// Text(
// " ${registration['busNumber']}",
// style: TextStyle(
// fontSize: 12,
// fontWeight: FontWeight.bold,
// ),
// ),
// ],
// ),
// ]),
// SizedBox(
// width: 20,
// ),
// Row(children: [
// Icon(
// Icons.location_on,
// color: Colors.grey,
// ),
// SizedBox(width: 8),
// Column(
// children: [
// Text("Route"),
// Text(
// "${registration['Route']}",
// style: TextStyle(
// fontSize: 12,
// fontWeight: FontWeight.bold,
// ),
// ),
// ],
// ),
// ]),
// ],
// ),
// ],
// ),
// ),
// );
// },
// );
