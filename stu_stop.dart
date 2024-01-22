import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class stustop extends StatefulWidget {
  final String selectedRoute;
  final String selectregion;
  final String fee;

  stustop({
    required this.selectedRoute,
    required this.selectregion,
    required this.fee,
    required String voucherDocumentID,
  });

  @override
  _stustopState createState() => _stustopState();
}

class _stustopState extends State<stustop> {
  loc.Location location = loc.Location();
  LatLng? _currentLocation;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late CollectionReference stopsCollection;
  List<String> stopIds = [];
  @override
  void initState() {
    super.initState();
    // Initialize the Firestore path for the selected route's stops
    stopsCollection = FirebaseFirestore.instance
        .collection('Region')
        .doc('Islamabad')
        .collection('Route')
        .doc('E & F Sector- G Sector')
        .collection('Stops');

    fetchStops();
  }

  Future<void> fetchStops() async {
    try {
      print("Fetching stops...");
      QuerySnapshot<Map<String, dynamic>> stopsQuery =
          await stopsCollection.get() as QuerySnapshot<Map<String, dynamic>>;

      GoogleMapController googleMapController = await _controller.future;
      final currLoc = await location.getLocation();

      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currLoc.latitude!, currLoc.longitude!),
            zoom: 18.0,
          ),
        ),
      );

      setState(() {
        stopIds = stopsQuery.docs.map((doc) {
          print(doc.data().entries);
          return doc.id;
        }).toList();
        _currentLocation = LatLng(currLoc.latitude!, currLoc.longitude!);
      });

      print("Stops fetched successfully: ${stopIds.length} stops");
    } catch (e) {
      print("Error fetching stops: $e");
      // Handle the error as needed, e.g., show an error message to the user.
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Stop'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height / 1.7,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(33.68889, 73.06667),
                  zoom: 12,
                ),
                myLocationEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                circles: Set<Circle>.from([
                  Circle(
                    strokeWidth: 1,
                    circleId: CircleId("radiusCircle"),
                    center: _currentLocation ?? LatLng(0, 0),
                    radius: 2000, // 5 km in meters
                    fillColor: Colors.blue.withOpacity(0.1),
                    strokeColor: Colors.blue,
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 210),
              // child: ElevatedButton(
              //   onPressed: () {
              //     // Navigator.push(
              //     //   context,
              //     //   // MaterialPageRoute(
              //     //   //   builder: (context) =>
              //     //   //       voucher(
              //     //   //           db: FirebaseFirestore
              //     //   //               .instance),
              //     //   // ),
              //     // );
              //   },
              //   child: Text(
              //     'Nearby Stops',
              //     style: TextStyle(
              //       fontSize: 14,
              //     ),
              //   ),
              // ),
            ),
            Padding(
              padding: EdgeInsets.all(9.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          ('${widget.selectedRoute}'),
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 90,
                        ),
                        Text(
                          '${widget.fee}',
                          style: TextStyle(
                            fontSize: 15, // Adjust the font size as needed
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent[100],
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: stopIds.isEmpty
                          ? Center(
                              // Display CircularProgressIndicator when loading
                              child: CircularProgressIndicator(),
                            )
                          // : ListView.builder(
                          //     itemCount: stopIds.length,
                          //     itemBuilder: (context, index) {
                          //       String stopId = stopIds[index];
                          //       return ListTile(
                          //         title: ElevatedButton(
                          //           onPressed: () {
                          //             Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                 builder: (context) => MyBus(
                          //                     selectRoute: widget.selectedRoute,
                          //                     fee: widget.fee),
                          //               ),
                          //             );
                          //           },
                          //           child: Text(stopId),
                          //         ),
                          //       );
                          //     },
                          //   ),
                          : ListView.builder(
                              itemCount: stopIds.length,
                              itemBuilder: (context, index) {
                                String stopId = stopIds[index];
                                return Card(
                                  elevation: 2,
                                  margin: EdgeInsets.all(8),
                                  child: InkWell(
                                    onTap: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => MyBus(
                                      //       selectRoute: widget.selectedRoute,
                                      //       fee: widget.fee,
                                      //       busname: '',
                                      //       color: '',
                                      //       totalseats: 76,
                                      //       selectregion: widget.selectregion,
                                      //       voucherDocumentID: '',
                                      //       voucherURL: '',
                                      //     ),
                                      //   ),
                                      // );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        stopId,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
