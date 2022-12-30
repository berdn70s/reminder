import 'package:cloud_firestore/cloud_firestore.dart';

class People{
  String firstName;
  String lastName;
  bool? isDoingTask =false;

  People(this.firstName, this.lastName , this.isDoingTask);

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'whoToDo' : isDoingTask,
    };
  }

  People.fromMap(Map<String, dynamic> peopleMap)
      : firstName = peopleMap["firstName"],
        lastName = peopleMap["lastName"],
        isDoingTask = peopleMap["whoToDo"];


  People.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : firstName = doc.data()!["firstName"],
        lastName = doc.data()!["lastName"],
        isDoingTask = doc.data()!["whoToDo"];

}