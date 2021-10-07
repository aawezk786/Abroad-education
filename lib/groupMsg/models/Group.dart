/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:ofy_flutter/groupMsg/models/User.dart';

class Group
{
  String id;
  String name;
  List<gUser> members;


  Group({this.id, this.name, this.members});

  factory Group.fromMap(Map<dynamic, dynamic> map)
  {
    var members = map['members'] as List;

    List memberList = members.map((user) => gUser.fromMap(user)).toList();

    return Group(
      id : map['id'],
      name: map['name'],
      members: memberList
    );
  }
}