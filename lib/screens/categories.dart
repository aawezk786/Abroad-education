//Manish
import 'package:flutter/material.dart';
import 'sub_categories.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:loading_animations/loading_animations.dart';

var arr = [];
var categories = [];
var subcategories = [];

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  StreamController _postsController;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Future getData() async {
    final response =
        await http.get('https://thawing-harbor-22697.herokuapp.com/articles');
    return jsonDecode(response.body);
  }

  List articles = [];
  var valuefirst = [];

  @override
  void initState() {
    _postsController = new StreamController();
    loadCategories();
    fetch();
    super.initState();
  }

  loadCategories() async {
    getData().then((res) async {
      _postsController.add(res);
      return res;
    });
  }

  fetch() async {
    await getData().then((value) {
      setState(() {
        articles = value;
        categories.clear();
        arr.clear();
        valuefirst.clear();
        subcategories.clear();
        if (articles.length != 0) {
          for (final value in articles) {
            arr.add(value["cat"]);
          }
          categories = arr.toSet().toList();
          print(categories);
          for (int i = 0; i < categories.length; i++) {
            valuefirst.add(false);
          }
          arr.clear();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Select Category',
            style: TextStyle(
            ),
          ),
        ),
        floatingActionButton: Builder(builder: (BuildContext context) {
          return FloatingActionButton(
            onPressed: () {
              setState(() {
                if (arr.length == 0) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a valid category')),
                  );
                } else {
                  print(
                      "Sending to next page : **************************************");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubCategoryPage(
                                category: subcategories,
                              )));
                }
              });
            },
            child: Icon(
              Icons.navigate_next,
            ),
          );
        }),
        body: Container(
          child: articles.length == 0
              ? LoadingFlipping.square(
                  borderColor: Colors.cyan,
                  size: 30.0,
                )
              : ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.blue,
                          activeColor: Colors.white70,
                          value: valuefirst[index],
                          onChanged: (bool value) {
                            setState(() {
                              valuefirst[index] = value;
                              if (valuefirst[index] == true) {
                                arr.add(categories[index]);
                                for (var k in articles) {
                                  if (k["cat"] == categories[index]) {
                                    subcategories.add(k);
                                  }
                                }
                              }
                              if (valuefirst[index] == false) {
                                arr.remove(categories[index]);
                                for (var k in articles) {
                                  if (k["cat"] == categories[index]) {
                                    subcategories.remove(k);
                                  }
                                }
                              }
                            });
                          },
                        ),
                        Text(categories[index]),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }
}
