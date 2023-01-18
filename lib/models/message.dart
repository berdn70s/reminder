import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  String content;
  String senderName;
  String senderID;

   Message(this.content, this.senderName, this.senderID);

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'senderName': senderName,
      'senderID': senderID,
    };
  }

  Message.fromMap(Map<String, dynamic> messageMap)
      : content = messageMap["content"],
        senderName = messageMap["senderName"],
        senderID = messageMap["senderID"];

  Message.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : content = doc.data()!["content"],
        senderName = doc.data()!["senderName"],
        senderID =doc.data()!["senderID"];

}