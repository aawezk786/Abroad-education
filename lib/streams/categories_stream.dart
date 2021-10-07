import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ofy_flutter/articles_dir/articles.dart';
import 'package:ofy_flutter/models/article_item.dart';
import 'package:ofy_flutter/services/selected_items.dart';
import 'package:ofy_flutter/services/shared_prefs.dart';
import 'dart:convert';
import 'dart:async';
import "dart:math";
import 'package:loading_animations/loading_animations.dart';

var arr = [];
List<String> arr1 = [];
var categories = [];
List<ArticleItem> subcategories = [];

class CategoryStreamPage extends StatefulWidget {
  @override
  _CategoryStreamPageState createState() => _CategoryStreamPageState();
}

class _CategoryStreamPageState extends State<CategoryStreamPage> {
  StreamController _postsController;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  HelperMethods _helperMethods = HelperMethods();

  Future getData() async {
    final response = await http.get('http://offy.xyz/wp-json/wp/v2/posts');
    return jsonDecode(response.body);
  }

  List articles = [];
  var valuefirst = [false, false];
  bool isInitialising = true;

  List<Widget> _categoriesChips(AsyncSnapshot snapshot) {
    List<Widget> temp = [];
    for (int index = 0; index < categories.length; index++) {
      temp.add(GestureDetector(
        onTap: () {
          setState(() {
            if (arr1.contains(categories[index])) {
              arr1 = arr1.toSet().toList();
              arr1.remove(categories[index]);
              arr1 = arr1.toSet().toList();
              removeItemFromSP(categories[index]);
              for (var k in articles) {
                if (k["category"] == categories[index]) {
                  subcategories = subcategories.toSet().toList();
                  subcategories.remove(ArticleItem(
                      heading: k['heading'],
                      heading_link: k['heading_link'],
                      // heading_type: k['heading_type'],
                      category: k['category'],
                      image_link: k['image_link']));
                  subcategories = subcategories.toSet().toList();
                }
              }
            } else {
              arr1.add(categories[index]);
              arr1 = arr1.toSet().toList();
              addItemToSP(categories[index]);
              for (var k in snapshot.data) {
                if (k["cateogary"] == categories[index]) {
                  subcategories = subcategories.toSet().toList();
                  subcategories.add(ArticleItem(
                      heading: k['heading'],
                      heading_link: k['heading_link'],
                      // heading_type: k['heading_type'],
                      category: k['category'],
                      image_link: k['image_link']));
                  subcategories = subcategories.toSet().toList();
                }
              }
            }
          });
        },
        child: Chip(
//          shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.circular(20.0),
//            side: BorderSide(
//              color: arr1.contains(categories[index]) ? Colors.white : Colors.black,
//              width: 2.0
//            )
//          ),
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          backgroundColor: arr1.contains(categories[index])
              ? Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white
              : Theme.of(context).brightness == Brightness.light
                  ? Color(0xffE8E8E8)
                  : Colors.black,
//          avatar: arr1.contains(categories[index]) ? CircleAvatar(
//            backgroundColor: arr1.contains(categories[index]) ? Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white : Theme.of(context).brightness == Brightness.light ? Colors.grey : Colors.black54,
//            child: Icon(arr1.contains(categories[index]) ? Icons.check_circle : null,color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black),
//          ) : null,
          label: Text(categories[index],
              style: TextStyle(
                  color: arr1.contains(categories[index])
                      ? Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : Colors.black
                      : Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                  fontSize: 17.0)),
        ),
      ));
    }
    return temp;
  }

  @override
  void initState() {
    _postsController = new StreamController();
    loadCategories();
    arr1 = SelectedItems.categoryList;
    subcategories.clear();
    //checkForBypass();
    super.initState();
  }

  checkForBypass() {
    List<String> temp = [];
    temp = SelectedItems.categoryList;
    if (temp.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ArticlePage(articlesToShow: subcategories)));
    }
  }

  loadCategories() async {
    getData().then((res) async {
      _postsController.add(res);
      return res;
    });
  }

  addItemToSP(String item) async {
    await _helperMethods.addItemToCategoryListSP(item);
  }

  removeItemFromSP(String item) async {
    await _helperMethods.removeItemFromCategoryListSP(item);
  }

  getRespectiveArticles(AsyncSnapshot snapshot) {
    var temp = snapshot.data;
    for (var k in snapshot.data) {
      for (int i = 0; i < arr1.length; i++) {
        if (arr1[i] == k["category"]) {
          subcategories.add(k);
          subcategories = subcategories.toSet().toList();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder(
              stream: _postsController.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error);
                }
                if (snapshot.hasData) {
                  articles = snapshot.data;
                  //getRespectiveArticles(snapshot);
                  //checkForBypass();
                  categories.clear();
                  arr.clear();
                  if (articles.length != 0) {
                    for (final value in articles) {
                      arr.add(value["category"]);
                    }
                    categories = arr.toSet().toList();
                    arr.clear();
                  }
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    alignment: Alignment.topLeft,
                    height: 140,
                    child: Wrap(
                      spacing: 10.0,
                      children: _categoriesChips(snapshot),
                    ),
                  );
                }
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                    child: LoadingFlipping.square(
                      borderColor: Colors.blue,
                      size: 30.0,
                    ),
                  );
                }
                if (!snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Text('No Articles');
                } else {
                  return null;
                }
              },
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
                                : Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                          ),
                          left: BorderSide(
                            width: 2,
                            color: arr1.isEmpty
                                ? Colors.grey
                                : Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                          ),
                          right: BorderSide(
                            width: 2,
                            color: arr1.isEmpty
                                ? Colors.grey
                                : Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                          ),
                          bottom: BorderSide(
                            width: 2,
                            color: arr1.isEmpty
                                ? Colors.grey
                                : Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                          ))),
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  width: MediaQuery.of(context).size.width,
                  height: 40.0,
                  child: RaisedButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(
                          color: arr1.isEmpty ? Colors.grey : Colors.black,
                          fontSize: 15.0),
                    ),
                    onPressed: () {
                      setState(() {
                        if (arr1.length == 0) {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please select a valid category'),
                              action: SnackBarAction(
                                label: "OK",
                                onPressed: () {},
                              ),
                            ),
                          );
                        } else {
                          SelectedItems.fetchLists();
//                            subcategories.addAll(arr1);
//                            for (int i=0 ; i<arr1.length ; i++){
//                              print("Anant_Raj________"+arr1[i].toString());
//                            }
//                            for (int i=0 ; i<subcategories.length ; i++){
//                              print("Aditya_________"+subcategories[i].toString());
//                            }
//                            subcategories.toSet();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ArticlePage(
                                        articlesToShow:
                                            subcategories.toSet().toList(),
                                        fromScreen: "YD",
                                      )));
                        }
                      });
                    },
                  ),
                ))
          ],
        ),
      )),
    );
  }
}

T getRandomElement<T>(List<T> list) {
  final random = new Random();
  var i = random.nextInt(list.length);
  return list[i];
}
