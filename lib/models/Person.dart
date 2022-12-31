import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Person {
  String firstName;
  String lastName;
  String email;
  String uid;
  bool? isDoingTask = false;
  final _user = FirebaseAuth.instance.currentUser;

  Person(this.firstName, this.lastName, this.email, this.uid, {this.isDoingTask});

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': _user!.email,
      'uid': _user!.uid,
      'isDoingTask': isDoingTask
    };
  }

  Person.fromMap(Map<String, dynamic> peopleMap)
      : firstName = peopleMap["firstName"],
        lastName = peopleMap["lastName"],
        email = peopleMap["email"],
        uid = peopleMap["uid"],
        isDoingTask = peopleMap["isDoingTask"];

  Person.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : firstName = doc.data()!["firstName"],
        lastName = doc.data()!["lastName"],
        email = doc.data()!["email"],
        uid = doc.data()!["uid"],
        isDoingTask = doc.data()!["isDoingTask"];
}
