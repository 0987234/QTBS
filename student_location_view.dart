import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:page_transition/page_transition.dart';

import '../../../../Authentication/models/User_model.dart';
import '../../../../utils.dart';
import '../../Student/Payment/pay.dart';
import '../../Student/Profile/profileScreen.dart';
import '../../Student/Profile/profile_controller.dart';
import '../../Student/student registration/login.dart';

// class studentlocationview extends StatefulWidget {
//   final String selectRoute;
//   final String fees;
//   final String busnumber;
//   final String SapId;
//
//   studentlocationview({
//     required this.selectRoute,
//     required this.fees,
//     required this.busnumber,
//     required this.SapId,
//   }) {
//     // assert(voucherDocumentID != null);
//   }
//   @override
//   State<studentlocationview> createState() => _studentlocationviewState();
// }
//
// class _studentlocationviewState extends State<studentlocationview> {
//   final auth = FirebaseAuth.instance;
//   String userName = '';
//
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();
//   final _auth = FirebaseAuth.instance;
//   Map<String, dynamic>? busInfo;
//   final _firestore = FirebaseFirestore.instance;
//   loc.Location location = loc.Location();
//   LatLng? _currentLocation;
//   LatLng? _busLocation;
//   Set<Marker> _markers = Set<Marker>();
//
//   @override
//   void initState() {
//     getLoc();
//     getBusInfo();
//     super.initState();
//   }
//
//   animateCam(data) async {
//     try {
//       var busLoc =
//           LatLng(double.parse(data?["lat"]), double.parse(data?["lng"]));
//       if (_busLocation == null) {
//         setState(() {
//           _busLocation = busLoc;
//         });
//         _addMarker(busLoc);
//       } else if (_busLocation != busLoc) {
//         setState(() {
//           _markers.clear();
//           _busLocation = busLoc;
//         });
//         _addMarker(busLoc);
//       }
//       GoogleMapController googleMapController = await _controller.future;
//       googleMapController.animateCamera(CameraUpdate.newLatLngBounds(
//           LatLngBounds(southwest: _currentLocation!, northeast: _busLocation!),
//           30));
//     } on Exception catch (e) {
//       print(e);
//     }
//   }
//
//   // getBusInfo() async {
//   //   final _busInfo = await _firestore
//   //       .collection('BusRegistrations')
//   //       .where('userId', isEqualTo: _auth.currentUser?.uid)
//   //       .get();
//   //
//   //   print('BusInfo: ${_busInfo.docs.map((doc) => doc.data())}');
//   //
//   //   final f = _busInfo.docs.first.data();
//   //   // final f = _busInfo.docs.isNotEmpty ? _busInfo.docs.first.data() : null;
//   //
//   //   _firestore
//   //       .collection("Region/Islamabad/Route")
//   //       .doc("E_FSectorGSector")
//   //       .collection("Buses")
//   //       .doc(f["busNumber"])
//   //       .snapshots()
//   //       .listen((e) {
//   //     print("object ${e.data()}");
//   //     var data = e.data();
//   //
//   //     animateCam(data);
//   //   });
//   //   setState(() {
//   //     busInfo = f;
//   //   });
//   // }
//
//   // getBusInfo() async {
//   //   try {
//   //     final _busInfo = await _firestore
//   //         .collection('BusRegistrations')
//   //         .where('userId', isEqualTo: _auth.currentUser?.uid)
//   //         .get();
//   //
//   //     print('BusInfo: ${_busInfo.docs.map((doc) => doc.data())}');
//   //
//   //     if (_busInfo.docs.isNotEmpty) {
//   //       final busData = _busInfo.docs.first.data();
//   //       final busNumber = busData['busNumber'];
//   //
//   //       final busSnapshot = await _firestore
//   //           .collection("Region/Islamabad/Route")
//   //           .doc("E_FSectorGSector")
//   //           .collection("Buses")
//   //           .doc(busNumber)
//   //           .get();
//   //
//   //       if (busSnapshot.exists) {
//   //         final busDetails = busSnapshot.data();
//   //         animateCam(busDetails);
//   //         setState(() {
//   //           busInfo = busDetails;
//   //         });
//   //       } else {
//   //         print('Bus details not found for busNumber: $busNumber');
//   //       }
//   //     } else {
//   //       print('Bus information not found for the current user.');
//   //     }
//   //   } catch (e) {
//   //     print('Error getting bus information: $e');
//   //   }
//   // }
//
//   getBusInfo() async {
//     try {
//       final _busInfo = await _firestore
//           .collection('BusRegistrations')
//           .where('userId', isEqualTo: _auth.currentUser?.uid)
//           .get();
//
//       print('BusInfo: ${_busInfo.docs.map((doc) => doc.data())}');
//
//       if (_busInfo.docs.isNotEmpty) {
//         final busData = _busInfo.docs.first.data();
//         final busNumber = busData['busNumber'];
//
//         final busSnapshot = await _firestore
//             .collection("Region/Islamabad/Route")
//             .doc("E_FSectorGSector")
//             .collection("Buses")
//             .doc(busNumber)
//             .get();
//
//         if (busSnapshot.exists) {
//           final busDetails = busSnapshot.data();
//           animateCam(busDetails);
//           setState(() {
//             busInfo = busDetails;
//           });
//         } else {
//           print('Bus details not found for busNumber: $busNumber');
//         }
//       } else {
//         print('Bus information not found for the current user.');
//       }
//     } catch (e) {
//       print('Error getting bus information: $e');
//     }
//   }
//
//   getLoc() async {
//     var serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         return;
//       }
//     }
//
//     var permissionGranted = await location.hasPermission();
//     if (permissionGranted == loc.PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != loc.PermissionStatus.denied) {
//         return;
//       }
//     }
//
//     GoogleMapController googleMapController = await _controller.future;
//
//     Geolocator.getPositionStream(
//         locationSettings: const LocationSettings(
//       accuracy: LocationAccuracy.high,
//       distanceFilter: 10,
//     )).listen((Position position) async {
//       var loc = LatLng(position.latitude, position.longitude);
//
//       final user = await _firestore
//           .collection("Users")
//           .where("Email", isEqualTo: _auth.currentUser?.email)
//           .get();
//       final rev = user.docs.first.reference.id;
//       final cuUser = _firestore.collection("Users").doc(rev);
//
//       cuUser.update(
//           {"lat": loc.latitude.toString(), "lng": loc.longitude.toString()});
//
//       googleMapController.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             target: loc,
//             zoom: 18.0,
//           ),
//         ),
//       );
//     });
//
//     final currLoc = await location.getLocation();
//
//     setState(() {
//       _currentLocation = LatLng(currLoc.latitude!, currLoc.longitude!);
//       _markers.clear();
//     });
//     getBusInfo();
//   }
//
//   Future<void> _addMarker(LatLng position) async {
//     final GoogleMapController controller = await _controller.future;
//     final markerId = MarkerId(position.toString());
//
//     BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
//       const ImageConfiguration(size: Size(30, 30)), // Adjust the size as needed
//       "assets/Bbus.png",
//     );
//
//     setState(() {
//       _markers.add(
//         Marker(
//           icon: customIcon,
//           markerId: markerId,
//           position: position,
//           infoWindow: InfoWindow(
//             title: 'Waypoint',
//             snippet: 'Lat: ${position.latitude}, Lng: ${position.longitude}',
//           ),
//         ),
//       );
//     });
//   }
//
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     // getLoc();
//     return Scaffold(
//         appBar: AppBar(title: Text('Home'), actions: [
//           SizedBox(width: 10),
//         ]),
//         body: SingleChildScrollView(
//             child: SafeArea(
//           child: Column(children: [
//             Container(
//                 height: size.height / 1.7,
//                 child: GoogleMap(
//                   markers: _markers,
//                   myLocationEnabled: true,
//                   initialCameraPosition: CameraPosition(
//                     target: _currentLocation ?? LatLng(33.68889, 73.06667),
//                     zoom: 8,
//                   ),
//                   onMapCreated: (GoogleMapController controller) {
//                     _controller.complete(controller);
//                   },
//                 )),
//             Container(
//               padding: EdgeInsets.all(16.0), // Adjust padding as needed
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(children: [
//                               Icon(
//                                 Icons.access_time_outlined,
//                                 color: Colors.grey,
//                               ),
//                               SizedBox(
//                                 width: 3,
//                               ),
//                               Column(
//                                 children: [
//                                   Text(
//                                     'Time',
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.bold),
//                                   ),
//                                   Text('10:00 am - 4:00pm'),
//                                 ],
//                               ),
//                             ]), // Replace with actual arrival time
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         width: 40,
//                       ),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.directions_bus,
//                                   color: Colors.grey,
//                                 ),
//                                 SizedBox(
//                                   width: 6,
//                                 ),
//                                 Column(
//                                   children: [
//                                     Text(
//                                       'Bus No.',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     Text(busInfo?["busNumber"] ?? ""),
//                                   ],
//                                 ),
//                               ],
//                             ) // Replace with actual bus number
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16.0), // Add spacing between rows
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 30.0, // Adjust size as needed
//                         backgroundImage: AssetImage(
//                             'assets/driver.jpg'), // Replace with actual driver profile image
//                       ),
//                       SizedBox(
//                           width: 16.0), // Add spacing between image and text
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Driver ',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                               'Rizwan Ahmed '), // Replace with actual driver name
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             )
//           ]),
//         )));
//   }
// }
class studentlocationview extends StatefulWidget {
  final String selectRoute;
  final String fees;
  final String busnumber;
  final String SapId;
  final String voucherDocumentID;
  final String voucherURL;

