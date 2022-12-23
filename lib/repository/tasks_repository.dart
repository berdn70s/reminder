import 'package:remainder/models/people.dart';
import 'package:remainder/models/task.dart';

class TasksRepository{
  final List<Task> task=[
    Task("Functional Req1","ananıs", [People("Ahmet", "Yalın")], DateTime.now(),DateTime.now().subtract(Duration(days: 1))),
  ];

}

