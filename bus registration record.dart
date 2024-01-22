import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class busregistration extends StatefulWidget {
  // final String selectRoute;
  //
  // busregistration({required this.selectRoute});
  @override
  State<busregistration> createState() => _busregistrationState();
}

class _busregistrationState extends State<busregistration> {
  late CollectionReference busesCollection;

  @override
  void initState() {
    super.initState();
    busesCollection = FirebaseFirestore.instance.collection('BusRegistrations');
  }

  // Function to fetch a list of bus registrations
  Future<List<Map<String, dynamic>>?> fetchBusRegistrations() async {
    try {
      QuerySnapshot querySnapshot = await busesCollection.get();

      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> busRegistrations = [];
        querySnapshot.docs.forEach((doc) {
          busRegistrations.add(doc.data() as Map<String, dynamic>);
        });
        return busRegistrations;
      } else {
        // Handle the case where there are no bus registrations
        return null;
      }
    } catch (e) {
      print('Error fetching bus registrations: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bus Registrations"),
      ),
      body: FutureBuilder(
        future: fetchBusRegistrations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Text('No bus registrations found.');
          } else {
            List<Map<String, dynamic>> busRegistrations =
                snapshot.data as List<Map<String, dynamic>>;

            return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    dataRowHeight:
                        60, // You can adjust the row height as needed
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text('Email'),
                      ),
                      DataColumn(
                        label: Text('Bus Number'),
                      ),
                      DataColumn(
                        label: Text('Route'),
                      ),
                    ],
                    rows: busRegistrations.map((registration) {
                      return DataRow(
                        cells: <DataCell>[
                          DataCell(Text(registration['userEmail'].toString())),
                          DataCell(Text(registration['busNumber'].toString())),
                          DataCell(Text(registration['Route'].toString())),
                        ],
                      );
                    }).toList(),
                  ),
                ));
          }
        },
      ),
    );
  }
}
