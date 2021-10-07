/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:flutter/material.dart';
import 'package:ofy_flutter/groupMsg/models/User.dart';
import 'package:ofy_flutter/groupMsg/screens/ContactListScreen.dart';
import 'package:ofy_flutter/groupMsg/services/DatabaseService.dart';
import 'package:provider/provider.dart';


class AllContactsScreen extends StatefulWidget
{
  final bool toAddGroup;

  AllContactsScreen({this.toAddGroup});

  @override
  _AllContactsScreenState createState() => _AllContactsScreenState();
}

class _AllContactsScreenState extends State<AllContactsScreen>
{
  @override
  Widget build(BuildContext context)
  {
    return StreamProvider<List<gUser>>.value(
      value: DatabaseService().users,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.9,
          backgroundColor: Colors.grey[50],
          title: Text('All Contacts', style: TextStyle(color: Colors.blue, fontSize: 16),) ,
          iconTheme: IconThemeData(color: Colors.blue),
        ),
        body : ContactListScreen(
          toAddGroup: widget.toAddGroup,
        ),
      ),
    );
  }
}