  studentlocationview(
      {required this.selectRoute,
      required this.fees,
      required this.busnumber,
      required this.SapId,
      required this.voucherDocumentID,
      required this.voucherURL}) {
    // assert(voucherDocumentID != null);
  }
  @override
  State<studentlocationview> createState() => _studentlocationviewState();
}

class _studentlocationviewState extends State<studentlocationview> {
  final auth = FirebaseAuth.instance;
  String userName = '';
  final ProfileController profileController = Get.find();

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final _auth = FirebaseAuth.instance;
  Map<String, dynamic>? busInfo;
  final _firestore = FirebaseFirestore.instance;
  loc.Location location = loc.Location();
  LatLng? _currentLocation;
  LatLng? _busLocation;
  Set<Marker> _markers = Set<Marker>();

  Future<String> getVoucherStatus() async {
    try {
      // Replace with your Firestore logic to get the voucher status
      final user = FirebaseAuth.instance.currentUser;
      DocumentSnapshot voucherSnapshot = await FirebaseFirestore.instance
          .collection('Vouchers')
          .doc(user?.uid)
          .get();

      if (voucherSnapshot.exists) {
        String status = voucherSnapshot['status'] ?? 'pending';
        print('Voucher Document ID: ${widget.voucherDocumentID}');
        print('Voucher Status: $status');
        return status;
      } else {
        print('Voucher Document ID: ${widget.voucherDocumentID}');
        print('Voucher Status: pending');
        return 'pending';
      }
    } catch (e) {
      print('Error getting voucher status: $e');
      return 'error';
    }
  }

