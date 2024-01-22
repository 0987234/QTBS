import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// class VoucherDisplayScreen extends StatefulWidget {
//   final String voucherDocumentID;
//   final String voucherURL;
//
//   const VoucherDisplayScreen({
//     required this.voucherDocumentID,
//     required this.voucherURL,
//   });
//
//   @override
//   State<VoucherDisplayScreen> createState() => _VoucherDisplayScreenState();
// }
//
// class _VoucherDisplayScreenState extends State<VoucherDisplayScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Voucher Display'),
//       ),
//       body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Text('Voucher Document ID: ${widget.voucherDocumentID}'),
//             SizedBox(height: 20),
//             Image.network(
//               widget.voucherURL,
//               width: 360,
//               height: 340,
//               fit: BoxFit.cover,
//             ),
//             SizedBox(height: 20),
//             Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//               // ... (unchanged code)
//
//               ElevatedButton(
//                 onPressed: () {
//                   // Implement your accept logic here
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//                         title: Text('Accept Voucher'),
//                         content: Text('Do you want to accept this voucher?'),
//                         actions: [
//                           TextButton(
//                             onPressed: () async {
//                               // Implement your accept logic here
//                               await acceptVoucher();
//                               Navigator.pop(context);
//                             },
//                             child: Text('Accept'),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: Text('Cancel'),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//                 child: Text('Accept'),
//               ),
//
//               SizedBox(
//                 width: 20,
//               ),
//
//               ElevatedButton(
//                 onPressed: () {
//                   // Implement your reject logic here
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//                         title: Text('Reject Voucher'),
//                         content: Text('Do you want to reject this voucher?'),
//                         actions: [
//                           TextButton(
//                             onPressed: () async {
//                               // Implement your reject logic here
//                               await rejectVoucher();
//                               Navigator.pop(context);
//                             },
//                             child: Text('Reject'),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: Text('Cancel'),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//                 child: Text('Reject'),
//               ),
//             ])
//           ]),
//     );
//   }
//
//   Future<void> acceptVoucher() async {
//     // Get current user
//     User? user = _auth.currentUser;
//
//     // Update the voucher status in Firebase
//     await _firestore.collection('Vouchers').doc(widget.voucherDocumentID).set({
//       'status': 'accepted',
//       'user': user?.uid,
//     }, SetOptions(merge: true));
//   }
//
//   Future<void> rejectVoucher() async {
//     // Get current user
//     User? user = _auth.currentUser;
//
//     // Update the voucher status in Firebase
//     await _firestore.collection('Vouchers').doc(widget.voucherDocumentID).set({
//       'status': 'rejected',
//       'user': user?.uid,
//     }, SetOptions(merge: true));
//   }
// }

class VoucherDisplayScreen extends StatefulWidget {
  final String voucherDocumentID;
  final String voucherURL;

  const VoucherDisplayScreen({
    required this.voucherDocumentID,
    required this.voucherURL,
  });

  @override
  State<VoucherDisplayScreen> createState() => _VoucherDisplayScreenState();
}

class _VoucherDisplayScreenState extends State<VoucherDisplayScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Voucher Display'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text('Voucher Document ID: ${widget.voucherDocumentID}'),
            SizedBox(height: 20),
            Image.network(
              widget.voucherURL,
              width: 360,
              height: 340,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              // ... (unchanged code)

              ElevatedButton(
                onPressed: () {
                  // Implement your accept logic here
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Accept Voucher'),
                        content: Text('Do you want to accept this voucher?'),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              // Implement your accept logic here
                              await acceptVoucher();
                              Navigator.pop(context);
                              showSuccessSnackBar(
                                  context, 'Voucher accepted successfully');
                            },
                            child: Text('Accept'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Accept'),
              ),

              SizedBox(
                width: 20,
              ),

              ElevatedButton(
                onPressed: () {
                  // Implement your reject logic here
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Reject Voucher'),
                        content: Text('Do you want to reject this voucher?'),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              // Implement your reject logic here
                              await rejectVoucher();
                              Navigator.pop(context);
                              showRejectSnackBar(context, 'Voucher rejected');
                            },
                            child: Text('Reject'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Reject'),
              ),
            ])
          ]),
    );
  }

  Future<void> acceptVoucher() async {
    // Get current user
    User? user = _auth.currentUser;

    // Update the voucher status in Firebase
    await _firestore.collection('Vouchers').doc(widget.voucherDocumentID).set({
      'status': 'accepted',
      'user': user?.uid,
    }, SetOptions(merge: true));
  }

  Future<void> rejectVoucher() async {
    // Get current user
    User? user = _auth.currentUser;

    // Update the voucher status in Firebase
    await _firestore.collection('Vouchers').doc(widget.voucherDocumentID).set({
      'status': 'rejected',
      'user': user?.uid,
    }, SetOptions(merge: true));
  }

  void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void showRejectSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      ),
    );
  }
}
