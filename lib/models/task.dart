import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remainder/models/people.dart';
import 'package:remainder/models/project.dart';

class Task{
  String content;
  String description;
  List<People> whoToDo;
  DateTime createdTime;
  DateTime dueTime;

  Task(this.content, this.description, this.whoToDo, this.createdTime,
      this.dueTime);

  final _db=FirebaseFirestore.instance;

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'description': description,
      'whoToDo': whoToDo,
      'createdTime': createdTime,
      'dueTime': dueTime,
    };
  }

  Task.fromMap(Map<String, dynamic> taskMap)
      : content = taskMap["content"],
        description = taskMap["description"],
        whoToDo = taskMap["whoToDo"],
        createdTime = taskMap["createdTime"],
        dueTime = taskMap["dueTime"];

  Task.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : content = doc.data()!["content"],
        description = doc.data()!["description"],
        whoToDo = doc.data()?["whoToDo"] == null
            ? null
            : doc.data()?["whoToDo"].cast<People>(),
        createdTime= doc.data()!["createdTime"],
        dueTime= doc.data()!["dueTime"];

  addTask(Task taskData) async {
    await _db.collection("projects").doc("tasks").set(taskData.toMap());
  }

  updateTask(Task taskData) async {
    await _db.collection("projects").doc("tasks").update(taskData.toMap());
  }

  Future<void> deleteTask(Task taskData) async {
    await _db.collection("projects").doc("tasks").collection(taskData.content).doc().delete();
  }

  Future<List<Task>> retrieveTasks(Project projectData) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection("projects").doc(projectData.projectName).collection("tasks").get();
    return snapshot.docs
        .map((docSnapshot) => Task.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}