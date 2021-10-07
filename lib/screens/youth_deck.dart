import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:ofy_flutter/articles_dir/articles.dart';
import 'package:ofy_flutter/models/article_item.dart';
import 'package:ofy_flutter/services/selected_items.dart';
import 'package:ofy_flutter/streams/categories_stream.dart';
import 'package:dio/dio.dart';

List items =['Scholarship','Grants&Funding','Workshop','Internship','Fellowship'];

List<String> userCategoryPref = [];
List subCategoryList = [];

String selCategory = "";

class YouthDeckPage extends StatefulWidget {



  @override
  _YouthDeckPageState createState() => _YouthDeckPageState();
}

class _YouthDeckPageState extends State<YouthDeckPage>
//with AutomaticKeepAliveClientMixin
{
  List<ArticleItem> articlesList = [];


  List<String> userSubCategoryPref = [];
  var apiUrl = "http://35f8a30114a0.ngrok.io/api"; //temporary api link
  bool isListEmpty = false;
  bool isLoading = true;


  List<String> categoryNamesList = [];

  @override
  void initState() {
    super.initState();
    isLoading = true;
    categoryNamesList = SelectedItems.categoryList;
    isListEmpty = SelectedItems.isListEmpty;
    
    // if (!isListEmpty) {
    fetchData();
    // }
  }





  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomSheet(
          onClosing: () {},
          builder: (BuildContext context) {
            bool b = false;
            return StatefulBuilder(
              builder: (BuildContext context, setState) => Container(
                height: MediaQuery.of(context).size.height  * 0.4,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text("Choose a Category"),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 400,
                      height: 100,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 120,
                            width: 120,

                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  subCategoryList = items[index]['subcategory'];
                                  selCategory = items[index]['category'];
                                });




                              },
                              child: Card(

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.stars_sharp),
                                    Text('${items[index]['category']}',style: TextStyle(

                                        fontSize: 12
                                    ),),



                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text("Select a Subcategory"),
                    SizedBox(height: 10,),
                    Container(
                      width: 400,
                      height: 100,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: subCategoryList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 50,
                            width: 120,

                            child: GestureDetector(
                              onTap: (){

            setState(() {
              print(selCategory+":"+subCategoryList[index]);
              userCategoryPref.clear();
              userCategoryPref.add(selCategory+":"+subCategoryList[index]);
              articlesList.clear();

              fetchData();


            });


                              },
                              child: Card(

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [

                                    Text('${subCategoryList[index]}',style: TextStyle(

                                        fontSize: 12
                                    ),),



                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    

                  ],
                ),)
            );
          },
        );
      },
    );
  }













  fetchData() async {

    var dio = Dio();
    print(categoryNamesList);
    var response = await dio.get("http://192.168.1.6:9000/yts", queryParameters: {'access_token': 'pf5JOdYQHRTadH62OPhmVziGdAuTYMtL'});

   var rCats = await dio.get("http://192.168.1.6:9000/subcats", queryParameters: {'access_token': 'pf5JOdYQHRTadH62OPhmVziGdAuTYMtL'});
    items = rCats.data['rows'];


    var responseBody = response.data['rows'];

    List<ArticleItem> temp = [];
    response.data['rows'].forEach((article) => {


        temp.add(ArticleItem(
        heading: article['heading'],
        heading_link: article['heading_link'],
        heading_type: article['heading_type'],
        category: article['category'],
        image_link: article['image']))



          });



//    for (int i=0 ; i<articlesList.length ; i++){
//      print("Anant_________${articlesList[i].toString()}");
//    }
    setState(() {});
    // for (int i = 0; i < temp.length; i++) {
    //   for (int j = 0; j < categoryNamesList.length; j++) {
    //     if (true) {
    //       articlesList = articlesList.toSet().toList();
    //       articlesList.add(temp[i]);
    //     }
    //   }
    // }
    temp.forEach((e) { 
      if(userCategoryPref.contains(e.category))
        {
          articlesList.add(e);

        }

    });
    
    
    
    isListEmpty=false;
    isLoading = false;
  }


  @override
  Widget build(BuildContext context) {

    //super.build(context);
    return SafeArea(

      child: Scaffold(

        floatingActionButton: FloatingActionButton(
          onPressed: () {

            displayBottomSheet(context);
            // Add your onPressed code here!
          },
          child: const Icon(Icons.filter_list),
          backgroundColor: Colors.blue,
        ),
          appBar: AppBar(



            centerTitle: true,
            title: Text(
              'ofy',
              style: TextStyle(),
            ),

          ),
          body: isListEmpty
              ? CategoryStreamPage()
              : isLoading
                  ? SafeArea(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Container(

                    child: ArticlePage(
                        articlesToShow: articlesList,
                        fromScreen: "EP",
                      ),
                  ),

      //  Container(
      //    child: Center(
      //      child: Column(
      //        children: [
      //          RaisedButton(
      //            onPressed: () {
      //              setState(() {
      //                Navigator.push(
      //                    context,
      //                    MaterialPageRoute(
      //                        builder: (context) => CategoryStreamPage()));
      //              });
      //            },
      //            child: Text(
      //              'Articles',
      //            ),
      //          ),
      //          RaisedButton(
      //            onPressed: () {
      //              setState(() {
      //                Navigator.push(
      //                    context,
      //                    MaterialPageRoute(
      //                        builder: (context) => JobsScreen()));
      //              });
      //            },
      //            child: Text(
      //              'Jobs',
      //            ),
      //          )
      //        ],
      //      ),
      //    ),
      //  ),
          ),
    );
  }

//  @override
//  // TODO: implement wantKeepAlive
//  bool get wantKeepAlive => true;
}




