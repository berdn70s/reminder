import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remainder/models/person.dart';

class Task{
  String content;
  String description;
  List<String> whoToDo;
  bool? isItDone;
  String? id;

  Task(this.content, this.description, this.whoToDo, {this.isItDone});


  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'description': description,
      'whoToDo': whoToDo,
      'id':id,
    };
  }

  Task.fromMap(Map<String, dynamic> taskMap)
      : content = taskMap["content"],
        description = taskMap["description"],
        whoToDo = taskMap["whoToDo"],
        isItDone = taskMap["isItDone"],
        id=taskMap["id"]
  ;

  Task.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : content = doc.data()!["content"],
        description = doc.data()!["description"],
        whoToDo = doc.data()?["whoToDo"] == null
            ? ""
            : doc.data()?["whoToDo"].cast<String>(),
        isItDone =doc.data()!["isItDone"],
        id=doc.id
  ;

}
