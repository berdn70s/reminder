import 'package:remainder/models/person.dart';

class ProjectFriendsRepository{
  static final List<Person> friends=[
    Person("Wajahat", "Karim", "email1","123",[]),
    Person("Gazihan", "Alankus", "email2","123",[]),
    Person("Hamza", "Cekirdek", "email3","123",[])
  ];

  void addFriend(Person friend){
    friends.add(friend);
  }
}
