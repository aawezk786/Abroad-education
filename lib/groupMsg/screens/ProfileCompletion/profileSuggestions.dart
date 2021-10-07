/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ofy_flutter/groupMsg/helpers/CurrentUser.dart';
import 'package:ofy_flutter/groupMsg/models/User.dart';
import 'package:ofy_flutter/groupMsg/screens/ProfileCompletion/profileSuggestionList.dart';
import 'package:ofy_flutter/groupMsg/services/DatabaseService.dart';
import 'package:provider/provider.dart';
import 'package:ofy_flutter/groupMsg/models/Group.dart';
import 'package:ofy_flutter/groupMsg/screens/ProfileCompletion/groupSuggestions.dart';

class ProfileSuggestions extends StatefulWidget
{
  final bool toAddGroup;

  ProfileSuggestions({this.toAddGroup});

  @override
  _ProfileSuggestionsState createState() => _ProfileSuggestionsState();
}

class _ProfileSuggestionsState extends State<ProfileSuggestions>
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
          title: Text('People you should connect with', style: TextStyle(color: Colors.blue, fontSize: 16),) ,
          iconTheme: IconThemeData(color: Colors.blue),
        ),
        body : Column(
          children: [
            Container(
              height: 323,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [

                  Card(
                    child: Column(
                      children: [
                        Text("Suggested People",style: TextStyle(
                          fontSize: 20
                        ),),
                        ContactListScreen(

                          toAddGroup: widget.toAddGroup,
                        ),
                      ],
                    ),
                  ),

                  Card(
                    child: MultiProvider(
                        providers: [
                          StreamProvider<List<Group>>(create: (_) => DatabaseService().groups),
                        ],
                        child: Column(
                          children: [
                            Text("Suggested Groups",style: TextStyle(
                                fontSize: 20
                            ),),
                            AllGroupListScreen(
                              currentUser: CurrentUser.user,
                            ),
                          ],
                        )
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Post Suggestions",style:TextStyle(
                    fontSize: 20,color: Colors.blue
                  ),),
                ),
              ],
            ),
            Container(

              height: 350,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: <Widget>[


                  suggestionTile(),

                  suggestionTile(),


                  suggestionTile(),


                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class suggestionTile extends StatelessWidget {
  const suggestionTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          children: <Widget>[
            Stack(
              children: [

                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0)),
                  child: Image(
                    fit: BoxFit.cover,
                    height: 150,
                    width: 250,
                    image: NetworkImage("https://ofy-images.s3.ap-south-1.amazonaws.com/YYqiViHiCtJfHMHSBnymgdnYHyiqPhEa.jpg"),
                  ),
                ),
                /*
                Gradient container
                Container(
    height: 150,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.black54,
        ],
      ),
    ),
                ),

                 */
                Container(
                  height: 150,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15.0,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          height: 23.0,
                          width: 90.0,
                          decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5.0),
                                  bottomLeft: Radius.circular(5.0))),
                          child: Center(
                            child: Padding(
                              padding:
                              const EdgeInsets.only(top: 3.0, bottom: 3.0),
                              child: Text(
                                "23 days",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 90.0),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(2),
                                color: Colors.black12,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.monetization_on,
                                      size: 12.0,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Grants",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12.0,fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(2),
                                color: Colors.black12,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 12.0,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "India",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12.0,fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(

              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, left: 12.0, right: 12.0, bottom: 6.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Motorola Solutions Foundation 2021",
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).brightness ==
                                  Brightness.light
                                  ? Colors.black87
                                  : Colors.white70),
                        ),
                      ),
                      SizedBox(
                        height: 7.0,
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width:180,
                            child: OutlinedButton(
                              onPressed: (){

                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.star_rate_rounded,color: Colors.yellow,),
                                  Text("Interested")
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 180,
                            child: OutlinedButton(
                              onPressed: (){

                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.remove_red_eye,color: Colors.grey,),

                                  Text("View")
                                ],
                              ),
                            ),
                          ),

                        ],
                      )

                    ],
                  )),
            )
          ],
        ),
      ),

    );
  }
}
