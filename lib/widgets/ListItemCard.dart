import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ofy_flutter/models/opportunity.dart';
import 'package:ofy_flutter/screens/opportunity_details.dart';
import 'package:ofy_flutter/utilities/theme.dart';
import 'package:provider/provider.dart';
class ListItemCard extends StatelessWidget {
  Opportunity opportunity;
  ListItemCard(this.opportunity);
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    var bgColor = themeChange.darkTheme ? Colors.black : Colors.white;
    var titleTextColor = themeChange.darkTheme ? Colors.white : Colors.black;
    var bodyTextColor = themeChange.darkTheme ? Colors.white: Color.fromRGBO(56,56,56,10.0);
    double iconSize =15;
    double iconFontSize = 12;
    var icon_text_color = themeChange.darkTheme ? Colors.white70 : Color.fromRGBO(128, 128, 128, 0.8);
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => OpportunityDetails(opportunity: opportunity,)
        ));
      },
      child: Container(
        color: bgColor,
        padding: EdgeInsets.only(bottom: 5.0,right: 3.0,left: 3.0),
        child: Column(
          children: [
            SizedBox(height: 5.0,width: 2.0,),
            Container(
              padding: const EdgeInsets.only(top:10,bottom: 10,right: 2),
              // color: Colors.red,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border : Border.all(color : Colors.grey.withOpacity(0.5),
                  width: 0,
                ),
                color:bgColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 0.5,
                    blurRadius: 3.5,
                    offset: Offset(0, 0), //(x,y)
                  ),
                ],

              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left:9.0),
                      child: Text(opportunity.timeLeft,style: TextStyle(color: bodyTextColor,
                          fontSize: iconFontSize),textAlign: TextAlign.left,),
                    ),
                    SizedBox(height:3),
                    Container(
                        padding: const EdgeInsets.only(left: 9.0),
                        width: MediaQuery.of(context).size.width*0.75 ,
                        child: Column(
                          crossAxisAlignment:  CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(utf8.decode(opportunity.title.runes.toList()),maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(
                                color: titleTextColor ,fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold),
                            ),
                            opportunity.fundingType != "None" ? SizedBox(height: 5.0,) : SizedBox(height: 10.0,),
                            Container(
                              child: Row(
                                children: [
                                  Icon(Icons.location_on,size: iconSize,color: icon_text_color,),
                                  Text(opportunity.region,style: TextStyle(color: icon_text_color,fontSize: iconFontSize),)
                                ],
                              ),
                            ),
                            SizedBox(height: 5,),
                            if(opportunity.fundingType != "None") Container(
                              child: Row(
                                children: [
                                  Icon(Icons.monetization_on,size: iconSize,color: icon_text_color,),
                                  Text(opportunity.fundingType,style: TextStyle(color: icon_text_color,fontSize: iconFontSize),)
                                ],
                              ),
                            ),
                          ],
                        )
                    ),

                    SizedBox(height: 7.0,)
                  ],
                ),  Container(
                      margin: const EdgeInsets.only( right: 2),
                      padding: const EdgeInsets.all(1.0),
                      height: 70.0,
                      width: 70.0,
                      child: Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(opportunity.image),
                      ),
                    ),
              ],
              ),
            ),
            SizedBox(height: 5.0,),
          ],

        ),
      ),
    );
  }
}
