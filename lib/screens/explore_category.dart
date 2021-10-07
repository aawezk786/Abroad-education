import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:http/http.dart' as http;
import 'package:ofy_flutter/MyEnums/ListItemType.dart';
import 'package:ofy_flutter/models/opportunity.dart';
import 'package:ofy_flutter/widgets/ListItemCard.dart';
import 'package:ofy_flutter/widgets/ListItemSkeletonLoader.dart';
import 'package:ofy_flutter/widgets/MyNativeAd.dart';
import 'package:ofy_flutter/widgets/opportunity_list.dart';
import 'package:provider/provider.dart';
import 'package:ofy_flutter/utilities/theme.dart';

class ExploreCategory extends StatefulWidget {
  final String tag;
  ExploreCategory({@required this.tag});
  @override
  _ExploreCategoryState createState() => _ExploreCategoryState();
}



class _ExploreCategoryState extends State<ExploreCategory> {
  final AD_SPACE = 4;
  ScrollController _scrollController = ScrollController();
  int page=0;
  bool isLoading = false;
  bool _initialDataLoaded ;
  List<Opportunity> opportunityList = [];
  List<ListItem> listItems = [];
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void scrollListener(){
    _scrollController.addListener(() {
      print(_scrollController.position.pixels.toString());
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getData(page);
      }
    });
  }

  @override
  void initState() {
    page = 0;
    _initialDataLoaded = false;
    this.getData(page);
    super.initState();
    scrollListener();
  }

  void getData(int pageNum) async {
    if (!isLoading) {
      setState(() {
        if(!mounted)
          return;
        isLoading = true;
      });
      var response = await http.get("http://ofy.co.in/api/v1/public/opportunities/"+widget.tag+"?page="+pageNum.toString());
      var parsed = jsonDecode(response.body);
      var oldListLength = opportunityList.length;
      for (int i = 0; i < parsed.length; i++) {
        opportunityList.add(Opportunity.fromJson(parsed[i]));
      }
      var updatedListLength = opportunityList.length;
      setState(() {
        if(!mounted)
           return;
        if(oldListLength==0)  _initialDataLoaded=true;
        isLoading = false;
        for(int i=oldListLength;i<updatedListLength;i++){
            if(i>0 && i%AD_SPACE==0){
              listItems.add(ListItem(ListItemType.AD,null));
            }
            listItems.add(ListItem(ListItemType.OPPORTUNITY,opportunityList[i]));
        }
        page++;
      });
    }
  }
                                                       
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    var bgColor = themeChange.darkTheme ? Colors.black : Colors.white;
    return Scaffold(
      appBar: AppBar(
        title: Text("Explore"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            color: bgColor,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount:  (! _initialDataLoaded) ? 10 : listItems.length+1,
              itemBuilder: (context,index) {
                if (index == listItems.length && _initialDataLoaded) {
                  return new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Center(
                      child: new Opacity(
                        opacity: isLoading ? 1.0 : 0.0,
                        child: new CircularProgressIndicator(),
                      ),
                    ),
                  );
                }
                else {
                  return !_initialDataLoaded  ? ListItemSkeletonLoader() : listItems[index]
                      .itemType == ListItemType.AD ?
                  MyNativeAd(NativeAdmobType.banner)
                      : ListItemCard(listItems[index].content);
                }
              }
            ),
          ),
        ),
      )
    );
  }


Widget _progressIndicator() {
  return new Padding(
    padding: const EdgeInsets.all(8.0),
    child: new Center(
      child: new Opacity(
        opacity: isLoading ? 1.0 : 0.0,
        child: new CircularProgressIndicator(),
      ),
    ),
  );
}
}








