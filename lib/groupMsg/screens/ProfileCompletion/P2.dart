import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ofy_flutter/groupMsg/helpers/CurrentUser.dart';
import 'P2.dart';
import 'package:http/http.dart';
import 'package:dio/dio.dart';
import 'profileGlobal.dart';
import 'profileSuggestions.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class Categories {
  final int id;
  final String name;

  Categories({
    this.id,
    this.name,
  });
}
class Contents {
  final int id;
  final String name;

  Contents({
    this.id,
    this.name,
  });
}


class P2 extends StatefulWidget {
  @override
  _P2State createState() => _P2State();
}

class _P2State extends State<P2> {

  final interest = TextEditingController();





  makePostRequest() async {
    String token = "pf5JOdYQHRTadH62OPhmVziGdAuTYMtL";
//Instance level
    Dio().options.contentType= Headers.formUrlEncodedContentType;
//or works once
    Dio().post(
      'http://192.168.1.6:9000/registerprofiles',
      data: {'access_token':token,'name':CurrentUser.user.username,'phone':user_phone,'city':user_city,'email':CurrentUser.user.email},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
  }

  interestPost() async {
    String token = "pf5JOdYQHRTadH62OPhmVziGdAuTYMtL";
//Instance level
    Dio().options.contentType= Headers.formUrlEncodedContentType;
//or works once
    Dio().post(
      'http://192.168.1.6:9000/siml',
      data: {'access_token':token,'username':CurrentUser.user.username,'similarity':interest.text},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
  }

  interestGet() async{
    var dio = Dio();
    var response;
    String requrl = "http://192.168.1.6:9000/siml/"+interest.text;
    response = await dio.get(requrl, queryParameters: {'access_token': 'pf5JOdYQHRTadH62OPhmVziGdAuTYMtL'});
    // print(response.data.toString());
    response.data['rows'].forEach((element) => {

      user_interests.add(element['username'])



    });
  }


  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    interest.dispose();

    super.dispose();
  }






  static List<Categories> _animals = [
    Categories(id: 1, name: "Scholarships"),
    Categories(id: 2, name: "Fellowships"),
    Categories(id: 3, name: "Funding and Grants"),
    Categories(id: 4, name: "Competitions"),
    Categories(id: 5, name: "Workshops"),
    Categories(id: 6, name: "Internships"),
  ];



  static List<Contents> _contents = [
    Contents(id: 1, name: "Theil FellowShip"),
    Contents(id: 2, name: "Google Summer Of Code"),
    Contents(id: 3, name: "Google Kickstart"),

  ];




  List<Categories> _selectedAnimals2 = [];
  var _items = _animals
      .map((animal) => MultiSelectItem<Categories>(animal, animal.name))
      .toList();
  List<Categories> _selectedContents = [];
  var _iContents = _contents
      .map((content) => MultiSelectItem<Contents>(content, content.name))
      .toList();



  var dropDownSelection;
  final List<String> names = <String>['Aby', 'Aish', 'Ayan', 'Ben', 'Bob', 'Charlie', 'Cook', 'Carline'];
  final List<int> msgCount = <int>[2, 0, 10, 6, 52, 4, 0, 2];

  void _modalBottomSheetMenu(){
    print(_items);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                return Center(
                  child: Column(children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 300,
                      padding: EdgeInsets.only(left: 10,top: 10,bottom: 10,right: 0),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Category",style: TextStyle(
                              color: Colors.white,fontSize: 18
                          ),),
                          SizedBox(
                            width: 10,
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          Container(

                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: DropdownButton<String>(

                                hint: Text('Select the type'),
                                value: dropDownSelection,
                                items: <String>['Scholarships', 'Fellowships', 'Funding and Grants', 'Competitions','Workshops','Internships'].map((String value) {
                                  return new DropdownMenuItem<String>(
                                    // Not necessary for Option 1
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {



                                  setState(() {
                                    if(value == "Workshops") {



                                      _contents = [
                                        Contents(id: 1,
                                            name: "IIT madras workshop "),
                                        Contents(
                                            id: 2, name: "KGP workshop for ML"),
                                        Contents(id: 3, name: "XSP workshop"),

                                      ];


                                    } if (value == "Scholarships"){
                                      _contents = [
                                        Contents(id: 1, name: "Theil FellowShip"),
                                        Contents(id: 2, name: "Google Summer Of Code"),
                                        Contents(id: 3, name: "Google Kickstart"),

                                      ];
                                    }


                                    _iContents = _contents
                                        .map((content) =>
                                        MultiSelectItem<Contents>(
                                            content, content.name))
                                        .toList();



                                    dropDownSelection = value;

                                  });

                                },
                              )
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 30,),
                    Container(
                      width: 300,
                      padding: EdgeInsets.all(10),

                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)),

                      child: MultiSelectBottomSheetField(
                        initialChildSize: 0.4,
                        listType: MultiSelectListType.CHIP,
                        searchable: true,
                        buttonText: Text("Select your contents",style: TextStyle(color:Colors.white),),
                        title: Text("Available Categories"),
                        items: _iContents,
                        onConfirm: (values) {
                          _selectedContents = values;
                        },
                        chipDisplay: MultiSelectChipDisplay(
                          onTap: (value) {
                            setState(() {
                              _selectedContents.remove(value);
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(width:300,child: ElevatedButton(onPressed: (){





                    }, child: Text("Add")))

                  ],),
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Row(
          children: [
            Text("Complete Your Profile"),
            SizedBox(width: 10,),
            Icon(Icons.looks_one),
            CircleAvatar(child: Icon(Icons.looks_two)),
            Icon(Icons.looks_3),



          ],
        ),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: CircleAvatar
                (
                  backgroundImage: NetworkImage(CurrentUser.user.photoURL),
                  radius: 55,
                  child: CurrentUser.user.photoURL == null ?
                  Icon(Icons.person, size: 55, ) :
                  SizedBox()
              ),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Select your interests below "),
              SizedBox(
                height: 20,
              ),

              Container(
                width: 300,
                child: MultiSelectBottomSheetField(
                  initialChildSize: 0.4,
                  listType: MultiSelectListType.CHIP,
                  searchable: true,
                  buttonText: Text("Select your categories"),
                  title: Text("Available Categories"),
                  items: _items,
                  onConfirm: (values) {
                    _selectedAnimals2 = values;
                  },
                  chipDisplay: MultiSelectChipDisplay(
                    onTap: (value) {
                      setState(() {
                        _selectedAnimals2.remove(value);
                      });
                    },
                  ),
                ),
              ),
                         Container(
                width: 300,
                child: MultiSelectBottomSheetField(
                  initialChildSize: 0.4,
                  listType: MultiSelectListType.CHIP,
                  searchable: true,
                  buttonText: Text("Select your contents"),
                  title: Text("Available Categories"),
                  items: _iContents,
                  onConfirm: (values) {
                    _selectedContents = values;
                  },
                  chipDisplay: MultiSelectChipDisplay(
                    onTap: (value) {
                      setState(() {
                        _selectedContents.remove(value);
                      });
                    },
                  ),
                ),
              ),



              SizedBox(
                height: 20,
              ),

              Container(
                width: 300,
                child: ElevatedButton(onPressed: (){

                  _modalBottomSheetMenu();

                }, child: Text("add an interest")),
              ),

              Container(
                width: 300,
                child: TextField(
                  controller: interest,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Interest',
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 45),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        width: 200,
                        child: ElevatedButton(onPressed: (){
                          print("clicked");
                          // makePostRequest();
                          // interestPost();
                          interestGet();


                          Navigator.push(
                              context,MaterialPageRoute(builder: (context)=>ProfileSuggestions())
                          );



                        }, child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Next"),
                            Icon(Icons.navigate_next)

                          ],
                        ))),
                  ],
                ),
              )
            ],
          )
      ),
    );
  }
}