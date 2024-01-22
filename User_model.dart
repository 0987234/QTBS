import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String fullName;
  late final String email;
  final String phoneNo;
  final String Sapid;
  final String Address;
  final String Password;
  final String ConfirmPassword;
  final String role;
  final String profileImageUrl;
  final String? license;

  UserModel(
      {required this.fullName,
      required this.email,
      required this.phoneNo,
      required this.Sapid,
      required this.Address,
      required this.Password,
      required this.ConfirmPassword,
      required this.role,
      required this.profileImageUrl,
      this.license});

  Map<String, dynamic> toJson() {
    return {
      "FullName": fullName,
      "Email": email,
      "phone": phoneNo,
      "SapId": Sapid,
      "Address": Address,
      "Password": Password,
      "ConfirmPassword": ConfirmPassword,
      "role": role,
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      email: data["Email"] ?? "",
      fullName: data["FullName"] ?? "",
      phoneNo: data["phone"] ?? "",
      Sapid: data["SapId"] ?? "",
      Address: data["Address"] ?? "",
      Password: data["Password"] ?? "",
      ConfirmPassword: data["ConfirmPassword"] ?? "",
      role: data["Role"] ?? "",
      profileImageUrl: data['profileImageUrl'] ?? '',
    );
  }
}
