import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:ofy_flutter/services/service_lists.dart';
import 'package:ofy_flutter/utilities/LoginProvider.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  var _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController officialLinkController = TextEditingController();
  TextEditingController applyLinkController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController eligibilityController = TextEditingController();
  TextEditingController benefitsController = TextEditingController();
  TextEditingController applicationProcessController = TextEditingController();
  TextEditingController otherDetailsController = TextEditingController();

  Map<String,String> competitionsMap = ServiceLists.competitionsMap;
  Map<String,String> fundingMap = ServiceLists.fundingMap;
  Map<String,String> regionsMap = ServiceLists.countryMap;
  var _competitionTypes = ServiceLists.competitionsList;
  String competitionTypeVal;
  var _fundingTypes = ServiceLists.fundingTypeList;
  String fundingTypeVal;
  var _countriesList = ServiceLists.countriesList;
  String countryVal;
  DateTime _dateTime;
  String _imagePath;
  PickedFile _image;
  final picker = ImagePicker();
  String lastDateText = "Last Date";
  bool inProgress = false;

  void showSnackBar(BuildContext context , String text){
    var snackBar = SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: "OK",
        onPressed: (){},
      ),);
    Scaffold.of(context).showSnackBar(snackBar);
  }

  String getDate(String date){
    return date.substring(8)+"-"+date.substring(5,7)+"-"+date.substring(0,4);
  }

  Future getImage() async {
    final image = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      _imagePath = _image.path;
    });
  }

  Future<void> createPost(BuildContext context) async {
    String authToken = Provider.of<LoginProvider>(context).authToken;
    String apiUrl = "http://ofy.co.in/api/v1/protected/user/submit_opportunity/?key=$authToken";
      try{
        Dio dio = Dio();
        String fileName = _image.path.split('/').last;
      FormData formData = FormData.fromMap({
        'title' : titleController.text,
        'opportunity_type' : competitionsMap[competitionTypeVal],
        'funding_type' : fundingMap[fundingTypeVal],
        'region' : regionsMap[countryVal],
        'deadline' : _dateTime.toIso8601String().substring(0,11)+"11:59:59.999Z",
        'image' : await MultipartFile.fromFile(_image.path,filename: fileName,contentType: new MediaType("image", "jpg")),
        'eligibility' : eligibilityController.text,
        'application_process' : applicationProcessController.text,
        'benefit' : benefitsController.text,
        'other' : otherDetailsController.text,
        'description' : descriptionController.text,
        'url' : officialLinkController.text,
        'apply_url' : applyLinkController.text
      });
      File _dummy = File(_image.path);
      try {
        if (_dummy.lengthSync() > 307200){
          setState(() {
            inProgress = false;
          });
          showSnackBar(context, "Image size cannot exceed 300 Kb");
        }
        else{
          Response response = await dio.post(apiUrl,data: formData,);
          print("TESTING post response ${response.toString()}");
          setState(() {
            inProgress = false;
          });
          print("TESTING createPost() successful:");
          showSnackBar(context, "Submission Successful");
        }
      }catch(e){
        rethrow;
      }

      }
      catch(e){
        setState(() {
          inProgress = false;
        });
        //print(titleController.text+eligibilityController.text+otherDetailsController.text);
        showSnackBar(context, "Oops! Something went wrong");
        print("TESTING createPost() error :"+e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Opportunity"),
      ),
      body: !inProgress ? Builder(
          builder: (context) {
            return SafeArea(
                child: Form(
                  key: _formKey,
                  child: Container(
                    color: Theme.of(context).brightness ==Brightness.light ? Colors.white : Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      child: ListView(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                            child: TextFormField(
                              controller: titleController,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: "Title",
                                  labelStyle: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Color(0xffEECED3)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white)
                                  )
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                            child: Container(
                              padding: EdgeInsets.only(left: 10.0,right: 10.0),
                              height: 65.0,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),
                                  borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration.collapsed(hintText: "Competition Type"),
                                  isExpanded: true,
                                  value: competitionTypeVal,
                                  onChanged: (value){
                                    setState(() {
                                      competitionTypeVal = value;
                                    });
                                  },
                                  items: _competitionTypes.map((value){
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                            child: Container(
                              padding: EdgeInsets.only(left: 10.0,right: 10.0),
                              height: 65.0,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),
                                  borderRadius: BorderRadius.circular(5.0)
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration.collapsed(hintText: "Funding Type"),
                                  isExpanded: true,
                                  value: fundingTypeVal,
                                  onChanged: (value){
                                    setState(() {
                                      fundingTypeVal = value;
                                    });
                                  },
                                  items: _fundingTypes.map((value){
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                            child: Container(
                              padding: EdgeInsets.only(left: 10.0,right: 10.0),
                              height: 65.0,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),
                                  borderRadius: BorderRadius.circular(5.0)
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration.collapsed(hintText: "Region"),
                                  isExpanded: true,
                                  value: countryVal,
                                  onChanged: (value){
                                    setState(() {
                                      countryVal = value;
                                    });
                                  },
                                  items: _countriesList.map((value){
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                            child: GestureDetector(
                              child: Container(
                                padding: EdgeInsets.only(left: 10.0,right: 10.0),
                                height: 65.0,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),
                                    borderRadius: BorderRadius.circular(5.0)
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: _dateTime == null ?
                                  Text("Last Date",style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Color(0xffEECED3),fontSize: 16.0),) :
                                  Text(getDate(_dateTime.toIso8601String().substring(0,10)),style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Colors.white,fontSize: 16.0),),
                                ),
                              ),
                              onTap: (){
                                showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2030)
                                ).then((date){
                                  setState(() {
                                    _dateTime = date;
                                  });
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                            child: GestureDetector(
                              child: Container(
                                padding: EdgeInsets.only(left: 10.0,right: 10.0),
                                height: 65.0,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),
                                    borderRadius: BorderRadius.circular(5.0)
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: _imagePath == null ?
                                  Text("Image",style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Color(0xffEECED3),fontSize: 16.0),) :
                                  Text(_image.path,style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Colors.white,fontSize: 16.0),),
                                ),
                              ),
                              onTap: (){
                                getImage();
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                            child: TextFormField(
                              controller: officialLinkController,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: "Official Link",
                                  labelStyle: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Color(0xffEECED3)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white)
                                  )
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                            child: TextFormField(
                              controller: applyLinkController,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: "Apply Link",
                                  labelStyle: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Color(0xffEECED3)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white)
                                  )
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                            child: TextFormField(
                              textAlign: TextAlign.start,
                              controller: descriptionController,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              minLines: 10,
                              maxLines: 50,
                              decoration: InputDecoration(
                                  labelText: "Description",
                                  labelStyle: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Color(0xffEECED3)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white)
                                  )
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                            child: TextFormField(
                              textAlign: TextAlign.start,
                              controller: eligibilityController,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              minLines: 10,
                              maxLines: 50,
                              decoration: InputDecoration(
                                  labelText: "Eligibility",
                                  labelStyle: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Color(0xffEECED3)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white)
                                  )
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                            child: TextFormField(
                              textAlign: TextAlign.start,
                              controller: benefitsController,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              minLines: 10,
                              maxLines: 50,
                              decoration: InputDecoration(
                                  labelText: "Benefits",
                                  labelStyle: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Color(0xffEECED3)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white)
                                  )
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                            child: TextFormField(
                              textAlign: TextAlign.start,
                              controller: applicationProcessController,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              minLines: 10,
                              maxLines: 50,
                              decoration: InputDecoration(
                                  labelText: "Application Process",
                                  labelStyle: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Color(0xffEECED3)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white)
                                  )
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                            child: TextFormField(
                              textAlign: TextAlign.start,
                              controller: otherDetailsController,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              minLines: 10,
                              maxLines: 50,
                              decoration: InputDecoration(
                                  labelText: "Other Details",
                                  labelStyle: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Color(0xffEECED3)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white)
                                  )
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width-20.0,
                            child: RaisedButton(
                              color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                              child: Text("Submit",style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black),),
                              onPressed: () async {
                                if(titleController.text.isNotEmpty && officialLinkController.text.isNotEmpty && applyLinkController.text.isNotEmpty && competitionTypeVal.isNotEmpty && fundingTypeVal.isNotEmpty && countryVal.isNotEmpty && _dateTime != null && _imagePath != null){
                                  await createPost(context);
                                }
                                else {
                                  showSnackBar(context, "Fill all mandatory fields");
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            );
          }
      ) : Center(child: CircularProgressIndicator(),),
    );
  }
}
