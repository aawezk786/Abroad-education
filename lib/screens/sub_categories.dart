//Manish
import 'package:flutter/material.dart';
import '../articles_dir/articles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var arr = [];
var subcategories = [];
var articlesToShow = [];

class SubCategoryPage extends StatefulWidget {
  SubCategoryPage({@required this.category});

  final category;

  @override
  _SubCategoryPageState createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  Future getData() async {
    final response =
        await http.get('https://thawing-harbor-22697.herokuapp.com/articles');
    return jsonDecode(response.body);
  }

  List articles = [];

  var valuefirst = [];

  @override
  void initState() {
//    fetch();
    subcategories.clear();
    arr.clear();
    articlesToShow.clear();
    valuefirst.clear();
    for (var i in widget.category) {
      arr.add(i["sub_cat"]);
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
            if(!mounted)
               return;
            articles = value;
            print(articles);
            subcategories.clear();
            arr.clear();
            articlesToShow.clear();
            valuefirst.clear();
            if (articles.length != 0) {
              for (var y in widget.category) {
                for (var i in articles) {
                  if (i["cat"] == y) {
                    arr.add(i["sub_cat"]);
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Select Sub Category',
            style: TextStyle(
            ),
          ),
        ),
        floatingActionButton: Builder(builder: (BuildContext context) {
          return FloatingActionButton(
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
                                articlesToShow: articlesToShow,
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
          child: ListView.builder(
            itemCount: subcategories.length,
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
                          for (var k in widget.category) {
                            if (k["sub_cat"] == subcategories[index]) {
                              articlesToShow.add(k);
                            }
                          }
                        }
                        if (valuefirst[index] == false) {
                          for (var k in widget.category) {
                            if (k["sub_cat"] == subcategories[index]) {
                              articlesToShow.remove(k);
                            }
                          }
                        }
                        print(articlesToShow);
                      });
                    },
                  ),
                  Text(subcategories[index]),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
