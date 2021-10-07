import 'package:flutter/material.dart';
class GroupMembersListScreenf extends StatefulWidget {
  final membersList;

  GroupMembersListScreenf(this.membersList);



  @override
  _GroupMembersListScreenfState createState() => _GroupMembersListScreenfState();
}

class _GroupMembersListScreenfState extends State<GroupMembersListScreenf> {



  @override
  Widget build(BuildContext context) {
    return ListView(
        children: <Widget>[
          //Your widgets
        ]
    );
  }
}
class GroupMembersListScreen extends StatelessWidget {
  final List membersList;

  GroupMembersListScreen(this.membersList);

  @override
  Widget build(BuildContext context) {
    final title = 'Long List';

    return MaterialApp(

      title: title,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Group Members"),
        ),
        body: ListView.builder(
          itemCount: membersList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${membersList[index].username}'),
            );
          },
        ),
      ),
    );
  }
}