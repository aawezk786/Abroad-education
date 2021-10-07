/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:bubble/bubble.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';
import 'package:ofy_flutter/groupMsg/helpers/CurrentUser.dart';
import 'package:ofy_flutter/groupMsg/helpers/MessageReceiverType.dart';
import 'package:ofy_flutter/groupMsg/models/Group.dart';
import 'package:ofy_flutter/groupMsg/models/User.dart';
import 'package:provider/provider.dart';
import 'package:ofy_flutter/groupMsg/models/Message.dart';
import 'package:ofy_flutter/groupMsg/helpers/DataHelper.dart';


class MessageListScreen extends StatefulWidget
{
  @override
  _MessageListScreenState createState() => _MessageListScreenState();

  final String messageReceiverType;
  final String receiver;
  final gUser currentUser;

  MessageListScreen({this.messageReceiverType, this.receiver, this.currentUser});
}

class _MessageListScreenState extends State<MessageListScreen>
{
  String currentUserID = "";

  double generateWidthForBubble(String string)
  {
    int maxString = 30;

    int length = string.length > maxString? maxString : string.length;


    int minimumLength = 100;
    int maximumLength = 320;

    return ((minimumLength - maximumLength) * (length / maxString)) + maximumLength;
  }


  @override
  Widget build(BuildContext context)
  {
    final messageList = Provider.of<List<Message>>(context) ?? [];
    final userList = Provider.of<List<gUser>>(context) ?? [];
    final groupList = Provider.of<List<Group>>(context) ?? [];

    List<Message> queriedMessage = List<Message>();

    getCurrentUserID() async {
      Auth.User user = await Auth.FirebaseAuth.instance.currentUser;
      currentUserID = user.uid;
    }

    getCurrentUserID();

    if(widget.messageReceiverType == MessageReceiverType.individual)
    {
      for(int i = 0; i< messageList.length; i++)
      {
        if(
        ((messageList[i].receiverID == widget.receiver)
            &&
          (messageList[i].senderID == currentUserID))
            ||
            (
          ((messageList[i].receiverID == DataHelper().getUserNameFromID(currentUserID, userList))
            &&
          (messageList[i].senderID == DataHelper().getIDFromUsername(widget.receiver, userList)))
            )
        )
        {
          queriedMessage.add(messageList[i]);
        }
      }
    }
    else
    {
      gUser thisUser = DataHelper().getUserFromID(currentUserID, userList);
      for(int i = 0; i< messageList.length; i++)
      {
        Group chosenGroup = DataHelper().getGroupViaID(messageList[i].receiverID, groupList);

        if(chosenGroup != null && DataHelper().doesUserBelongToGroup(thisUser, chosenGroup) &&
          widget.receiver == messageList[i].receiverID)
        {

          queriedMessage.add(messageList[i]);
        }
      }
    }

    DataHelper().readAllMessages(queriedMessage);

    return ListView.builder(
      itemCount: queriedMessage.length,
      itemBuilder: (context, index) {
        return Bubble(

          color: queriedMessage[index].senderID == CurrentUser.user.uid ?
          Colors.lightGreen:
          Colors.white,

          margin: queriedMessage[index].senderID == CurrentUser.user.uid ?
                  BubbleEdges.fromLTRB(generateWidthForBubble(queriedMessage[index].message), 15, 20, 0):
                  BubbleEdges.fromLTRB(20, 15, generateWidthForBubble(queriedMessage[index].message), 0),

          alignment: queriedMessage[index].senderID == CurrentUser.user.uid ?
                      Alignment.topRight:
                      Alignment.topLeft,

          nipWidth: 8,
          nipHeight: 7,
          nip: queriedMessage[index].senderID == CurrentUser.user.uid ?
               BubbleNip.rightTop:
               BubbleNip.leftTop,


          child: Column
            (

            children: <Widget>[
              queriedMessage[index].senderID == CurrentUser.user.uid ?
              SizedBox(
                width: 0,
                height: 0,
              ):
              Align(
                alignment: Alignment.centerLeft,
                child: Text(DataHelper().getUserFromID(queriedMessage[index].senderID, userList).username,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[600],
                  ),
                ),
              ),
              queriedMessage[index].messageType == "regular"?
              Text(queriedMessage[index].message , style: TextStyle(
                  fontSize: 14
              ))
                :
              Container(
                  child: Image.network(queriedMessage[index].message)
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(queriedMessage[index].receivedAt.toString().substring(11,16), style: TextStyle(
                    fontSize: 11
                ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
