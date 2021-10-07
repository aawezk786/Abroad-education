import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:ofy_flutter/MyEnums/MyResponseType.dart';
import 'package:ofy_flutter/models/notification.dart';
import 'package:ofy_flutter/services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ofy_flutter/models/opportunity.dart';
import 'package:ofy_flutter/screens/opportunity_details.dart';
class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with AutomaticKeepAliveClientMixin{

  bool isLoading ;
  bool noNotification ;
  final String apiUrl = "http://ofy.co.in/api/v1/public/notifications";
  List<Notifications> notificationList = [];
  List<Opportunity> allOpportunities = [];


  List<Opportunity> parseLists(String responseBody, String tag) {
    final parsed = jsonDecode(responseBody);
    List<Opportunity> temp = new List<Opportunity>();
    for (int i = 0; i < parsed[tag].length; i++) {
      temp.add(Opportunity.fromJson(parsed[tag][i]));
    }
    setState(() {});
    return temp;
  }


  getData(http.Client client,String type,String id) async {
    Opportunity opportunity;
    final response =
    await client.get('http://ofy.co.in/api/v1/public/opportunities');
    allOpportunities = parseLists(response.body, type);
    for(var opp in allOpportunities ) {
      if(opp.id==int.parse(id)){
        opportunity = opp;

      }

    }
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => OpportunityDetails(opportunity: opportunity,)
    ));



  }


  void getNotificationData(http.Client client) async {
    if (!isLoading){
      setState(() {
        isLoading = true;
      });
      Map<String,dynamic> responseMap= await OfyApi.instance.getNotifications();
      notificationList.clear();
      if(responseMap[OfyApi.RESPONSE_TYPE]==MyResponseType.SUCCESS){
        final parsed = responseMap[OfyApi.RESPONSE_BODY];
        for (int i=0 ; i<parsed.length ; i++){
          notificationList.add(Notifications.fromJson(parsed[i]));
        }
        setState(() {
          noNotification=false;
        });

      }else{
        setState(() {
          noNotification=true;
        });
      }



    }
  }

  @override
  void initState() {
    super.initState();
    isLoading=false;
    noNotification=false;
    getNotificationData(http.Client());
  }

  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Container(
            child:
            //isLoading ? Center(child: CircularProgressIndicator()) :
            Container(
              child: noNotification ? Center(child: Text("No Notifications")) : notificationList.length == 0 ? Center(child: CircularProgressIndicator()) : ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: notificationList.length,
                itemBuilder: (context,index){
                  return InkWell(
                    child: Card(
                      color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                      elevation: 2.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage("assets/images/notification.jpg"),
                              radius: 20.0,
                            ),
                            SizedBox(width: 10.0,),
                            Container(
                              width: MediaQuery.of(context).size.width-124,
                              child: Column(
                                children: [
                                  Container(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                        child: Text(notificationList[index].title,style: TextStyle(
                                          color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white60,
                                          fontSize: 16.0
                                        ),)),
                                  ),
//                                Container(
//                                  child: Text(notificationList[index].body),
//                                )
                                ],
                              ),
                            ),
                            Container(
                                width: 30.0,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_forward_ios,color: Colors.grey,size: 15.0,),
                                    onPressed: (){},
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    onTap: (){
                      String tmp = notificationList[index].url;
                      List tmplist = tmp.split(':');
                      String type = tmplist[0];
                      String id = tmplist[1];
                      getData(http.Client(), type,id);
                      launchUrl(notificationList[index].url);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
