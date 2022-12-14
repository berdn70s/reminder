import 'package:flutter/cupertino.dart';
import 'package:remainder/repository/project_friends.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksRepository extends ChangeNotifier{
  final List<Task> task=[
    Task("Functional Req1", Friend ("Ahmet", "Yalın"), DateTime.now()),
    Task("Functional Req2", Friend("Mehmet", "Çakıcı"), DateTime.now().subtract(Duration(days: 1))),
  ];
}

final taskProvider = ChangeNotifierProvider((ref){
  return TasksRepository();
});


class Task{
  String content;
  Friend creator;
  DateTime createdTime;

  Task(this.content, this.creator, this.createdTime);
}

