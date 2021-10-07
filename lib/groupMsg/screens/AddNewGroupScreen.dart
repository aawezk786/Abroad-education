/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ofy_flutter/groupMsg/helpers/CurrentUser.dart';
import 'package:ofy_flutter/groupMsg/models/Group.dart';
import 'package:ofy_flutter/groupMsg/models/User.dart';
import 'package:ofy_flutter/groupMsg/services/DatabaseService.dart';

class AddNewGroupScreen extends StatefulWidget
{
  final List<gUser> users;
  AddNewGroupScreen({this.users});

  @override
  _AddNewGroupScreenState createState() => _AddNewGroupScreenState();
}

class _AddNewGroupScreenState extends State<AddNewGroupScreen>
{

  String groupName = "";

  @override
  Widget build(BuildContext context)
  {
    List<gUser> membersOfGroup = widget.users;
    membersOfGroup.add(CurrentUser.user);
    return Scaffold(
      appBar: AppBar(
        title: Text("New Group"),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Container(
              child: Row(
                children: <Widget>[
                  FlatButton.icon(onPressed: (){}, icon: Icon(Icons.add_a_photo), label: Text("")),
                  Expanded(child: TextField(
                    onChanged: (val) => groupName = val,
                  ),
                  ),

                ],
              ),
            ),
          ),
          Divider(
            height: 15,
          ),
          Flexible(
            child: Container(
              height: 22,


              child: Text("${membersOfGroup.length} members"),
            ),
          ),

          Divider(
            height: 44,
          ),

          Flexible(
            flex: 6,
            child: Container(
              child: ListView.builder(
                  itemCount: widget.users.length,
                  itemBuilder: (context, index){
                    return Column(

                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(widget.users[index].photoURL),
                          ),
                          title:  Text(widget.users[index].username),
                          subtitle: Text(widget.users[index].fullName),
                        )
                      ],
                    );
                  }
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: (){
              DatabaseService()
                  .addGroup(
                    Group(
                      name: groupName,
                      members: membersOfGroup
              ));

              Navigator.pop(context);
              Navigator.pop(context);

            },
            child: Icon(Icons.done),
          )
        ],
      ),
    );
  }
}
