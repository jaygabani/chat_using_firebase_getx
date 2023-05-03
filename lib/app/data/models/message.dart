import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message({
    this.fromID,
    this.toID,
    this.fromName,
    this.toName,
    this.fromProfilePhoto,
    this.toProfilePhoto,
    this.msg,
    this.sendTime,
  });

  String? fromID;
  String? toID;
  String? fromName;
  String? toName;
  String? fromProfilePhoto;
  String? toProfilePhoto;
  String? msg;
  int? sendTime;

  factory Message.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final response = snapshot.data();

    return Message(
      fromID: response?['fromID'] ?? '',
      toID: response?['toID'] ?? '',
      fromName: response?['fromName'] ?? '',
      toName: response?['toName'] ?? '',
      fromProfilePhoto: response?['fromProfilePhoto'] ?? '',
      toProfilePhoto: response?['toProfilePhoto'] ?? '',
      msg: response?['msg'] ?? '',
      sendTime: response?['sendTime'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "fromID": fromID,
      "toID": toID,
      "fromName": fromName,
      "toName": toName,
      "fromProfilePhoto": fromProfilePhoto,
      "toProfilePhoto": toProfilePhoto,
      "msg": msg,
      "sendTime": sendTime
    };
  }
}
