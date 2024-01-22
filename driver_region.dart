import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'allote_buses.dart';

// class driver_route_bus extends StatefulWidget {
//   @override
//   State<driver_route_bus> createState() => _driver_route_busState();
// }
//
// class _driver_route_busState extends State<driver_route_bus> {
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
//                               // Navigator.push(
//                               //   context,
//                               //   MaterialPageRoute(
//                               //     builder: (context) => NearbyStop(
//                               //       selectedRoute: document.id,
//                               //       selectregion: widget.selectregion,
//                               //       fee: fee,
//                               //       voucherDocumentID: widget.voucherDocumentID,
//                               //     ),
//                               //   ),
//                               // );
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

// class DriverDetailsScreen extends StatelessWidget {
//   final Map<String, dynamic>? driverData;
//
//   DriverDetailsScreen({required this.driverData});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Driver Details',
//           style: GoogleFonts.poppins(
//             fontSize: 20,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blue[900],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Driver Name: ${driverData?['FullName'] ?? 'N/A'}',
//               style: GoogleFonts.poppins(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             // Add more details as needed
//           ],
//         ),
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
//           final driverName = busData?['FullName'] ?? 'N/A';
//
//           return ListTile(
//             title: Text(busName),
//             subtitle: Text('Driver: $driverName'),
//             // Add more details if needed
//           );
//         },
//       ),
//     );
//   }
// }

class driverregion extends StatefulWidget {
  // const driverregion({Key? key}) : super(key: key);

  final String selectregion;
  final String selectedRoute;
  driverregion({required this.selectregion, required this.selectedRoute});

  @override
  State<driverregion> createState() => _driverregionState();
}

class _driverregionState extends State<driverregion> {
  String selectregion = '';

  Future<List<QueryDocumentSnapshot>> _fetchRegion() async {
    final regionquery =
        await FirebaseFirestore.instance.collection('Region').get();

    final regionDataList = regionquery.docs.where((doc) => doc.exists).toList();
    print("My Debug: $regionDataList");

    return regionDataList;
  }

  Future<List<QueryDocumentSnapshot>> _fetchRoute(String selectedRegion) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Region')
        .doc(selectedRegion)
        .collection('Route')
        .get();

    final routeDataList =
        querySnapshot.docs.where((doc) => doc.exists).toList();
    print("My Debug: $routeDataList");

    return routeDataList;
  }

  // Future<List<QueryDocumentSnapshot>> _fetchBuses(String routeName) async {
  //   final querySnapshot = await FirebaseFirestore.instance
  //       .collection('Region')
  //       .doc('widget.')
  //       .collection('Route')
  //       .doc(routeName)
  //       .collection('Buses')
  //       .get();
  //
  //   final busDataList = querySnapshot.docs.toList();
  //   print("My Debug Buses: $busDataList");
  //
  //   return busDataList;
  // }

  Future<List<QueryDocumentSnapshot>> _fetchBuses(
      String selectedRegion, String routeName) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Region')
        .doc(selectedRegion)
        .collection('Route')
        .doc(routeName)
        .collection('Buses')
        .get();

    final busDataList = querySnapshot.docs.toList();
    print("My Debug Buses: $busDataList");

    return busDataList;
  }

  void _showRouteBottomSheet(String selectedRegion) {
    showModalBottomSheet(
      backgroundColor: Colors.blue,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(50))),
      context: context,
      builder: (context) {
        return FutureBuilder<List<QueryDocumentSnapshot>>(
          future: _fetchRoute(selectedRegion),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final routeDataList = snapshot.data!;
                return Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blue[600],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Routes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: routeDataList.length,
                          itemBuilder: (context, index) {
                            final document = routeDataList[index];
                            final routeName = document.id;
                            final fee = document.get('fees');

                            return Card(
                              elevation: 4.0,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(
                                  routeName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Fee: $fee',
                                  style: TextStyle(fontSize: 14),
                                ),
                                onTap: () {
                                  // Fetch buses for the selected route
                                  _fetchBuses(selectedRegion, routeName)
                                      .then((busDataList) {
                                    double parsedFee =
                                        double.tryParse(fee.toString()) ?? 0.0;
                                    // Now you can navigate to a new screen or
                                    // do something with the bus data
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => allotebuses(
                                          routeName: routeName,
                                          fee: parsedFee,
                                          busDataList: busDataList,
                                          selectregion: widget.selectregion,
                                          selectRegion: '',
                                        ),
                                      ),
                                    );
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(child: Text('No route data available'));
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }

  // Stream<QuerySnapshot<Map<String, dynamic>>> _fetchData() {
  //   return FirebaseFirestore.instance.collection('Region').snapshots();

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Region'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(
              (context),
            );
          },
        ),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _fetchRegion(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final regionDataList = snapshot.data!;
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/reg manager.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.only(
                        left: 100, top: 370, right: 70, bottom: 70),
                    child: Column(
                      children: regionDataList.map((document) {
                        return TextButton(
                          onPressed: () {
                            _showRouteBottomSheet(document.id);
                          },
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.blue,
                            ),
                            child: Text(
                              document.id.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: Text('No route data available'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

// class DriverRouteBus extends StatefulWidget {
//   @override
//   State<DriverRouteBus> createState() => _DriverRouteBusState();
// }
//
// class _DriverRouteBusState extends State<DriverRouteBus> {
//   TextEditingController searchController = TextEditingController();
//   late List<QueryDocumentSnapshot> allDrivers;
//   late List<QueryDocumentSnapshot> displayedDrivers;
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize the list of all drivers
//     _fetchDrivers().then((drivers) {
//       setState(() {
//         allDrivers = drivers;
//         displayedDrivers = drivers;
//       });
//     });
//   }
//
//   Future<List<QueryDocumentSnapshot>> _fetchDrivers() async {
//     final querySnapshot = await FirebaseFirestore.instance
//         .collection('/Users')
//         .where('role', isEqualTo: 'driver')
//         .get();
//
//     final driverList = querySnapshot.docs.where((doc) => doc.exists).toList();
//     print("My Debug Drivers: $driverList");
//
//     return driverList;
//   }
//
//   void _filterDrivers(String query) {
//     setState(() {
//       displayedDrivers = allDrivers
//           .where((driver) => driver
//               .get('FullName')
//               .toLowerCase()
//               .contains(query.toLowerCase()))
//           .toList();
//     });
//   }
//
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