  @override
  void initState() {
    getLoc();

    super.initState();
  }

  animateCam(data) async {
    try {
      var busLoc =
          LatLng(double.parse(data?["lat"]), double.parse(data?["lng"]));
      if (_busLocation == null) {
        setState(() {
          _busLocation = busLoc;
        });
        _addMarker(busLoc);
      } else if (_busLocation != busLoc) {
        setState(() {
          _markers.clear();
          _busLocation = busLoc;
        });
        _addMarker(busLoc);
      }
      GoogleMapController googleMapController = await _controller.future;
      googleMapController.animateCamera(CameraUpdate.newLatLngBounds(
          LatLngBounds(southwest: _currentLocation!, northeast: _busLocation!),
          30));
    } on Exception catch (e) {
      print(e);
    }
  }

  getBusInfo() async {
    final _busInfo = await _firestore
        .collection('BusRegistrations')
        .where('userId', isEqualTo: _auth.currentUser?.uid)
        .get();

    final f = _busInfo.docs.first.data();

    _firestore
        .collection("Region/Islamabad/Route")
        .doc("E_FSectorGSector")
        .collection("Buses")
        .doc(f["busNumber"])
        .snapshots()
        .listen((e) {
      print("object ${e.data()}");
      var data = e.data();

      animateCam(data);
    });
    setState(() {
      busInfo = f;
    });
  }

