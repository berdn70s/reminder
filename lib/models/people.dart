import 'package:cloud_firestore/cloud_firestore.dart';

class People{
  String firstName;
  String lastName;

  People(this.firstName, this.lastName);

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  People.fromMap(Map<String, dynamic> peopleMap)
      : firstName = peopleMap["firstName"],
        lastName = peopleMap["lastName"];

  People.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : firstName = doc.data()!["firstName"],
        lastName = doc.data()!["lastName"];
}