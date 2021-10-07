/*
Written by Olusola Olaoye
Copyright © 2020

 */

import 'package:ofy_flutter/groupMsg/models/Group.dart';
import 'package:ofy_flutter/groupMsg/models/Message.dart';
import 'package:ofy_flutter/groupMsg/models/User.dart';

class DataHelper
{
  bool doesMessageSenderAndReceiverExist(Message message, List<Message> list, List<gUser> users)
  {
    for(int i = 0; i < list.length; i++)
    {
      if(((message.senderID == getIDFromUsername(list[i].receiverID, users))
        &&
        (message.receiverID == getUserNameFromID(list[i].senderID, users)))
          ||
        (message.senderID == list[i].senderID
        &&
        message.receiverID == list[i].receiverID)
        )
      {
        return true;
      }
    }
    return false;
  }

  String getUserNameFromID(String id, List<gUser> users)
  {
    for(int i=0; i < users.length; i++)
    {
      if(users[i].uid == id)
      {
        return users[i].username;
      }
    }
    return "";
  }


  String getIDFromUsername(String username, List<gUser> users)
  {
    String id = "";
    for(int i=0; i < users.length; i++)
    {
      if(users[i].username == username)
      {
        id = users[i].uid;
      }
    }

    return id;
  }

  gUser getUserFromUsername(String username, List<gUser> users)
  {
    gUser user;

    for(int i=0; i < users.length; i++)
    {
      if(users[i].username == username)
      {
        user = users[i];
      }
    }

    return user;
  }

  gUser getUserFromID(String id, List<gUser> users)
  {

    for(int i=0; i < users.length; i++)
    {
      if(users[i].uid == id)
      {
        return users[i];
      }
    }
    return null;
  }

 String getAvatarOfUserFromUsername(String username, List<gUser> users)
 {

   for(int i=0; i < users.length; i++)
   {
     if(users[i].username == username)
     {
       return users[i].photoURL;
     }
   }
   return null;
 }

 String getAvatarOfUserFromID(String id, List<gUser> users)
 {
   for(int i=0; i < users.length; i++)
   {
     if(users[i].uid == id)
     {
       return users[i].photoURL;
     }
   }
   return null;
 }



  Group getGroupViaID(String id, List<Group> groups)
  {
    Group group;

    for(int i =0; i < groups.length; i++)
    {
      if(groups[i].id == id)
      {
        group = groups[i];
      }
    }

    return group;
  }

  bool doesUserBelongToGroup(gUser user, Group group)
  {
    bool belongs = false;

    for(int i = 0; i < group.members.length; i++)
    {
      if(user.uid == group.members[i].uid)
        {
          belongs = true;
        }
    }

    return belongs;
  }

  int getNumberOfUnreadMessages(List<Message> messages)
  {
    int unread = 0;

    messages.forEach((element) {
      if(element.read == false)
        {
          unread += 1;
        }
    });

    return unread;
  }

  int getNumberOfReadMessages(List<Message> messages)
  {
    int read = 0;

    messages.forEach((element) {
      if(element.read == true)
        {
          read += 1;
        }
    });

    return read;
  }

  void readAllMessages(List<Message> messages)
  {
    messages.forEach((element) {
      element.read = true;
    });
  }

}