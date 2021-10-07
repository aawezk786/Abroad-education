
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../MyEnums/ListItemType.dart';
import 'package:ofy_flutter/models/opportunity.dart';
import 'package:ofy_flutter/screens/opportunity_details.dart';
import 'dart:convert' show utf8;




Container OpportunityList(List<Opportunity> opportunity) {
  final int AD_SPACE = 2;

  List<ListItem> listItems = new List();
  for (var index = 0; index < opportunity.length; index++) {
    listItems.add(ListItem(ListItemType.OPPORTUNITY, opportunity[index]));
  }

  return Container(

    height: 250.0,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemExtent: 250,
      itemCount: listItems.length,
      itemBuilder: (context, index) {
        return listItems.length == 0
            ? Container(
                height: 250,
                child: Center(
                  child: Text("Nothing to show :("),
                ),
              )
            :  opportunityWidget(context, listItems[index].content);
      },
    ),
  );
}

@protected
class ListItem {
  ListItemType itemType;
  Opportunity content;

  ListItem(this.itemType, this.content);
}




Widget opportunityWidget(BuildContext context, Opportunity opportunity) {
  return InkWell(
    onTap: () {
      //createInterstitialAd()..load()..show();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  OpportunityDetails(opportunity: opportunity)));
    },
    child: Container(
      width: 250,
      height: 248,
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
                    image: NetworkImage(opportunity.image),
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
                                opportunity.timeLeft.toString(),
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
                                      opportunity.fundingType,
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
                                      opportunity.region,
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
              height: 84,
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, left: 12.0, right: 12.0, bottom: 6.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          opportunity.opportunityType,
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
                      Text(
                        utf8.decode(opportunity.title.runes.toList()),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black54
                                    : Colors.white60),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    ),
  );
}
