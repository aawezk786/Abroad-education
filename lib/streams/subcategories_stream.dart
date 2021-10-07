import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ofy_flutter/articles_dir/articles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var arr = [];
var arr1 = [];
var subcategories = [];
var articlesToShow = [];
var emoticons = ['(°o°)', '^_^', '(^o^)丿', '(·ω·)', '^ω^', '(@_@)'];

class SubCategoryStreamPage extends StatefulWidget {
  SubCategoryStreamPage({@required this.category});

  final category;

  @override
  _SubCategoryStreamPageState createState() => _SubCategoryStreamPageState();
}

class _SubCategoryStreamPageState extends State<SubCategoryStreamPage> {
  Future getData() async {
    final response =
    await http.get('http://offy.xyz/wp-json/wp/v2/posts');
    return jsonDecode(response.body);
  }

  List articles = [];

  var valuefirst = [];

  @override
  void initState() {
    subcategories.clear();
    arr.clear();
    arr1.clear();
    articlesToShow.clear();
    valuefirst.clear();
    for (var i in widget.category) {
      arr.add(i["sub_category"].toString());
    }
    subcategories = arr.toSet().toList();
    for (int i = 0; i < subcategories.length; i++) {
      valuefirst.add(false);
    }
    super.initState();
  }

  fetch() async {
    await getData().then(
          (value) {
        setState(
              () {
            articles = value;
            subcategories.clear();
            arr.clear();
            articlesToShow.clear();
            valuefirst.clear();
            if (articles.length != 0) {
              for (var y in widget.category) {
                for (var i in articles) {
                  if (i["category"] == y) {
                    arr.add(i["sub_category"]);
                  }
                }
              }
              subcategories = arr.toSet().toList();
              for (int i = 0; i < subcategories.length; i++) {
                valuefirst.add(false);
              }
            }
          },
        );
      },
    );
  }

  List<Widget> _subCategoriesChips(){
    List<Widget> temp = [];
    for (int index=0 ; index<subcategories.length ; index++){
      temp.add(GestureDetector(
          onTap: (){
            setState(() {
              if (arr1.contains(subcategories[index])) {
                arr1.remove(subcategories[index]);
                for (var k in widget.category) {
                  if (k["sub_category"] == subcategories[index]) {
                    articlesToShow.remove(k);
                  }
                }
              } else {
                arr1.add(subcategories[index]);
                for (var k in widget.category) {
                  if (k["sub_category"] == subcategories[index]) {
                    articlesToShow.add(k);
                  }
                }
              }
            });
          },
          child: Chip(
//          shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.circular(20.0),
//              side: BorderSide(
//                  color: arr1.contains(subcategories[index]) ? Colors.white : Colors.black,
//                  width: 2.0
//              )
//          ),
            padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 10.0),
            backgroundColor: arr1.contains(subcategories[index]) ? Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white : Theme.of(context).brightness == Brightness.light ? Color(0xffE8E8E8) : Colors.black,

//            avatar: arr1.contains(subcategories[index]) ? CircleAvatar(
//              backgroundColor: arr1.contains(subcategories[index]) ? Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white : Theme.of(context).brightness == Brightness.light ? Colors.grey : Colors.black54,
//              child: Icon(arr1.contains(subcategories[index]) ? Icons.check_circle : null,color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black),
//            ) : null,
            label: Text(subcategories[index],style: TextStyle(color: arr1.contains(subcategories[index]) ? Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black : Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,fontSize: 18.0)),
          )
      ));
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Select Sub Category',),
          ),
//        floatingActionButton: Builder(builder: (BuildContext context) {
//          return FloatingActionButton(
//            onPressed: () {
//              setState(() {
//                if (articlesToShow.length == 0) {
//                  Scaffold.of(context).showSnackBar(
//                    SnackBar(
//                        content: Text('Please select a valid sub category')),
//                  );
//                } else {
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => ArticlePage(
//                            articlesToShow: articlesToShow,
//                          )));
//                }
//              });
//            },
//            child: Icon(
//              Icons.navigate_next,
//            ),
//          );
//        }),
          body: Container(
            margin: EdgeInsets.only(bottom: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 200,
                  margin: EdgeInsets.only(top: 10.0),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: subcategories.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 200.0,
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        alignment: Alignment.topLeft,
                        child: Wrap(
                          spacing: 10.0,
                          children: _subCategoriesChips(),
                        ),
                      );
                    },
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border(
                              top: BorderSide(
                                width: 2,
                                color: arr1.isEmpty
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                              left: BorderSide(
                                width: 2,
                                color: arr1.isEmpty
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                              right: BorderSide(
                                width: 2,
                                color: arr1.isEmpty
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                              bottom: BorderSide(
                                width: 2,
                                color: arr1.isEmpty
                                    ? Colors.grey
                                    : Colors.black,
                              )
                          )
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      width: MediaQuery.of(context).size.width,
                      height: 40.0,
                      child: RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text("Continue",style: TextStyle(
                            color: arr1.isEmpty ? Colors.grey : Colors.black,
                            fontSize: 15.0
                        ),),
                        onPressed: () {
                          setState(() {
                            if (articlesToShow.length == 0) {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Please select a valid sub category')),
                              );
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ArticlePage(
                                        articlesToShow: articlesToShow
                                            .toSet().toList(),
                                      )));
                            }
                          });
                        },
                      ),
                    )
                )
              ],
            ),
          )
      ),
    );
  }
}