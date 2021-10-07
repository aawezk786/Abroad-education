/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:flutter/material.dart';
import 'package:ofy_flutter/groupMsg/helpers/CurrentUser.dart';
import 'package:ofy_flutter/groupMsg/screens/BaseScreen.dart';
import 'package:ofy_flutter/groupMsg/screens/AuthenticationScreen.dart';

import 'package:provider/provider.dart';
import 'package:ofy_flutter/groupMsg/models/User.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  {
    final user = Provider.of<gUser>(context);
    final userList = Provider.of<List<gUser>>(context);

    if(user == null)
    {
      return AuthenticationScreen();
    }
    else
    {
      gUser currentUser;
      for(int i =0; i < userList.length; i++)
        {
          if(user.uid == userList[i].uid)
            {
              currentUser = gUser(
                  uid: userList[i].uid,
                  username: userList[i].username,
                  fullName: userList[i].fullName,
                  email: userList[i].email,
                  bio: userList[i].bio,
                  photoURL: userList[i].photoURL,
                  settings: userList[i].settings,
                  location: userList[i].location,
              );

            }
        }
      CurrentUser.user = currentUser;
      return BaseScreen(user: currentUser,);
    }
  }
}
