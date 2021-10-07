import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ofy_flutter/models/opportunity.dart';
import 'package:ofy_flutter/screens/opportunity_details.dart';

ListView OpportunityCardList(BuildContext context, List<Opportunity> opportunityList ,int length){
  return ListView.builder(
    scrollDirection: Axis.vertical,
    physics: AlwaysScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: length,
    itemBuilder: (context,index){
      return GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => OpportunityDetails(opportunity: opportunityList[index],)
          ));
        },
        child: Container(
          padding: EdgeInsets.only(bottom: 5.0),
          child: Column(
            children: [
              SizedBox(height: 5.0,),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: 5.0),
                        margin: EdgeInsets.only(top: 7.0),
                        child: Text("#"+opportunityList[index].opportunityType,style: TextStyle(color: Color(0xff3f3f3f),fontSize: 12.0),)
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 5.0),
                            width: MediaQuery.of(context).size.width-100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(opportunityList[index].title,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: Color(0xff3f3f3f)),),
                                SizedBox(height: 5.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(opportunityList[index].timeLeft,style: TextStyle(color: Colors.black38,fontSize: 12.0),),
                                    Container(
                                        padding: EdgeInsets.only(right: 20.0),
                                        child: Text(opportunityList[index].region,style: TextStyle(color: Colors.black38,fontSize: 12.0),))
                                  ],
                                ),
                                SizedBox(height: 5.0,),
                                opportunityList[index].fundingType != "None" ? Text(opportunityList[index].fundingType,style: TextStyle(color: Colors.black38,fontSize: 12.0),) : Container()
                              ],
                            )
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10.0),
                          height: 80.0,
                          width: 70.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          child: Image(
                            fit: BoxFit.fill,
                            image: NetworkImage(opportunityList[index].image),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 7.0,)
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
