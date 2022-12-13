import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectFriendsRepository{
  final List<Friend> friends=[
    Friend("Semih", "Yağcı"),
    Friend("Ahmet", "Yalın"),
    Friend("Mehmet", "Çakıcı")
  ];
}

class Friend {
  String firstName;
  String lastName;

  Friend(this.firstName, this.lastName);
}