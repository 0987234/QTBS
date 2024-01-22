import 'package:flutter/material.dart';

// class Studentsapid extends StatefulWidget {
//   const Studentsapid({Key? key}) : super(key: key);
//
//   @override
//   State<Studentsapid> createState() => _StudentsapidState();
// }
//
// class _StudentsapidState extends State<Studentsapid> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _numberController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Select Student'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           child: Column(
//             children: [
//               // TextFormField(
//               //   controller: _nameController,
//               //   decoration: const InputDecoration(
//               //     labelText: 'Name',
//               //   ),
//               // ),
//               const SizedBox(height: 16.0),
//               TextFormField(
//                 controller: _numberController,
//                 decoration: const InputDecoration(
//                   labelText: 'Sap Id',
//                 ),
//               ),
//               const SizedBox(height: 16.0),
//               const SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: () {
//                   // Submit the form.
//                 },
//                 child: const Text('Submit'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_project/UI/module/Guardian/guardian_student_sapid/student_location_view.dart';

class Studentsapid extends StatefulWidget {
  final String selectRoute;
  final String fee;
  final String bus;
  // const Studentsapid({Key? key}) : super(key: key);
  Studentsapid(
      {required this.selectRoute, required this.fee, required this.bus});

  @override
  State<Studentsapid> createState() => _StudentsapidState();
}

class _StudentsapidState extends State<Studentsapid> {
  final TextEditingController _numberController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _checkSapIdAndNavigate() async {
    try {
      String sapId = _numberController.text.trim();
      print('Checking SAP ID: $sapId');
      // Query Firebase to check if SAP ID exists in the 'Users' collection
      QuerySnapshot users = await _firestore
          .collection('Users')
          .where('SapId', isEqualTo: sapId)
          .get();

      print('Query result: ${users.docs.map((doc) => doc.data())}');

      if (users.docs.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => studentlocationview(
              SapId: sapId,
              selectRoute: widget.selectRoute,
              fees: '',
              busnumber: widget.bus,
              voucherDocumentID: '',
              voucherURL: '',
            ),
          ),
        );
      } else {
        // SAP ID does not exist, show an error or handle accordingly
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid SAP ID. Please try again.'),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _numberController,
                decoration: const InputDecoration(
                  labelText: 'Sap Id',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _checkSapIdAndNavigate();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
