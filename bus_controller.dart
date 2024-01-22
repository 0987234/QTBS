// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class BusFirestoreManager {
//   final String selectedRoute;
//   final String selectRegion;
//   final BuildContext context;
//   final State state;
//   TextEditingController busNameController = TextEditingController();
//   TextEditingController updatedbusNameController = TextEditingController();
//   List<String> busIds = [];
//
//   BusFirestoreManager({
//     required this.selectedRoute,
//     required this.selectRegion,
//     required this.context,
//     required this.state,
//   });
//
//   CollectionReference get busesCollection => FirebaseFirestore.instance
//       .collection('Region')
//       .doc(selectRegion)
//       .collection('Route')
//       .doc(selectedRoute)
//       .collection('Buses');
//
//   Future<void> addBus() async {
//     String busNumber = '';
//
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Add Bus'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 onChanged: (value) {
//                   busNumber = value;
//                 },
//                 decoration: InputDecoration(labelText: 'Enter Bus Number'),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Only alphabets and numbers allowed, maximum 10 characters.',
//                 style: TextStyle(color: Colors.red),
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Add'),
//               onPressed: () async {
//                 if (RegExp(r'^[a-zA-Z0-9]{1,10}$').hasMatch(busNumber)) {
//                   try {
//                     await busesCollection.doc(busNumber).set({
//                       'time': '0',
//                       'seats': 0,
//                     });
//                     fetchBuses();
//                     Navigator.of(context).pop();
//                   } catch (e) {
//                     print('Error adding bus: $e');
//                     // Handle the Firestore write error as needed
//                   }
//                 } else {
//                   print('Invalid input. Please follow the constraints.');
//                   // You can show an error message to the user if needed
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//
// //   Future<void> deleteBus(DocumentReference busRef) async {
// //     try {
// //       // First, get the bus document data to retrieve "time" and "seats"
// //       final busData = (await busRef.get()).data() as Map<String, dynamic>;
// //
// //       // Delete the bus document
// //       await busRef.delete();
// //
// //       // You can access the "time" and "seats" values from busData
// //       final time = busData['time'] as String? ?? '0';
// //       final seats = busData['seats'] ?? 0;
// //
// //       // Now you can do whatever you need with the "time" and "seats" values.
// //       print('Deleted bus: time=$time, seats=$seats');
// //
// //       // Refresh the bus list
// //       fetchBuses();
// //       Navigator.of(context).pop(); // Close the dialog
// //     } catch (e) {
// //       print('Error deleting bus: $e');
// //       // Handle the delete error as needed
// //     }
// //   }
// //
// //   Future<void> updateBusName(
// //       String currentBusName, String updatedBusName) async {
// //     final RegExp alphabetsPattern = RegExp(r'^[A-Za-z\s]+$');
// //     if (!alphabetsPattern.hasMatch(updatedBusName)) {
// //       showDialog(
// //         context: context,
// //         builder: (BuildContext context) {
// //           return AlertDialog(
// //             title: Text('Error'),
// //             content: Text(
// //               'Bus name should consist of alphabets. numbers and special characters are not allowed',
// //             ),
// //             actions: <Widget>[
// //               TextButton(
// //                 child: Text('OK'),
// //                 onPressed: () {
// //                   Navigator.of(context).pop();
// //                 },
// //               ),
// //             ],
// //           );
// //         },
// //       );
// //       return; // Exit the function if the constraint is not met
// //     }
// //
// //     if (busIds.contains(updatedBusName)) {
// //       showDialog(
// //         context: context,
// //         builder: (BuildContext context) {
// //           return AlertDialog(
// //             title: Text('Error'),
// //             content: Text('Bus name already exists'),
// //             actions: <Widget>[
// //               TextButton(
// //                 child: Text('Ok'),
// //                 onPressed: () {
// //                   updatedbusNameController.clear();
// //                   Navigator.of(context).pop();
// //                 },
// //               ),
// //             ],
// //           );
// //         },
// //       );
// //       return;
// //     }
// //     try {
// //       if (currentBusName != updatedBusName) {
// //         // Create a new document with the updated name
// //         await FirebaseFirestore.instance
// //             .collection('Region')
// //             .doc(selectRegion)
// //             .collection('Route')
// //             .doc(selectedRoute)
// //             .collection('Buses')
// //             .doc(updatedBusName)
// //             .set({'name': updatedBusName});
// //
// //         // Delete the old document with the previous name
// //         await FirebaseFirestore.instance
// //             .collection('Region')
// //             .doc(selectRegion)
// //             .collection('Route')
// //             .doc(selectedRoute)
// //             .collection('Stops')
// //             .doc(currentBusName)
// //             .delete();
// //
// //         print('Route name updated: $updatedBusName');
// //       }
// //
// //       // Update the region name in the UI
// //       setState(() {
// //         final index = busIds.indexOf(currentBusName);
// //         if (index != -1) {
// //           busIds[index] = updatedBusName;
// //         }
// //       });
// //
// //       // Show a success message using AlertDialog
// //       showDialog(
// //         context: context,
// //         builder: (BuildContext context) {
// //           return AlertDialog(
// //             title: Text('Success'),
// //             content: Text('Route name updated successfully!'),
// //             actions: <Widget>[
// //               TextButton(
// //                 child: Text('OK'),
// //                 onPressed: () {
// //                   updatedbusNameController.clear();
// //                   Navigator.of(context).pop();
// //                 },
// //               ),
// //             ],
// //           );
// //         },
// //       );
// //     } catch (e) {
// //       // Handle errors here.
// //       print('Error updating route name: $e');
// //     }
// //   }
// //
// //   void handleUpdateRouteName(String currentBusName, String updatedBusName) {
// //     if (currentBusName != updatedBusName) {
// //       // Call the updateRegionName function
// //       updateBusName(currentBusName, updatedBusName);
// //     } else {
// //       // Show a message to inform the user that the names are the same
// //       showDialog(
// //         context: context,
// //         builder: (BuildContext context) {
// //           return AlertDialog(
// //             title: Text('Warning'),
// //             content: Text('The new name is the same as the current name.'),
// //             actions: <Widget>[
// //               TextButton(
// //                 child: Text('OK'),
// //                 onPressed: () {
// //                   Navigator.of(context).pop();
// //                 },
// //               ),
// //             ],
// //           );
// //         },
// //       );
// //     }
// //   }
//
// //
// // }
