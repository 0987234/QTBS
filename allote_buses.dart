import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// class allotebuses extends StatefulWidget {
//   final String selectregion;
//   final String routeName;
//   final double fee;
//   final List<QueryDocumentSnapshot> busDataList;
//
//   allotebuses({
//     required this.selectregion,
//     required this.routeName,
//     required this.fee,
//     required this.busDataList,
//   });
//
//   @override
//   State<allotebuses> createState() => _allotebusesState();
// }
//
// class _allotebusesState extends State<allotebuses> {
//   late CollectionReference<Map<String, dynamic>> busesCollection;
//   List<String> busIds = [];
//   bool busesLoaded = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize the Firestore path for the selected route's buses
//     busesCollection = FirebaseFirestore.instance
//         .collection('Region')
//         .doc('Islamabad')
//         .collection('Route')
//         .doc(widget.routeName)
//         .collection('Buses');
//
//     // Call fetchBuses to load the data when the widget is first created
//     // fetchBuses();
//   }
//
//   // Future<void> fetchBuses() async {
//   //   try {
//   //     print("Fetching buses..."); // Update the log message
//   //     QuerySnapshot<Map<String, dynamic>> busesQuery =
//   //         await busesCollection.get();
//   //
//   //     setState(() {
//   //       busIds = busesQuery.docs.map((doc) {
//   //         return doc.id;
//   //       }).toList();
//   //       busesLoaded = true;
//   //     });
//   //
//   //     print("Buses fetched successfully: ${busIds.length} buses");
//   //   } catch (e) {
//   //     print("Error fetching buses: $e");
//   //     // Handle the error as needed, e.g., show an error message to the user.
//   //   }
//   // }
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
//     return MaterialApp(
//       color: Colors.blue,
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Select Bus'),
//           leading: IconButton(
//             icon: Icon(
//               Icons.arrow_back,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               Navigator.pop(
//                 (context),
//               );
//             },
//           ),
//         ),
//         body: Stack(
//           children: [
//             Container(
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage('assets/Bus background.png'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Container(
//                   height: MediaQuery.of(context).size.height - 400,
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 2),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Center(
//                             child: StreamBuilder<QuerySnapshot>(
//                               stream: busesCollection.snapshots(),
//                               builder: (context, snapshot) {
//                                 if (snapshot.hasData) {
//                                   List<QueryDocumentSnapshot> busDocuments =
//                                       snapshot.data!.docs;
//
//                                   return Column(
//                                     children: busDocuments.map((busDocument) {
//                                       final busData = busDocument.data()
//                                           as Map<String, dynamic>;
//
//                                       final timeData = busDocument.data()
//                                           as Map<String, dynamic>;
//                                       final time =
//                                           timeData['time'] as String? ??
//                                               '0'; // Access 'time' as a string
//                                       // final time =
//                                       //     int.tryParse(timeString) ?? 0;
//                                       final busNumber =
//                                           busDocument.id.toString();
//                                       // int seats = busData['seats'] ?? 0;
//                                       int seats = int.tryParse(
//                                               busData['seats'].toString()) ??
//                                           0;
//
//                                       return Column(
//                                         children: [
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               const SizedBox(height: 3),
//                                               Image.asset(
//                                                 'assets/bus_icon.png',
//                                                 width: 60,
//                                                 height: 60,
//                                               ),
//                                               SizedBox(
//                                                 width: 15,
//                                               ),
//                                               Text(
//                                                 busNumber,
//                                                 style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 19,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//
//                                           // Display available seats count
//
//                                           Container(
//                                             width: 350,
//                                             margin:
//                                                 const EdgeInsets.only(top: 0),
//                                             decoration: BoxDecoration(
//                                               color: Colors.lightBlue[400],
//                                               borderRadius:
//                                                   BorderRadius.circular(20),
//                                             ),
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 3, top: 10),
//                                               child: Row(
//                                                 children: [
//                                                   Column(
//                                                     children: [
//                                                       Text(
//                                                         ('${widget.routeName}'),
//                                                         style: TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           fontSize: 14,
//                                                         ),
//                                                       ),
//                                                       SizedBox(
//                                                         height: 10,
//                                                       ),
//
// //
//                                                       Text(
//                                                         ' $time',
//                                                         style: TextStyle(
//                                                           fontSize: 14,
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                         ),
//                                                       ),
// //
//                                                     ],
//                                                   ),
//                                                   SizedBox(
//                                                     width: 30,
//                                                   ),
//                                                   Padding(
//                                                     padding: EdgeInsets.only(
//                                                         left: 12,
//                                                         right: 3,
//                                                         bottom: 12),
//                                                     child: Column(
//                                                       children: [
//                                                         ElevatedButton(
//                                                           onPressed: () {
//                                                             Navigator.push(
//                                                               context,
//                                                               MaterialPageRoute(
//                                                                 builder:
//                                                                     (context) =>
//                                                                         bdescription(),
//                                                               ),
//                                                             );
//                                                           },
//                                                           child: Text(
//                                                             'description',
//                                                             style: TextStyle(
//                                                               fontSize: 14,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         SizedBox(
//                                                           height: 5,
//                                                         ),
//                                                         Text(
//                                                           'Available Seats: $seats',
//                                                           style: TextStyle(
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             fontSize: 14,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       );
//                                     }).toList(),
//                                   );
//                                 } else {
//                                   return Text(
//                                     'No documents found',
//                                   );
//                                 }
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class allotebuses extends StatefulWidget {
  final String selectregion;
  final String routeName;
  final double fee;
  final List<QueryDocumentSnapshot> busDataList;

  allotebuses({
    required this.selectregion,
    required this.routeName,
    required this.fee,
    required this.busDataList,
    required String selectRegion,
  });

  @override
  State<allotebuses> createState() => _allotebusesState();
}

