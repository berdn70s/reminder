import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String content;
  String senderName;
  String senderID;
  int time;

  Message(this.content, this.senderName, this.senderID,this.time);

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'senderName': senderName,
      'senderID': senderID,
      'time':time
    };
  }

  Message.fromMap(Map<String, dynamic> messageMap)
      : content = messageMap["content"],
        senderName = messageMap["senderName"],
        senderID = messageMap["senderID"],
        time=messageMap["time"];

  Message.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : content = doc.data()!["content"],
        senderName = doc.data()!["senderName"],
        senderID = doc.data()!["senderID"],
        time=doc.data()!["time"];
}
