
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:ofy_flutter/groupMsg/helpers/CurrentUser.dart';
import 'package:ofy_flutter/groupMsg/helpers/DataHelper.dart';
import 'package:ofy_flutter/groupMsg/helpers/MessageReceiverType.dart';
import 'package:ofy_flutter/groupMsg/models/Group.dart';
import 'package:provider/provider.dart';
import 'package:ofy_flutter/groupMsg/screens/MessageScreen.dart';
import 'package:ofy_flutter/groupMsg/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AllGroupListScreen extends StatefulWidget
{
  final gUser currentUser;
  AllGroupListScreen({this.currentUser});

  @override
  _AllGroupListScreenState createState() => _AllGroupListScreenState();
}

class _AllGroupListScreenState extends State<AllGroupListScreen>
{
  String currentUserId = "";

  @override
  Widget build(BuildContext context)
  {
    getCurrentUserID() async {
      Auth.User user = await Auth.FirebaseAuth.instance.currentUser;

      currentUserId = user.uid;
    }
    getCurrentUserID();

    final groupList = Provider.of<List<Group>>(context) ?? [];

    List<Group> queriedGroup = List<Group>();

    setState(()
    {
      for(int i = 0; i< groupList.length; i++)
      {


            queriedGroup.add(groupList[i]);



      }
    });

    return queriedGroup.length > 0 ?
    ListView.builder(
      itemCount: queriedGroup.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                radius: 24,
                child: Icon(
                  Icons.group,
                  size: 26,
                ),
              ),
              title: Text(queriedGroup[index].name),
              subtitle: Text("${queriedGroup[index].id} members"),
              trailing: ElevatedButton(
                child: Text("join"),
                onPressed: (){
                  final firestoreInstance = FirebaseFirestore.instance;
                  // CurrentUser.user.uid
                  firestoreInstance.collection("Groups").doc(queriedGroup[index].id)
                      .updateData({"members": {
                      'email':CurrentUser.user.email,
                      'fullname':CurrentUser.user.fullName,
                    'id':CurrentUser.user.uid,
                    'username':CurrentUser.user.username
                      }
                  }).then((_) {
                    print("success!");
                  });

                },
              ),

              onTap: (){

                Navigator.push(context, MaterialPageRoute(builder: (context) => MessageScreen(
                  currentUser: widget.currentUser,
                  receiver: queriedGroup[index].id,
                  messageReceiverType: MessageReceiverType.group,

                  header: DataHelper().getGroupViaID(queriedGroup[index].id, groupList).name,
                  membersList: queriedGroup[index].members,
                )));
              },
            ),
            Divider( height: 19,),
          ],
        );
      },
    ):
    Center(
      child: Text("You do not belong to any group"),
    );


  }
}
