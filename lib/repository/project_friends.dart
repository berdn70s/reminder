import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectFriendsRepository extends ChangeNotifier{
  final List<Friend> friends=[
    Friend("Semih", "Yagci"),
    Friend("Ahmet", "Yalin"),
    Friend("Mehmet", "Cakici")
  ];

  void addFriend(Friend friend){
    friends.add(friend);
    notifyListeners();
  }
}

final friendsProvider = ChangeNotifierProvider((ref) {
  return ProjectFriendsRepository();
});

class Friend {
  String firstName;
  String lastName;

  Friend(this.firstName, this.lastName);
}