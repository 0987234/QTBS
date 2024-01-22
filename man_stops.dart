import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_project/UI/module/Manager/manager_routes/managestops.dart';
import '../manager_busesdetails/manbus_details.dart';

class StopManagerScreen extends StatefulWidget {
  final String selectedroute;
  final String selectregion;
  StopManagerScreen({required this.selectedroute, required this.selectregion});

  @override
  State<StopManagerScreen> createState() => _StopManagerScreenState();
}

class _StopManagerScreenState extends State<StopManagerScreen> {
  late FirestoreManager firestoreManager;
  List<String> stopIds = [];

  void initState() {
    super.initState();
    firestoreManager = FirestoreManager(
      selectedRoute: widget.selectedroute,
      selectRegion: widget.selectregion,
      context: context,
      state: this,
    );
    fetchStops();
  }

  Future<void> fetchStops() async {
    await firestoreManager.fetchStops(stopIds);
  }

  Future<void> addStop(String stopName) async {
    await firestoreManager.addStop(stopName);
  }

  Future<void> _showDeleteConfirmationDialog(String stopId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to delete this stop?'),
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
              child: Text('Delete'),
              onPressed: () {
                firestoreManager.deleteRoute(stopId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Stop'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Center(
                    child: Image(
                      width: 500,
                      height: 300,
                      image: AssetImage('assets/NearBy Stop.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: firestoreManager.stopNameController,
                      decoration: InputDecoration(hintText: 'Enter stop name'),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        String stopName =
                            firestoreManager.stopNameController.text.trim();
                        if (stopName.isNotEmpty) {
                          addStop(stopName);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.all(9.0),
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ('${widget.selectedroute}'),
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 207,
                      width: 400,
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: FutureBuilder<void>(
                        future: fetchStops(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: ListView.builder(
                                itemCount: stopIds.length,
                                itemBuilder: (context, index) {
                                  String stopId = stopIds[index];
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    mandetails(
                                                  selectRoute:
                                                      widget.selectedroute,
                                                  selectregion:
                                                      widget.selectregion,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(stopId),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          _showDeleteConfirmationDialog(stopId);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Edit stop Name'),
                                                content: TextField(
                                                  controller: firestoreManager
                                                      .updatedstopNameController,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Enter updated stop name',
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text('Save'),
                                                    onPressed: () {
                                                      String updatedStopName =
                                                          firestoreManager
                                                              .updatedstopNameController
                                                              .text
                                                              .trim();
                                                      final RegExp
                                                          alphabetsPattern =
                                                          RegExp(
                                                              r'^[A-Za-z\s]+$');
                                                      if (!alphabetsPattern
                                                          .hasMatch(
                                                              updatedStopName)) {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title:
                                                                  Text('Error'),
                                                              content: Text(
                                                                'Route name should consist of alphabets only. Numbers and special characters are not allowed.',
                                                              ),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  child: Text(
                                                                      'OK'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      } else {
                                                        // Implement your logic to update the stop name in Firestore
                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          }
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
