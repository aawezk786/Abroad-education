
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ofy_flutter/MyEnums/RequestType.dart';
import 'dart:convert';
import 'package:ofy_flutter/models/opportunity.dart';
import '../MyEnums/MyResponseType.dart';

//class GetOpportunities {
//
//  static Future<List<Opportunity>> getData(String tag)async{
//    List<Opportunity> list;
//    String apiUrl = "http://ofy.co.in/api/v1/public/opportunities";
//    var result = await http.get(apiUrl);
//    if (result.statusCode == 200){
//      var data = jsonDecode(result.body);
//      var rest = data[tag] as List;
//      list = rest.map<Opportunity>((json) => Opportunity.fromJson(json)).toList();
//    }
//
//    return list;
//  }
//}

class IconList {
  static List<String> getImageList() {
    List<String> imageLocationsList = List<String>();
    imageLocationsList.add("assets/images/create.png");
    imageLocationsList.add("assets/images/competitions.png");
    imageLocationsList.add("assets/images/conference.png");
    imageLocationsList.add("assets/images/internship.png");
    imageLocationsList.add("assets/images/fellowship.png");
    imageLocationsList.add("assets/images/grants.png");
    imageLocationsList.add("assets/images/scholarship.png");
    imageLocationsList.add("assets/images/workshop.png");
    imageLocationsList.add("assets/images/miscellaneous.png");
    return imageLocationsList;
  }
}

class OfyApi {
  static OfyApi _instance;
  static String RESPONSE_TYPE = "response_type";
  static String RESPONSE_BODY = "reponse_body";

  static String PAGE_QUERYSTRING = "page";
  static String KEY_QUERYSTRING = "key";
  static String OPP_ID_QUERYSTRING = "opportunity_id";

  OfyApi._();

  static OfyApi get instance => _instance ??= OfyApi._();

  Future<Map<String, dynamic>> getBookmarkList (
      {int page = 0, @required String key}) async {
    Map<String, dynamic> queryStrings = {
      PAGE_QUERYSTRING: page,
      KEY_QUERYSTRING: key
    };
    return   _getResponse(RequestType.BOOKMARKS, queryStrings);
  }

  Future<Map<String, dynamic>> getSubmissionList(
      {int page = 0, String key}) async {
    Map<String, dynamic> queryStrings = {
      PAGE_QUERYSTRING: page,
      KEY_QUERYSTRING: key
    };
    return _getResponse(RequestType.SUBMISSION_ALL, queryStrings);
  }

  Future<Map<String, dynamic>> getApprovedSubmissionList(
      {int page = 0, String key}) async {
    Map<String, dynamic> queryStrings = {
      PAGE_QUERYSTRING: page,
      KEY_QUERYSTRING: key
    };
    return _getResponse(RequestType.SUBMISSION_APPROVED, queryStrings);
  }

  Future<Map<String, dynamic>> getBookmarkStatus({String opp_id, String key}) {
    Map<String, dynamic> queryStrings = {
      OPP_ID_QUERYSTRING: opp_id,
      KEY_QUERYSTRING: key
    };
    return _getResponse(RequestType.BOOKMARK_STATUS, queryStrings);
  }

  Future<Map<String, dynamic>> toogleBookmark({String opp_id, String key}) {
    Map<String, dynamic> queryStrings = {
      OPP_ID_QUERYSTRING: opp_id,
      KEY_QUERYSTRING: key
    };
    return _getResponse(RequestType.TOGGLE_BOOKMARK, queryStrings);
  }
  Future<Map<String,dynamic>> getNotifications(){
    return _getResponse(RequestType.NOTIFICATION, null);
  }

  // _getResponse() returns map of
  //  RESPONSE_TYPE :  enum MyResponseType
  //  RESPONSE_BODY : list of opportunity
  Future<Map<String, dynamic>> _getResponse(RequestType requestType,
      Map<String, dynamic> queryStrings) async {
    Map<String, dynamic> responseMap = {
      RESPONSE_TYPE: MyResponseType.EMPTY,
      RESPONSE_BODY: []
    };
    var url = _getUrl(requestType, queryStrings);
    var response = await http.get(url);
    var parsed = jsonDecode(response.body);
    print("TESTING getResponse() parsed :${parsed}");

    if (parsed.length == 0) {
      responseMap[RESPONSE_TYPE] = MyResponseType.EMPTY;
      responseMap[RESPONSE_BODY] = [];
    }
    // when error occur, the backend returns a Map with fields like error,status_code etc..
    else if (parsed is Map<String,dynamic> && parsed.containsKey('error')) {
      print("TESTING : FAILED");
      responseMap[RESPONSE_TYPE] = MyResponseType.FAILED;
      responseMap[RESPONSE_BODY] = [];
    } else {
      responseMap[RESPONSE_TYPE] = MyResponseType.SUCCESS;
      switch (requestType) {
        case RequestType.BOOKMARKS:
        case RequestType.SUBMISSION_ALL:
        case RequestType.SUBMISSION_APPROVED:
          List<Opportunity> temp = List<Opportunity>();
          for (int i = 0; i < parsed.length; i++) {
            temp.add(Opportunity.fromJson(parsed[i]));
          }
          responseMap[RESPONSE_BODY] = temp;
          break;
        case RequestType.TOGGLE_BOOKMARK:
        case RequestType.BOOKMARK_STATUS:
        case RequestType.NOTIFICATION:
           responseMap[RESPONSE_BODY]= parsed;
           break;

      }
    }
    return responseMap;
  }

  String _getUrl(RequestType requestType, Map<String, dynamic> queryStrings) {
    var url;
    switch (requestType) {
      case RequestType.BOOKMARKS:
        url = "http://ofy.co.in/api/v1/protected/user/bookmarks?";
        break;
      case RequestType.SUBMISSION_ALL:
        url = "http://ofy.co.in/api/v1/protected/user/submitted_opportunities?";
        break;
      case RequestType.SUBMISSION_APPROVED:
        url = "http://ofy.co.in/api/v1/protected/user/approved_opportunities?";
        break;
      case RequestType.BOOKMARK_STATUS:
        url = "http://ofy.co.in/api/v1/protected/user/is_bookmarked?";
        break;
      case RequestType.TOGGLE_BOOKMARK:
        url = "http://ofy.co.in/api/v1/protected/user/toggle_bookmarked?";
        break;
      case RequestType.NOTIFICATION:
        url = "http://ofy.co.in/api/v1/public/notifications";
        break;
    }
    queryStrings?.forEach((key, value) {
      url += "$key=$value&";
    });
    print("TESTING  Url ${url}");
    return url;
  }
}
