import 'package:cloud_firestore/cloud_firestore.dart';

class MessageDetails {
  MessageDetails({
    this.uID,
    this.content,
    this.type,
    this.sendTime,
  });

  String? uID;
  String? content;
  String? type;
  int? sendTime;

  factory MessageDetails.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final response = snapshot.data();

    return MessageDetails(
      uID: response?['uID'] ?? '',
      content: response?['content'] ?? '',
      type: response?['type'] ?? '',
      sendTime: response?['sendTime'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "uID": uID,
      "content": content,
      "type": type,
      "sendTime": sendTime,
    };
  }
}
