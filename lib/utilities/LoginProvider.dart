

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;


class LoginProvider with ChangeNotifier{
  User _currentUser;
  String _authToken;
  GoogleSignIn _googleSignIn ;

  LoginProvider(){
    print("LoginProvider constructor()");
    _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/calendar.events',
      ],
    );

    signInSilently();
  }



  void signInSilently() async{
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signInSilently();
    if(googleSignInAccount!=null){
      _signIn(googleSignInAccount);
    }
  }

  void signIn()  async{
    GoogleSignInAccount googleSignInAccount =await _googleSignIn.signIn();
    if(googleSignInAccount!=null)
         _signIn(googleSignInAccount);
  }

  String get authToken{
    return _authToken;
  }

  void _signIn(GoogleSignInAccount googleSignInAccount) async{
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    _setAuthToken(googleSignInAuthentication.idToken);

    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken
    );
    UserCredential authResult = await (FirebaseAuth.instance.signInWithCredential(credential));
    _currentUser = authResult.user;
    assert(!_currentUser.isAnonymous);
    assert(await _currentUser.getIdToken() != null);
    User currentUser =  FirebaseAuth.instance.currentUser;
    assert(_currentUser.uid == currentUser.uid);

    notifyListeners();
  }
  void signOut() async{
    await _googleSignIn.signOut();
    print("Signed Out");
    _currentUser=null;
    _authToken = null;
    notifyListeners();
  }

  void _setAuthToken(String idToken){
    http
        .post("http://ofy.co.in/api/v1/public/accept_oauth_token",
        headers: {'Accept': 'application/json'},
        body: {"token": idToken})
        .then((response)  {
        _authToken = jsonDecode(response.body)["token"];
    }).catchError((err) => {
      print("TESTING: signIn() error="+err)
    });
  }

  String get username => _currentUser?.displayName;

  String get email => _currentUser?.email;

  String get imageUrl => _currentUser?.photoURL;

  Future<bool> get isSignedIn  =>  _googleSignIn.isSignedIn() ?? false;
}