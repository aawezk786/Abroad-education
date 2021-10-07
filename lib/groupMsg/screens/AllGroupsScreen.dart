/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:flutter/material.dart';
import 'package:ofy_flutter/groupMsg/screens/groups.dart';
import 'package:provider/provider.dart';
import 'package:ofy_flutter/groupMsg/services/DatabaseService.dart';
import 'package:ofy_flutter/groupMsg/models/Group.dart';
import 'package:ofy_flutter/groupMsg/screens/AllContactsScreen.dart';
import 'package:ofy_flutter/groupMsg/models/User.dart';

class AllGroupsScreen extends StatefulWidget
{
  final gUser currentUser;
  AllGroupsScreen({this.currentUser});

  @override
  _AllGroupsScreenState createState() => _AllGroupsScreenState();
}

class _AllGroupsScreenState extends State<AllGroupsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: MultiProvider(
            providers: [
              StreamProvider<List<Group>>(create: (_) => DatabaseService().groups),
            ],
            child: AllGroupListScreen(
              currentUser: widget.currentUser,
            )
        ),

    );
  }
}
