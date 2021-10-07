/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:ofy_flutter/groupMsg/models/User.dart';
import 'package:firebase_auth/firebase_auth.dart' as au;
import 'package:ofy_flutter/groupMsg/services/DatabaseService.dart';

class AuthService
{
  final au.FirebaseAuth auth = au.FirebaseAuth.instance;

  gUser convertFirebaseUserToUser(au.User user)
  {
    return user != null ? gUser(uid: user.uid) : null;
  }

  Stream<gUser> get user {
    return auth.authStateChanges().map(convertFirebaseUserToUser);
  }


  Future signIn(String email, String password) async
  {
    try
    {
      au.UserCredential result =  await auth.signInWithEmailAndPassword(email: email, password: password);

      au.User user = result.user;

      return convertFirebaseUserToUser(user);

    }
    catch(e){}
  }

  Future registerEmailPassword(String username, String fullname, String email, String password) async{
    try{
      au.UserCredential result =  await auth.createUserWithEmailAndPassword(email: email, password: password);
      print(result.user);
      au.User user = result.user;

      await DatabaseService().addUserToDatabase(user.uid, username, fullname, email, "",
                                                            "Hi i am a tribly user",
                                                            "", DateTime.now().toString(), "");

      return convertFirebaseUserToUser(user);

    }
    catch(e){}
  }


  Future signOut() async{
    try{
      return await auth.signOut();

    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

}