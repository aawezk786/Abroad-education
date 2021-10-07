import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ofy_flutter/MyEnums/MyResponseType.dart';
import 'package:ofy_flutter/models/opportunity.dart';
import 'package:ofy_flutter/services/services.dart';
import 'package:ofy_flutter/utilities/LoginProvider.dart';
import 'package:provider/provider.dart';

class SubmissionsScreen extends StatefulWidget {
  @override
  _SubmissionsScreenState createState() => _SubmissionsScreenState();
}

class _SubmissionsScreenState extends State<SubmissionsScreen> {
  List<Opportunity> submittedList = [];
  List<Opportunity> approvedList = [];
  bool isLoading = false;
  bool _isInitialDataLoaded;
  String _authToken;
  MyResponseType responseType = MyResponseType.EMPTY;

  @override
  void initState() {
    super.initState();
    _isInitialDataLoaded = false;
  }
  @override
  void didChangeDependencies() {
    if(! _isInitialDataLoaded) {
      print("TESTING SubmissionsScreen initial data loaded");
      _authToken = Provider
          .of<LoginProvider>(context)
          .authToken;
      getSubmittedData();
      _isInitialDataLoaded=true;
    }

    super.didChangeDependencies();
  }

  void getSubmittedData() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }
    Map<String, dynamic> responseMap =
        await OfyApi.instance.getSubmissionList(key: _authToken);
    print('TESTING isnull ${responseMap==null}');
    MyResponseType currentResponseType = responseMap[OfyApi.RESPONSE_TYPE];
    print('TESTING ${currentResponseType.toString()}');
    switch (currentResponseType) {
      case MyResponseType.EMPTY:
      case MyResponseType.FAILED:
        setState(() {
          isLoading = false;
          responseType = currentResponseType;
        });
        break;
      case MyResponseType.SUCCESS:
        List<Opportunity> temp =
            responseMap[OfyApi.RESPONSE_BODY] as List<Opportunity>;
        setState(() {
          isLoading = false;
          responseType = currentResponseType;
          submittedList = temp;
        });
        break;
    }
  }

  void getApprovedData() async {
    if (!isLoading) {
      setState(() {
        if(!mounted)
           return
        isLoading = true;
      });
    }
    Map<String, dynamic> responseMap =
        await OfyApi.instance.getApprovedSubmissionList(key: _authToken); //in previous code, the page number is always 0
    MyResponseType currentResponseType = responseMap[OfyApi.RESPONSE_TYPE];
    print('TESTING $responseType');
    switch (currentResponseType) {
      case MyResponseType.EMPTY:
      case MyResponseType.FAILED:
        setState(() {
          isLoading = false;
          responseType = currentResponseType;
        });
        break;
      case MyResponseType.SUCCESS:
        List<Opportunity> temp =
            responseMap[OfyApi.RESPONSE_BODY] as List<Opportunity>;
        setState(() {
          isLoading = false;
          responseType = currentResponseType;
          approvedList = temp;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Submissions"),
      ),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: (responseType != MyResponseType.SUCCESS) && (!isLoading)
                ? Align(
                    child: Text("No Submissions"),
                    alignment: Alignment.center,
                  )
                : Container(
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: submittedList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 100.0,
                          child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: CircleAvatar(
                                    child: Image(
                                      image: NetworkImage(
                                        submittedList[index].image,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    submittedList[index].title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                      submittedList[index].opportunityType),
                                  trailing: Icon(
                                    Icons.timelapse,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )),
      ),
    );
  }
}
