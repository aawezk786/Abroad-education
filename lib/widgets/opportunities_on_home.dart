import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ofy_flutter/models/opportunity.dart';
import 'package:ofy_flutter/screens/explore_category.dart';
import 'opportunity_list.dart';

class OpportunityOnHomePage extends StatelessWidget{
  List<Opportunity> opportunityList;
  String text;
  OpportunityOnHomePage(this.opportunityList,this.text);
  @override
  Widget build(BuildContext context) {
    var length =opportunityList.length;
    String tag;
    text == "Internships" ? tag = "INTERNSHIP" : tag = text.toUpperCase();

    return opportunityList.length == 0 ? Container() :
    Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 20.0,left: 10.0,right: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      text,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Colors.white60),
                    ),
                  )),
              GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ExploreCategory(
                                tag: tag,
                              )
                      )
                  );
                },
                child:   tag !="RECENT" ?
                Container(
                  child: Text(
                    "MORE",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Colors.white60),
                  ),
                )
                    :Opacity (opacity :0.0,child:Placeholder(fallbackHeight: 10.0,fallbackWidth: 10.0,),),
              )
            ],
          ),
          Container(height: 15.0),
          Container(
            child: OpportunityList(opportunityList),
          ),
        ],
      ),
    );
  }
}



