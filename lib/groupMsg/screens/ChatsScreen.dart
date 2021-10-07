/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:flutter/material.dart';
import 'package:ofy_flutter/groupMsg/models/Message.dart';
import 'package:ofy_flutter/groupMsg/screens/AllContactsScreen.dart';
import 'package:ofy_flutter/groupMsg/screens/ChatListScreen.dart';
import 'package:ofy_flutter/groupMsg/models/User.dart';
import 'package:provider/provider.dart';
import 'package:ofy_flutter/groupMsg/services/DatabaseService.dart';

class ChatsScreen extends StatefulWidget
{
  @override
  _ChatsScreenState createState() => _ChatsScreenState();

  final gUser currentUser;
  ChatsScreen({this.currentUser});
}
class _ChatsScreenState extends State<ChatsScreen> with SingleTickerProviderStateMixin
{
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(

      body: MultiProvider(
          providers: [
            StreamProvider<List<Message>>(create: (_) => DatabaseService().messages,),
            StreamProvider<List<gUser>>(create: (_) => DatabaseService().users,),

          ],
          child: ChatListScreen(
            user: widget.currentUser,
          )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.message),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AllContactsScreen(toAddGroup: false)));
        },
      )
    );
  }
}
