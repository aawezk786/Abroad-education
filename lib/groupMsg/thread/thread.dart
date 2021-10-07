import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ofy_flutter/groupMsg/helpers/CurrentUser.dart';
import 'package:ofy_flutter/groupMsg/thread/commons/const.dart';
import 'package:ofy_flutter/groupMsg/thread/userProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'commons/utils.dart';
import 'controllers/FBCloudMessaging.dart';
import 'threadMain.dart';


class ThreadScreen extends StatefulWidget {
  @override _ThreadScreenState createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen>  with TickerProviderStateMixin{

  TabController _tabController;
  MyProfileData myData;

  bool _isLoading = false;

  @override
  void initState() {
    FBCloudMessaging.instance.takeFCMTokenWhenAppLaunch();
    FBCloudMessaging.instance.initLocalNotification();
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
    _takeMyData();
    super.initState();
  }

  Future<void> _takeMyData() async{
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myThumbnail;
    String myName;
    if (prefs.get('myThumbnail') == null) {
      String tempThumbnail = CurrentUser.user.photoURL;
      prefs.setString('myThumbnail',tempThumbnail);
      myThumbnail = tempThumbnail;
    }else{
      myThumbnail = prefs.get('myThumbnail');
    }

    if (prefs.get('myName') == null) {
      String tempName = CurrentUser.user.username+'}{'+CurrentUser.user.email;
      prefs.setString('myName',tempName);
      myName = tempName;
    }else{
      myName = prefs.get('myName');
    }

    setState(() {
      myData = MyProfileData(
          myThumbnail: myThumbnail,
          myName: myName,
          myLikeList: prefs.getStringList('likeList'),
          myLikeCommnetList: prefs.getStringList('likeCommnetList'),
          myFCMToken: prefs.getString('FCMToken'),
      );
    });

    setState(() {
      _isLoading = false;
    });
  }

  void _handleTabSelection() => setState(() {});

  void onTabTapped(int index) {
    setState(() {
      _tabController.index = index;
    });
  }

  void updateMyData(MyProfileData newMyData) {
    setState(() {
      myData = newMyData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ofy Home'),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          TabBarView(
            controller: _tabController,
            children: [
              ThreadMain(myData: myData,updateMyData: updateMyData,),
              UserProfile(myData: myData,updateMyData: updateMyData,),
            ]
          ),
          Utils.loadingCircle(_isLoading),
        ],
      ),

    );
  }
}
