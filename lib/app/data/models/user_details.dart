import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  UserDetails({
    this.id,
    this.displayName,
    this.profilePhoto,
    this.email,
    this.timestamp,
  });

  String? id;
  String? displayName;
  String? profilePhoto;
  String? email;

  int? timestamp;

  factory UserDetails.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final response = snapshot.data();

    return UserDetails(
      id: response?['id'] ?? '',
      displayName: response?['displayName'] ?? '',
      profilePhoto: response?['profilePhoto'] ?? '',
      email: response?['email'] ?? '',
      timestamp: response?['timestamp'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "displayName": displayName,
      "profilePhoto": profilePhoto,
      "email": email,
      "timestamp": timestamp,
    };
  }
}
