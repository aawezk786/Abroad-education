import 'dart:convert';
// import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:gscarousel/gscarousel.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:ofy_flutter/groupMsg/groupMain.dart';
import 'package:ofy_flutter/models/banner.dart';
import 'package:ofy_flutter/models/opportunity.dart';
import 'package:ofy_flutter/screens/explore_category.dart';
import 'package:ofy_flutter/services/services.dart';
import 'package:ofy_flutter/utilities/LoginProvider.dart';
import 'package:ofy_flutter/widgets/MyNativeAd.dart';
import 'package:ofy_flutter/widgets/opportunities_on_home.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


import 'create_post.dart';
const String testDevice = "";

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin
 {
   static String APP_ID = "ca-app-pub-4469832093134965~2405663769";
      bool _isVisible = true;
      String _authToken;
      void showToast()
      {
        _isVisible = !_isVisible;
      }

  //  final MobileAdTargetingInfo _mobileAdTargetingInfo =
  //     new MobileAdTargetingInfo(
  //   testDevices: [],
  //   childDirected: false,
  //   nonPersonalizedAds: true,
  //   keywords: [
  //     "Jobs",
  //     "Job",
  //     "Job Opportunities",
  //     "Internships",
  //     "Fellowships"
  //   ],
  // );

  // BannerAd _bannerAd;
  // BannerAd createBannerAd() {
  //   return BannerAd(
  //     adUnitId: "ca-app-pub-4469832093134965~4468194633",
  //     size: AdSize.banner,
  //     targetingInfo: _mobileAdTargetingInfo,
  //     listener: (MobileAdEvent event) {
  //       print("BannerAd event $event");
  //     },
  //   );
  // }

  List<Banners> bannerList = [];
  List<String> imageLocationList = [];
  List<String> categoryTagList = [
    "Create",
    "Competitions",
    "Conferences",
    "Internship",
    "Fellowships",
    "Grants",
    "Scholarships",
    "Workshops",
    "Miscellaneous"
  ];
  List<Opportunity> recentList = [];
  List<Opportunity> featuredList = [];
  List<Opportunity> competitionList = [];
  List<Opportunity> internshipList = [];
  List<Opportunity> conferenceList = [];
  List<Opportunity> fellowshipList = [];
  List<Opportunity> grantsList = [];
  List<Opportunity> workshopList = [];
  List<Opportunity> scholarshipList = [];
  List<Opportunity> miscList = [];
  List _categoryList = [];

  getData(http.Client client) async {
    final response =
        await client.get('http://ofy.co.in/api/v1/public/opportunities');
    recentList = parseLists(response.body, 'recentPosts');
    featuredList = parseLists(response.body, 'featured');
    competitionList = parseLists(response.body, 'competitions');
    internshipList = parseLists(response.body, 'internship');
    conferenceList = parseLists(response.body, 'conferences');
    fellowshipList = parseLists(response.body, 'fellowships');
    grantsList = parseLists(response.body, 'grants');
    workshopList = parseLists(response.body, 'workshops');
    scholarshipList = parseLists(response.body, 'scholarships');
    miscList = parseLists(response.body, 'miscellaneous');
  }

  getBannerData(http.Client client) async {
 //   final response = await client.get('http://offy.xyz/wp-json/wp/v2/banner');
   final response = await client.get('http://ofy.co.in/api/v1/public/banners');
    var responseBody = response.body;
    final parsed = jsonDecode(responseBody);
    List<Banners> temp = List<Banners>();
    for (int i = 0; i < parsed.length; i++) {
      temp.add(Banners.fromJson(parsed[i]));
    }
    setState(() {
      if(!mounted)
          return;
      bannerList = temp;
    });
  }

  List<Opportunity> parseLists(String responseBody, String tag) {
    final parsed = jsonDecode(responseBody);
    List<Opportunity> temp = new List<Opportunity>();
    for (int i = 0; i < parsed[tag].length; i++) {
      temp.add(Opportunity.fromJson(parsed[tag][i]));
    }
    setState(() {});
    return temp;
  }

  void getData2() async {

    getData(http.Client());
    getBannerData(http.Client());
  }




  @override
  void initState() {
    // FirebaseAdMob.instance.initialize(appId: APP_ID);
    // _bannerAd = createBannerAd()
    //   ..load()
    //   ..show(
    //       anchorType: AnchorType.bottom,
    //       anchorOffset: kBottomNavigationBarHeight);
    imageLocationList = IconList.getImageList();
    getData2();

    super.initState();
  }

  List get categoryList => _categoryList;


  void showSnackBar(BuildContext context) {
    var snackBar = SnackBar(
      content: Text("Sorry  :(  , Nothing to show"),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {},
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget headerIconBuilder(BuildContext context,int index){
    return InkWell(
      child: Container(
        height: 45.0,
        width: 100.0,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              height: 45.0,
              width: 45.0,
              child: Image(
                image: AssetImage(
                    imageLocationList[index]),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Container(
                child: Text(categoryTagList[index],style: TextStyle(
                  fontWeight: FontWeight.bold,

                ),))
          ],
        ),
      ),
      onTap: () {
        List list = [];
        String tag = "";
        print("TESTING CLICKED INDEX $index");
        if (index == 1) {
          list = competitionList;
          tag = "COMPETITIONS";
        } else if (index == 2) {
          list = conferenceList;
          tag = "CONFERENCES";
        } else if (index == 3) {
          list = internshipList;
          tag = "INTERNSHIP";
        } else if (index == 4) {
          list = fellowshipList;
          tag = "FELLOWSHIPS";
        } else if (index == 5) {
          list = grantsList;
          tag = "GRANTS";
        } else if (index == 6) {
          list = scholarshipList;
          tag = "SCHOLARSHIPS";
        } else if (index == 7) {
          list = workshopList;
          tag = "WORKSHOPS";
        } else if (index == 8) {
          list = miscList;
          tag = "MISCELLANEOUS";
        }
        if (index != 0) {
          if (list.length == 0) {
            showSnackBar(context);
            return;
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExploreCategory(
                    tag: tag,
                  )));
        } else if (index == 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreatePost()));
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    super.build(context); //needed by AutomaticKeepAliveClientMixin
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.group),
        onPressed: () {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => GroupsBase()),
          );

          // Add your onPressed code here!
        },),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ofy",
        ),
      ),
      body: Container(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        child:  recentList.length ==0 &&
                featuredList.length == 0 &&
                competitionList.length == 0 &&
                conferenceList.length == 0 &&
                internshipList.length == 0 &&
                fellowshipList.length == 0 &&
                grantsList.length == 0 &&
                workshopList.length == 0 &&
                scholarshipList.length == 0 &&
                miscList.length == 0
            ? Center(
                child: Lottie.asset('assets/anim/loaderAnim.json'),
              )
            : Container(
                child: SingleChildScrollView(
                    child: Column(
                //Main Column
               children: <Widget>[
               Container(
                    child:
                      bannerList.length != 0 ?
                      Container(
                      padding:
                      EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),
                      height: 140.0,
                        child: GSCarousel(
                     images: bannerList.map((banner) => NetworkImage(banner.imageUrl)).toList(),
                     indicatorSize: const Size.square(8.0),
                     indicatorActiveSize: const Size(18.0, 8.0),
                     indicatorColor: Colors.white,
                     indicatorActiveColor: Colors.grey,
                     animationCurve: Curves.easeIn,
                     contentMode: BoxFit.fill,
                   ),
                      )
                  : Container()
                ),

                  

                 Divider(
                    thickness: 1.0,
                  ),
                  //SizedBox(height: 15.0,),
                  Padding(
                      padding: EdgeInsets.only(top: 10.0, right: 10.0,left: 8),
                      child: Container(
                        height: 70.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: imageLocationList.length,
                          itemBuilder: (context, index) {
                            if(index==0)
                              return FutureBuilder(
                                  future: Provider.of<LoginProvider>(context).isSignedIn,
                                  builder : (ctx,snapshot){
                                    if(snapshot.connectionState == ConnectionState.done){
                                      var isSignedIn = snapshot.data;
                                      return isSignedIn ? headerIconBuilder(context, index) : Container();
                                    }else{
                                      return Container();
                                    }
                                  }
                              );
                            else
                              return headerIconBuilder(context, index);
                            // return headerIconBuilder(context, index);
                          },
                        ),
                      )),
                  Divider(
                    thickness: 1.0,
                  ),
                  //Recent
                  OpportunityOnHomePage(recentList, "Recent"),

                 Container(
                   padding: EdgeInsets.only(left: 10.0,right: 10.0),
                   child: MyNativeAd(NativeAdmobType.banner,adWidth:MediaQuery.of(context).size.width,adHeight: 130),
                 ),

                 //Featured
                  OpportunityOnHomePage(featuredList, "Featured"),

                 //Competitions
                  OpportunityOnHomePage(competitionList, "Competitions"),
                  //Conferences
                  OpportunityOnHomePage(conferenceList, "Conferences"),

                  //Internships
                  OpportunityOnHomePage(internshipList, "Internships"),
                 Container(
                   padding: EdgeInsets.only(left: 10.0,right: 10.0),
                   child: MyNativeAd(NativeAdmobType.banner,adWidth:MediaQuery.of(context).size.width,adHeight: 130,),
                 ),

                  //Fellowships
                  OpportunityOnHomePage(fellowshipList, "Fellowships"),

                  //Grants
                  OpportunityOnHomePage(grantsList, "Grants"),

                  //Scholarships
                  OpportunityOnHomePage(scholarshipList, "Scholarships"),

                  //Workshops
                  OpportunityOnHomePage( workshopList, "Workshops"),
                   Container(
                   padding: EdgeInsets.only(left: 10.0,right: 10.0),
                   child: MyNativeAd(NativeAdmobType.banner,adWidth:MediaQuery.of(context).size.width,adHeight: 130),
                 ),
                  //Miscellaneous
                  OpportunityOnHomePage( miscList, "Miscellaneous"),

                ],
              ))),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