class _allotebusesState extends State<allotebuses> {
  late CollectionReference busesCollection; // Removed the generic type

  List<String> busIds = [];
  bool busesLoaded = false;
  bool busAdded = false;
  String selectedBusNumber = "";

  @override
  void initState() {
    super.initState();
    // Initialize the Firestore path for the selected route's buses
    busesCollection = FirebaseFirestore.instance
        .collection('Region')
        .doc('Islamabad')
        .collection('Route')
        .doc(widget.routeName)
        .collection('Buses');

    // Call fetchBuses to load the data when the widget is first created
    fetchBuses();
  }

  Future<void> fetchBuses() async {
    try {
      print("Fetching buses..."); // Update the log message
      QuerySnapshot busesQuery =
          await busesCollection.get(); // Removed the generic type

      setState(() {
        busIds = busesQuery.docs.map((doc) {
          return doc.id;
        }).toList();
        busesLoaded = true;
      });

      print("Buses fetched successfully: ${busIds.length} buses");
    } catch (e) {
      print("Error fetching buses: $e");
      // Handle the error as needed, e.g., show an error message to the user.
    }
  }

  // Future<void> addBus() async {
  //   String busNumber = '';
  //   String driverName = ''; // Added driverName variable
  //   bool showError = false; // Initialize showError to false
  //
  //   await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Add Bus'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               onChanged: (value) {
  //                 busNumber = value;
  //                 // Clear the error message when the user starts typing
  //                 setState(() {
  //                   showError = false;
  //                 });
  //               },
  //               decoration: InputDecoration(labelText: 'Enter Bus Number'),
  //             ),
  //             TextField(
  //               onChanged: (value) {
  //                 driverName = value;
  //               },
  //               decoration: InputDecoration(labelText: 'Enter Driver Name'),
  //             ),
  //             SizedBox(height: 10),
  //             if (showError) // Show the error message conditionally
  //               Text(
  //                 'Only capital letters and numbers allowed at the same time, maximum 10 characters.',
  //                 style: TextStyle(color: Colors.red),
  //               ),
  //           ],
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: Text('Add'),
  //             onPressed: () async {
  //               if (RegExp(r'^(?=.*[A-Z])(?=.*[0-9])[A-Z0-9]{1,10}$')
  //                   .hasMatch(busNumber)) {
  //                 try {
  //                   await busesCollection.doc(busNumber).set({
  //                     'time': '0',
  //                     'seats': 0,
  //                     'driver': driverName, // Add driver information
  //                   });
  //                   fetchBuses();
  //                   Navigator.of(context).pop();
  //                   setState(() {
  //                     busAdded = true;
  //                   });
  //                   selectedBusNumber = busNumber;
  //                 } catch (e) {
  //                   print('Error adding bus: $e');
  //                   // Handle the Firestore write error as needed
  //                 }
  //               } else {
  //                 // Set the showError flag to true to display the error message
  //                 setState(() {
  //                   showError = true;
  //                 });
  //               }
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Future<void> addBus() async {
  //   String busNumber = '';
  //   String driverName = ''; // Added driverName variable
  //   bool showError = false; // Initialize showError to false
  //
  //   GlobalKey<FormState> formKey = GlobalKey<FormState>(); // Add a GlobalKey
  //
  //   await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Add Bus'),
  //         content: Form(
  //           key: formKey, // Assign the GlobalKey to the Form
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               TextFormField(
  //                 onChanged: (value) {
  //                   busNumber = value;
  //                   // Clear the error message when the user starts typing
  //                   setState(() {
  //                     showError = false;
  //                   });
  //                 },
  //                 decoration: InputDecoration(labelText: 'Enter Bus Number'),
  //               ),
  //               TextFormField(
  //                 onChanged: (value) {
  //                   driverName = value;
  //                 },
  //                 decoration: InputDecoration(labelText: 'Enter Driver Name'),
  //                 validator: (value) {
  //                   if (value != null &&
  //                       !RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
  //                     return 'Driver name should contain only alphabets.';
  //                   }
  //                   return null;
  //                 },
  //               ),
  //               SizedBox(height: 10),
  //               if (showError) // Show the error message conditionally
  //                 Text(
  //                   'Only capital letters and numbers allowed at the same time, maximum 10 characters.',
  //                   style: TextStyle(color: Colors.red),
  //                 ),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: Text('Add'),
  //             onPressed: () async {
  //               if (formKey.currentState?.validate() ?? false) {
  //                 // Validate the form before proceeding
  //                 try {
  //                   await busesCollection.doc(busNumber).set({
  //                     'time': '0',
  //                     'seats': 0,
  //                     'driver': driverName, // Add driver information
  //                   });
  //                   fetchBuses();
  //                   Navigator.of(context).pop();
  //                   setState(() {
  //                     busAdded = true;
  //                   });
  //                   selectedBusNumber = busNumber;
  //                 } catch (e) {
  //                   print('Error adding bus: $e');
  //                   // Handle the Firestore write error as needed
  //                 }
  //               } else {
  //                 // Set the showError flag to true to display the error message
  //                 setState(() {
  //                   showError = true;
  //                 });
  //               }
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> editBus(String busId, String currentDriverName) async {
    String newDriverName =
        currentDriverName; // Initialize with current driver name
    bool showError = false; // Initialize showError to false

    GlobalKey<FormState> formKey = GlobalKey<FormState>(); // Add a GlobalKey

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Bus'),
          content: Form(
            key: formKey, // Assign the GlobalKey to the Form
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Bus No: $busId'),
                TextFormField(
                  onChanged: (value) {
                    newDriverName = value;
                    // Clear the error message when the user starts typing
                    setState(() {
                      showError = false;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Edit Driver Name',
                    hintText: currentDriverName,
                  ),
                  validator: (value) {
                    if (value != null &&
                        !RegExp(r'^[a-zA-Z ]{3,25}$').hasMatch(value)) {
                      return 'Driver name should contain only alphabets.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                if (showError) // Show the error message conditionally
                  Text(
                    'Only alphabets are allowed, both uppercase and lowercase.',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  // Validate the form before proceeding
                  try {
                    await busesCollection.doc(busId).update({
                      'drivername': newDriverName, // Update driver name
                    });
                    fetchBuses();
                    Navigator.of(context).pop();
                  } catch (e) {
                    print('Error editing bus: $e');
                    // Handle the Firestore write error as needed
                  }
                } else {
                  // Set the showError flag to true to display the error message
                  setState(() {
                    showError = true;
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Future<void> deleteBus(String busId) async {
  //   try {
  //     await busesCollection.doc(busId).delete();
  //     fetchBuses(); // Refresh the bus list
  //   } catch (e) {
  //     print('Error deleting bus: $e');
  //     // Handle the Firestore delete error as needed
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // fetchBuses();
    return MaterialApp(
      color: Colors.blue,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Bus Information'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
          ),
        ),
        body: Stack(
          children: [
            // Container(
            //   decoration: const BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage('assets/Bus background.png'),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            Container(
              color: Colors.grey[200],
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text('Bus Information',
                      style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 260),
                  child: Row(
                    children: [
                      // Expanded(
                      //     // child: TextField(
                      //     //   // controller: regionNameController,
                      //     //   decoration: InputDecoration(
                      //     //     hintText: 'Enter name',
                      //     //   ),
                      //     // ),
                      //     ),
                      // Container(
                      //     decoration: BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       color: Colors.blue,
                      //     ),
                      //     child: PopupMenuButton<int>(
                      //       itemBuilder: (context) => [
                      //         PopupMenuItem(
                      //           value: 1,
                      //           child: Text("Add Bus"),
                      //         ),
                      //         PopupMenuItem(
                      //           value: 2,
                      //           child: Text("Add Driver"),
                      //           enabled: busAdded,
                      //         ),
                      //       ],
                      //       // onSelected: (value) {
                      //       //   if (value == 1) {
                      //       //     addBus();
                      //       //     //Handle add bus option
                      //       //   } else if (value == 2) {
                      //       //     if (busAdded) {
                      //       //       // Call the addSeats function for the selected bus here
                      //       //       // addDriver(
                      //       //       //     selectedBusNumber); // Pass the bus number or bus ID to the function
                      //       //     } // Handle "Add Seats" option
                      //       //   }
                      //       // },
                      //     )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 400,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Center(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: busesCollection.snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<QueryDocumentSnapshot> busDocuments =
                                      snapshot.data!.docs;

                                  return Column(
                                    children: busDocuments.map((busDocument) {
                                      final busData = busDocument.data()
                                          as Map<String, dynamic>;

                                      final timeData = busDocument.data()
                                          as Map<String, dynamic>;
                                      final time =
                                          timeData['time'] as String? ?? '0';

                                      final busNumber =
                                          busDocument.id.toString();
                                      final driverName = busData['drivername']
                                              as String? ??
                                          ''; // Get driver name from Firestore data
                                      int seats = int.tryParse(
                                              busData['seats'].toString()) ??
                                          0;

                                      final b = busDocument.id.toString();
                                      int totalseats = int.tryParse(
                                              busData['totalseats']
                                                  .toString()) ??
                                          0;

                                      return Column(
                                        children: [
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 500,
                                                  height: 150,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Positioned(
                                                                      top: 12,
                                                                      left: 13,
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          // _openDrawer();
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          padding:
                                                                              EdgeInsets.all(10.0),
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/bus_icon.png',
                                                                            width:
                                                                                40,
                                                                            height:
                                                                                30,
                                                                          ),
                                                                        ),
                                                                      )),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Column(
                                                                children: [
                                                                  Text(
                                                                    busNumber,
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                  Text(
                                                                    '$driverName',
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .grey),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 50),
                                                            child: SizedBox(
                                                              width: 231,
                                                              height:
                                                                  100, // Set the width as needed
                                                              child: Card(
                                                                elevation: 1,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            3),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Column(
                                                                              children: [
                                                                                Text(
                                                                                  ('${widget.routeName}'), // Corrected from 'widget.selectedroute'
                                                                                  style: TextStyle(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 12,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 8,
                                                                                ),
                                                                                Text(
                                                                                  ' $time',
                                                                                  style: TextStyle(
                                                                                    fontSize: 13,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 8,
                                                                                ),
                                                                                Text(
                                                                                  'Total Seats: $totalseats',
                                                                                  style: TextStyle(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 13,
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
                                                              ),
                                                            ),
                                                          ),
                                                          // Row(
                                                          //   children: [
                                                          //     IconButton(
                                                          //       icon: Icon(
                                                          //           Icons.edit),
                                                          //       onPressed: () {
                                                          //         editBus(
                                                          //             busDocument
                                                          //                 .id,
                                                          //             driverName);
                                                          //       },
                                                          //     ),
                                                          //   ],
                                                          // ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 70),
                                                            child: Row(
                                                              children: [
                                                                // IconButton(
                                                                //   icon: Icon(
                                                                //       Icons.edit),
                                                                //   onPressed: () {
                                                                //     editBus(
                                                                //         busDocument
                                                                //             .id,
                                                                //         driverName);
                                                                //   },
                                                                // ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    editBus(
                                                                        busDocument
                                                                            .id,
                                                                        driverName);
                                                                  },
                                                                  child: Text(
                                                                    'Edit Driver',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .blue,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .underline,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  );
                                } else {
                                  return Text(
                                    'No documents found',
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