  getLoc() async {
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    var permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.denied) {
        return;
      }
    }

    GoogleMapController googleMapController = await _controller.future;

    Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    )).listen((Position position) async {
      var loc = LatLng(position.latitude, position.longitude);

      final user = await _firestore
          .collection("Users")
          .where("Email", isEqualTo: _auth.currentUser?.email)
          .get();
      final rev = user.docs.first.reference.id;
      final cuUser = _firestore.collection("Users").doc(rev);

      cuUser.update(
          {"lat": loc.latitude.toString(), "lng": loc.longitude.toString()});

      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: loc,
            zoom: 18.0,
          ),
        ),
      );
    });

    final currLoc = await location.getLocation();

    setState(() {
      _currentLocation = LatLng(currLoc.latitude!, currLoc.longitude!);
      _markers.clear();
    });
    getBusInfo();
  }

  Future<void> _addMarker(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    final markerId = MarkerId(position.toString());

    BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(30, 30)), // Adjust the size as needed
      "assets/Bbus.png",
    );

    setState(() {
      _markers.add(
        Marker(
          icon: customIcon,
          markerId: markerId,
          position: position,
          infoWindow: InfoWindow(
            title: 'Waypoint',
            snippet: 'Lat: ${position.latitude}, Lng: ${position.longitude}',
          ),
        ),
      );
    });
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // getLoc();
    return Scaffold(
        appBar: AppBar(title: Text('Live Tracking'), actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginScreen(
                              selectRoute: widget.selectRoute,
                              fee: widget.fees,
                              bus: widget.busnumber,
                            )));
              }).onError((error, stackTrace) {
                utils().toastMessage(error.toString());
              });
            },
            icon: Icon(Icons.logout_outlined),
          ),
          SizedBox(width: 10),
        ]),
        body: SingleChildScrollView(
            child: SafeArea(
          child: Column(children: [
            Container(
                height: size.height / 1.7,
                child: GoogleMap(
                  markers: _markers,
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation ?? LatLng(33.68889, 73.06667),
                    zoom: 8,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                )),
            Container(
              padding: EdgeInsets.all(16.0), // Adjust padding as needed
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Icon(
                                Icons.access_time_outlined,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Time',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('10:00 am - 4:00pm'),
                                ],
                              ),
                            ]), // Replace with actual arrival time
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.directions_bus,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Bus No.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(busInfo?["busNumber"] ?? ""),
                                  ],
                                ),
                              ],
                            ) // Replace with actual bus number
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0), // Add spacing between rows
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30.0, // Adjust size as needed
                        backgroundImage: AssetImage(
                            'assets/driverr.jpg'), // Replace with actual driver profile image
                      ),
                      SizedBox(
                          width: 16.0), // Add spacing between image and text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Driver ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                              'Basheer Ahmed '), // Replace with actual driver name
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ]),
        )));
  }
}
