import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:test_project/utils.dart';
import '../Student/Profile/profile_controller.dart';
import 'driver_drawer.dart';

class TrackBusLocation extends StatefulWidget {
  // const TrackBusLocation({super.key});

  final String selectRoute;
  final String fees;
  final String busnumber;

  TrackBusLocation({
    required this.selectRoute,
    required this.fees,
    required this.busnumber,
  });

  @override
  State<TrackBusLocation> createState() => _TrackBusLocationState();
}

class _TrackBusLocationState extends State<TrackBusLocation> {
  String userName = '';
  final ProfileController profileController = Get.find();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  loc.Location location = loc.Location();
  LatLng? _currentLocation;
  final _firestore = FirebaseFirestore.instance;
  final studentsList = [];
  Set<Marker> _markers = Set<Marker>();

  Future<List<QueryDocumentSnapshot>> _fetchRoute() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Region')
        .doc('Islamabad')
        .collection('Route')
        .doc(widget.selectRoute)
        .get();

    final routeDataList = querySnapshot.get(QueryDocumentSnapshot).toList();
    print("My Debug: $routeDataList");

    return routeDataList;
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  void initState() {
    getLoc();
    super.initState();
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
    )).listen((Position position) {
      var loc = LatLng(position.latitude, position.longitude);

      _markers.removeWhere((e) => e.mapsId == const MarkerId("bus"));
      _addMarker(loc, isBus: true);

      _firestore
          .collection("Region/Islamabad/Route")
          .doc(widget.selectRoute)
          .collection("Buses")
          .doc("URJ903")
          .update({
        "lat": loc.latitude.toString(),
        "lng": loc.longitude.toString()
      });

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
    _addMarker(_currentLocation!, isBus: true);
    getStudents();
  }

  getStudents() async {
    final stu = await _firestore
        .collection("BusRegistrations")
        .where("busNumber", isEqualTo: "URJ903")
        .where("Route", isEqualTo: widget.selectRoute)
        .get();

    // assert(stu.size > 0);
    for (var element in stu.docs) {
      var e = element.data();

      final user = await _firestore
          .collection("Users")
          .where("Email", isEqualTo: e["userEmail"])
          .get();
      var user0 = user.docs.first.data();
      final rev = user.docs.first.reference.id;
      studentsList.add(user0);
      if (user0.keys.contains("lat") && user0.keys.contains("lng")) {
        var stuLoc =
            LatLng(double.parse(user0["lat"]), double.parse(user0["lng"]));
        _addMarker(stuLoc, name: "${user0["FullName"]} : ${user0["Email"]} ");
      }
    }
  }

  Future<void> _addMarker(LatLng position,
      {String? name = "Waypoint", bool isBus = false}) async {
    // final GoogleMapController controller = await _controller.future;
    final markerId = MarkerId(isBus ? "bus" : position.toString());

    // BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
    //   const ImageConfiguration(size: Size(30, 30)), // Adjust the size as needed
    //   "assets/Bbus.png",
    // );

    BitmapDescriptor icon = await getIcon('assets/bus.png');

    setState(() {
      _markers.add(
        Marker(
          icon: isBus ? icon : BitmapDescriptor.defaultMarker,
          markerId: markerId,
          position: position,
          infoWindow: InfoWindow(
            title: name,
            snippet: 'Lat: ${position.latitude}, Lng: ${position.longitude}',
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // getLoc();
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: DriverDrawer(
          selectRoute: widget.selectRoute,
          fees: '',
          busnumber: '',
        ),
        body: Stack(
          children: [
            SizedBox(
              height: 420.h,
              child: GoogleMap(
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: _currentLocation ?? LatLng(33.68889, 73.06667),
                  zoom: 10,
                ),
                markers: _markers,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 272.h,
                width: double.maxFinite,
                color: Colors.lightBlueAccent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Track Bus Location",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.sp),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, right: 8.0, top: 5),
                      child: Container(
                        height: 232.h,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.work_outline,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        "Arrive in:",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.sp),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.directions_bus,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        "Bus No:",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.sp),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "6:10am - 4:00pm",
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                    Text(
                                      "URJ903",
                                      style: TextStyle(fontSize: 16.sp),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        //      color: Colors.pink,
                                        child:
                                            Image.asset("assets/circle.png")),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8.0.w),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "E_FSectorGSector",
                                            style: TextStyle(fontSize: 16.sp),
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          Container(
                                            height: 1.h,
                                            width: 255.w,
                                            color: Colors.grey.withOpacity(0.3),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.only(left: 25.0.w),
                            //   child: Container(
                            //     color: Colors.grey,
                            //     height: 45.h,
                            //     width: 2.w,
                            //   ),
                            // ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Container(
                                    //     //    color: Colors.pink,
                                    //     child: Image.asset("assets/share.png")),
                                    // Padding(
                                    //   padding: EdgeInsets.only(left: 8.0.w),
                                    //   child: Column(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.start,
                                    //     crossAxisAlignment:
                                    //         CrossAxisAlignment.start,
                                    //     children: [
                                    //       Text(
                                    //         "IslamabadExpressWay",
                                    //         style: TextStyle(fontSize: 16.sp),
                                    //       ),
                                    //       SizedBox(
                                    //         height: 2.h,
                                    //       ),
                                    //       Container(
                                    //         height: 1.h,
                                    //         width: 255.w,
                                    //         color: Colors.grey.withOpacity(0.3),
                                    //       )
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            // Row(
                            //   children: [
                            //     SizedBox(
                            //       width: 35.w,
                            //     ),
                            //     Image.asset(height: 40.h, "assets/avatar.png"),
                            //     SizedBox(
                            //       width: 20.w,
                            //     ),
                            //     const Text(
                            //       "Rizwan Ahmed",
                            //       style: TextStyle(fontWeight: FontWeight.bold),
                            //     )
                            //   ],
                            // )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                top: 12,
                left: 13,
                child: GestureDetector(
                  onTap: () {
                    _openDrawer();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.menu, // Replace with the desired icon
                      size: 25.h, // Adjust the size as needed
                      color: Colors.black, // Set the color of the icon
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

//
// class TrackBusLocation extends StatefulWidget {
//   // const TrackBusLocation({super.key});
//
//   final String selectRoute;
//   final String fees;
//   final String busnumber;
//
//   TrackBusLocation({
//     required this.selectRoute,
//     required this.fees,
//     required this.busnumber,
//   });
//
//   @override
//   State<TrackBusLocation> createState() => _TrackBusLocationState();
// }
//
// class _TrackBusLocationState extends State<TrackBusLocation> {
//   String userName = '';
//   final ProfileController profileController = Get.find();
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();
//   loc.Location location = loc.Location();
//   LatLng? _currentLocation;
//   final _firestore = FirebaseFirestore.instance;
//   final studentsList = [];
//   Set<Marker> _markers = Set<Marker>();
//
//
//
//   void _openDrawer() {
//     _scaffoldKey.currentState?.openDrawer();
//   }
//
//   @override
//   void initState() {
//     getLoc();
//     super.initState();
//   }
//
//
//
//   Future<void> _addMarker(LatLng position,
//       {String? name = "Waypoint", bool isBus = false, String? markerId}) async {
//     final GoogleMapController controller = await _controller.future;
//
//     // Use the provided markerId or create a new one from the position
//     final MarkerId id = MarkerId(markerId ?? position.toString());
//
//     // BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
//     //   const ImageConfiguration(size: Size(30, 30)), // Adjust the size as needed
//     //   "assets/Bbus.png",
//     // );
//
//     BitmapDescriptor icon = await getIcon('assets/bus.png');
//
//     setState(() {
//       _markers.add(
//         Marker(
//           icon: isBus ? icon : BitmapDescriptor.defaultMarker,
//           markerId: id,
//           position: position,
//           infoWindow: InfoWindow(
//             title: name,
//             snippet: 'Lat: ${position.latitude}, Lng: ${position.longitude}',
//           ),
//         ),
//       );
//     });
//   }
//
//
//
//   Future<List<QueryDocumentSnapshot>> _fetchRoute() async {
//     final querySnapshot = await FirebaseFirestore.instance
//         .collection('Region')
//         .doc('Islamabad')
//         .collection('Route')
//         .doc(widget.selectRoute)
//         .collection('Buses')
//         .get();
//
//     final busDataList = querySnapshot.docs;
//
//     return busDataList;
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
//     // Fetch bus data for the selected route
//     QuerySnapshot<Map<String, dynamic>> busSnapshot =
//         (await _fetchRoute()) as QuerySnapshot<Map<String, dynamic>>;
//
//     for (QueryDocumentSnapshot<Map<String, dynamic>> busDocument
//         in busSnapshot.docs) {
//       var busData = busDocument.data();
//       String busNumber = busData["busNumber"];
//
//       Geolocator.getPositionStream(
//         locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.high,
//           distanceFilter: 10,
//         ),
//       ).listen((Position position) {
//         var loc = LatLng(position.latitude, position.longitude);
//
//         _markers.removeWhere((e) => e.markerId == MarkerId(busNumber));
//         _addMarker(loc, isBus: true, markerId: busNumber);
//
//         // Update the bus location in Firestore
//         FirebaseFirestore.instance
//             .collection('Region')
//             .doc('Islamabad')
//             .collection('Route')
//             .doc(widget.selectRoute)
//             .collection('Buses')
//             .doc(busNumber)
//             .update({
//           'lat': loc.latitude.toString(),
//           'lng': loc.longitude.toString(),
//         });
//
//         googleMapController.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(
//               target: loc,
//               zoom: 18.0,
//             ),
//           ),
//         );
//       });
//     }
//
//     final currLoc = await location.getLocation();
//
//     setState(() {
//       _currentLocation = LatLng(currLoc.latitude!, currLoc.longitude!);
//       _markers.clear();
//     });
//     _addMarker(_currentLocation!, isBus: true);
//     getStudents();
//   }
//
//   getStudents() async {
//     // Fetch students for the selected route
//     final stu = await _firestore
//         .collection("BusRegistrations")
//         .where("Route", isEqualTo: widget.selectRoute)
//         .get();
//
//     for (var element in stu.docs) {
//       var e = element.data();
//
//       final user = await _firestore
//           .collection("Users")
//           .where("Email", isEqualTo: e["userEmail"])
//           .get();
//       var user0 = user.docs.first.data();
//       final rev = user.docs.first.reference.id;
//       studentsList.add(user0);
//       if (user0.keys.contains("lat") && user0.keys.contains("lng")) {
//         var stuLoc =
//             LatLng(double.parse(user0["lat"]), double.parse(user0["lng"]));
//         _addMarker(stuLoc, name: "${user0["FullName"]} : ${user0["Email"]} ");
//       }
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     // getLoc();
//     return SafeArea(
//       child: Scaffold(
//         key: _scaffoldKey,
//         drawer: const DriverDrawer(),
//         body: Stack(
//           children: [
//             SizedBox(
//               height: 420.h,
//               child: GoogleMap(
//                 myLocationEnabled: true,
//                 initialCameraPosition: CameraPosition(
//                   target: _currentLocation ?? LatLng(33.68889, 73.06667),
//                   zoom: 10,
//                 ),
//                 markers: _markers,
//                 onMapCreated: (GoogleMapController controller) {
//                   _controller.complete(controller);
//                 },
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 height: 272.h,
//                 width: double.maxFinite,
//                 color: Color(0xff88bfd9),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: 5.h,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Text(
//                         "Track Bus Location",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 20.sp),
//                       ),
//                     ),
//                     Padding(
//                       padding:
//                           const EdgeInsets.only(left: 8.0, right: 8.0, top: 5),
//                       child: Container(
//                         height: 232.h,
//                         width: double.maxFinite,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15.r),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               height: 20.h,
//                             ),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 12.0),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     "Arrive in:",
//                                     style: TextStyle(
//                                         color: Colors.grey, fontSize: 16.sp),
//                                   ),
//                                   Text(
//                                     "Bus No:",
//                                     style: TextStyle(
//                                         color: Colors.grey, fontSize: 16.sp),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 12.0),
//                               child: Container(
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       "6:20 am - 12:00 pm",
//                                       style: TextStyle(fontSize: 16.sp),
//                                     ),
//                                     Text(
//                                       widget.busnumber,
//                                       style: TextStyle(fontSize: 16.sp),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 10.h,
//                             ),
//                             Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 12.0.w),
//                               child: Container(
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                         //      color: Colors.pink,
//                                         child:
//                                             Image.asset("assets/circle.png")),
//                                     Padding(
//                                       padding: EdgeInsets.only(left: 8.0.w),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             widget.selectRoute,
//                                             style: TextStyle(fontSize: 16.sp),
//                                           ),
//                                           SizedBox(
//                                             height: 2.h,
//                                           ),
//                                           Container(
//                                             height: 1.h,
//                                             width: 255.w,
//                                             color: Colors.grey.withOpacity(0.3),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(left: 25.0.w),
//                               child: Container(
//                                 color: Colors.grey,
//                                 height: 45.h,
//                                 width: 2.w,
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 12.0.w),
//                               child: Container(
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                         //    color: Colors.pink,
//                                         child: Image.asset("assets/share.png")),
//                                     Padding(
//                                       padding: EdgeInsets.only(left: 8.0.w),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "IslamabadExpressWay",
//                                             style: TextStyle(fontSize: 16.sp),
//                                           ),
//                                           SizedBox(
//                                             height: 2.h,
//                                           ),
//                                           Container(
//                                             height: 1.h,
//                                             width: 255.w,
//                                             color: Colors.grey.withOpacity(0.3),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 15.h,
//                             ),
//                             // Row(
//                             //   children: [
//                             //     SizedBox(
//                             //       width: 35.w,
//                             //     ),
//                             //     Image.asset(height: 40.h, "assets/avatar.png"),
//                             //     SizedBox(
//                             //       width: 20.w,
//                             //     ),
//                             //     const Text(
//                             //       "Rizwan Ahmed",
//                             //       style: TextStyle(fontWeight: FontWeight.bold),
//                             //     )
//                             //   ],
//                             // )
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             Positioned(
//                 top: 12,
//                 left: 13,
//                 child: GestureDetector(
//                   onTap: () {
//                     _openDrawer();
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white,
//                     ),
//                     padding: EdgeInsets.all(10.0),
//                     child: Icon(
//                       Icons.menu, // Replace with the desired icon
//                       size: 25.h, // Adjust the size as needed
//                       color: Colors.black, // Set the color of the icon
//                     ),
//                   ),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }
