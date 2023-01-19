import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remainder/models/message.dart';

class Project {
  String projectName;
  List<String> contributors;
  String? id;

  Project(this.projectName, this.contributors);

  Map<String, dynamic> toMap() {
    return {'projectName': projectName, 'contributors': contributors, 'id': id};
  }

  Project.fromMap(Map<String, dynamic> projectMap)
      : projectName = projectMap["projectName"],
        contributors = projectMap["contributors"],
        id = projectMap["id"];


  Project.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : projectName = doc.data()!["projectName"],
        id = doc.id,
        contributors = doc.data()?["contributors"] == null
            ? null
            : doc.data()?["contributors"].cast<String>();

}