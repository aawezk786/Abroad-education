

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ofy_flutter/MyEnums/MyResponseType.dart';
import 'package:ofy_flutter/models/opportunity.dart';
import 'package:ofy_flutter/utilities/LoginProvider.dart';
import 'package:ofy_flutter/widgets/ListItemCard.dart';
import 'package:ofy_flutter/widgets/ListItemSkeletonLoader.dart';
import 'package:provider/provider.dart';
import '../services/services.dart';

class BookmarkListScreen extends StatefulWidget {
  @override
  _BookmarkListScreenState createState() => _BookmarkListScreenState();
}

class _BookmarkListScreenState extends State<BookmarkListScreen>  {


  static int page = 0;
  List<Opportunity> bookmarkedList = [];
  bool _isLoading;
  ScrollController _scrollController = ScrollController();
  String _authToken ;
  bool _isInitialDataLoaded;
  MyResponseType responseType = MyResponseType.EMPTY;

  @override
  void initState() {
    page = 0;
    _isLoading=true;
    _isInitialDataLoaded=false;
    super.initState();
    scrollListener();
  }

  @override
  void didChangeDependencies() {
    if(!_isInitialDataLoaded){
       print("TESTING BookmarkListScreen initial data loaded");
      _authToken =  Provider.of<LoginProvider>(context).authToken;
      getData(page);
      _isInitialDataLoaded = true;
    }
    super.didChangeDependencies();
  }

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

  void getData(int pageNum) async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }
      print("TESTING Bookmark getData()");
      Map<String,dynamic> responseMap =await OfyApi.instance.getBookmarkList(page:pageNum, key: _authToken);
      print("TESTING Bookmark getData() ${responseMap}");
      MyResponseType currentResponseType = responseMap[OfyApi.RESPONSE_TYPE];
      switch(currentResponseType){
        case MyResponseType.EMPTY:
          case MyResponseType.FAILED:
          setState(() {
            _isLoading=false;
            responseType = currentResponseType;
          });
          break;
        case MyResponseType.SUCCESS:
            List<Opportunity> temp = responseMap[OfyApi.RESPONSE_BODY] as List<Opportunity>;
            setState(() {
              _isLoading = false;
              responseType = currentResponseType;
              bookmarkedList.addAll(temp);
              page++;
            });
            break;
      }

    }

  @override
  Widget build(BuildContext context) {
    var bgColor = Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white;
    var textColor1 = Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87;
    var textColor2 = Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54;
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookmarked Items"),
      ),
      body: SafeArea(
        child: (responseType != MyResponseType.SUCCESS)&&(! _isLoading) ? Align(
          alignment: Alignment.center,
          child: Text("No Bookmarks"),
        ) : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: (!_isInitialDataLoaded) ? 5 : bookmarkedList.length+1,
              itemBuilder: (context,index){
                if (index == bookmarkedList.length && _isInitialDataLoaded){
                  return new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Center(
                      child: new Opacity(
                        opacity: _isLoading ? 1.0 : 0.0,
                        child: new CircularProgressIndicator(),
                      ),
                    ),
                  );
                }
                else{
                  return (! _isInitialDataLoaded) ? ListItemSkeletonLoader(): ListItemCard(bookmarkedList[index]);
                }
              },
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
          opacity: _isLoading ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}
