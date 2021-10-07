import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:ofy_flutter/models/opportunity.dart';
import 'package:http/http.dart' as http;

import 'opportunity_details.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin{

  List<Opportunity> opportunityList = List<Opportunity>();
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  static int page = 0;
  Timer _debounce;
  static String queryStr = " ";
  bool searchDone=false;
  TextEditingController _controller = TextEditingController();


  @override
  void initState() {
    page = 0;
    //getFeaturedList();
    // this._getMoreData(page);
    super.initState();
    scrollListener();
  }

  void scrollListener(){
    _scrollController.addListener(() {
      print(_scrollController.position.pixels.toString());
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData(page);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }


  void _getMoreData(int pageNum) async {
    if (!isLoading){
      setState(() {
        isLoading = true;
      });
      var response = await http.get("http://ofy.co.in/api/v1/public/opportunities/search/?query=$queryStr&page=$pageNum");
      var responseBody = response.body;
      var parsed = jsonDecode(responseBody);
      List<Opportunity> temp = List<Opportunity>();
      for (int i=0 ; i<parsed.length ; i++){
        temp.add(Opportunity.fromJson(parsed[i]));
      }
      setState(() {
        isLoading = false;
        opportunityList.addAll(temp);
        searchDone = true;
        page++;
      });
    }
  }
  
//  void getFeaturedList() async {
//    var response = await http.get("http://ofy.co.in/api/v1/public/opportunities");
//    var parsedF = jsonDecode(response.body);
//    List<Opportunity> temp = List<Opportunity>();
//    for (int i=0 ; i<parsedF['competitions'].length ; i++){
//      temp.add(Opportunity.fromJson(parsedF['competitions'][i]));
//    }
//    setState(() {
//      initList = temp;
//    });
//    initList = temp;
//    temp.clear();
//  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var titleTextColor = Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87;
    var subTextColor = Theme.of(context).brightness == Brightness.dark ? Colors.white60 : Colors.black38;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: SafeArea(
              child: Column(
                children: [
                  Material(
                    elevation: 2.0,
                    child: Container(
                      height: 55.0,
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color:Colors.grey)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width*0.85,
                            child: TextField(
                              style: TextStyle(
                                color: Color(0xff474747)
                              ),
                              controller: _controller,
                              onChanged: (String text){
                                if (_debounce?.isActive ?? false) _debounce
                                    .cancel();
                                _debounce =
                                    Timer(const Duration(milliseconds: 1000), () {
                                      queryStr = text;
                                      page = 0;
                                      opportunityList.clear();
                                      _getMoreData(0);
                                    });
                              },
                              decoration: InputDecoration(
                                  hintText: "Search",
                                  hintStyle: TextStyle(
                                      color: (Theme.of(context).brightness == Brightness.light)? Color(0xff474747) : Colors.white
                                  ),
                                  contentPadding: const EdgeInsets.only(left: 24.0),
                                  border: InputBorder.none,
                              ),
                            ),
                          ),
                          Center(
                            child: IconButton(
                              onPressed: (){
                                setState(() {
                                  _controller.clear();
                                  queryStr = "";
                                  page = 0;
                                  searchDone=false;
                                  opportunityList.clear();
                                });
                                // _getMoreData(0);
                              },
                              icon: Icon(Icons.close,color: (Theme.of(context).brightness == Brightness.light)? Colors.black : Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    //margin: EdgeInsets.only(top: 10.0),
                    height: MediaQuery.of(context).size.height - 130.0,
                    child: searchDone && opportunityList.isEmpty ? Center(child:Text("No matches found",style: TextStyle(color:titleTextColor),)) :SingleChildScrollView(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 10.0,right: 10.0,bottom: 10.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height*0.8,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: opportunityList.length + 1,
                              itemBuilder: (context,index){
                                if (index == opportunityList.length){
                                  return _progressIndicator();
                                }
                                else {
                                  return GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => OpportunityDetails(opportunity: opportunityList[index],)
                                      ));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 5.0,top:5),
                                      child: Column(
                                        children: [
                                          SizedBox(height: 5.0,),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.0),
                                                border: Border.all(color:Colors.grey[300],width: 0.2),
                                                color: Colors.transparent
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Container(
                                                      padding: EdgeInsets.only(left: 5.0),
                                                      margin: EdgeInsets.only(top: 7.0),
                                                      child: Text(opportunityList[index].opportunityType,
                                                        style: TextStyle(color: subTextColor,fontSize: 12.0),)
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
                                                            Text(opportunityList[index].title,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: titleTextColor),),
                                                            SizedBox(height: 5.0,),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(opportunityList[index].timeLeft,style: TextStyle(color: subTextColor,fontSize: 12.0),),
                                                                Container(
                                                                    padding: EdgeInsets.only(right: 20.0),
                                                                    child: Text(opportunityList[index].region,style: TextStyle(color:subTextColor,fontSize: 12.0),))
                                                              ],
                                                            ),
                                                            SizedBox(height: 5.0,),
                                                            opportunityList[index].fundingType != "None" ? Text(opportunityList[index].fundingType,style: TextStyle(color: subTextColor,fontSize: 12.0),) : Container()
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
                                  );}
                              },
                              controller: _scrollController,
                            ),
                          )
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _progressIndicator() {
    return new Container(
      height: 100.0,
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}