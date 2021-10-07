import 'dart:convert';
import 'dart:convert' show utf8;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:ofy_flutter/models/opportunity.dart';
import 'package:ofy_flutter/screens/official_link_view.dart';
import 'package:ofy_flutter/services/calender_services.dart';
import 'package:ofy_flutter/utilities/LoginProvider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../utilities/theme.dart';
import '../services/services.dart';
class OpportunityDetails extends StatefulWidget {
  final Opportunity opportunity;

  OpportunityDetails({@required this.opportunity});

  @override
  _OpportunityDetailsState createState() => _OpportunityDetailsState();
}

class _OpportunityDetailsState extends State<OpportunityDetails> {
  CalendarServices calendarServices = CalendarServices();
  bool isPressed = false;
  var unescape = HtmlUnescape();
  ScrollController _scrollController;
  bool _showTitle=false;
  HtmlEscape htmlEscape = HtmlEscape();
  String _authToken;
  bool _isInitialDataLoaded;
  //ThemeNotifier themeNotifier = ThemeNotifier();

  @override
  void initState() {
    super.initState();
    _isInitialDataLoaded=false;
    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      if(_scrollController.offset>240 && ! _showTitle){
        setState(() {
          _showTitle = true;
        });
      }
      if(_scrollController.offset<240 && _showTitle){
        setState(() {
          _showTitle = false;
        });
      }
    });
  }
  @override
  void didChangeDependencies() {
    if(!_isInitialDataLoaded) {
      _authToken = Provider
          .of<LoginProvider>(context)
          .authToken;
      getBookmarkStatus();
      _isInitialDataLoaded=true;
    }
    super.didChangeDependencies();
  }
  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }
  getBookmarkStatus() async {

    Map<String,dynamic> responseMap = await OfyApi.instance.getBookmarkStatus(opp_id: widget.opportunity.id.toString(), key: _authToken);
    try {
      var value = responseMap[OfyApi.RESPONSE_BODY]["currentState"];
      print("TESTING isPressed : $value");
      setState(() {
        if (!mounted)
          return;
        isPressed = value;
      });
    }catch(e) {
      print(e);
    }

  }

  toggleBookMarkStatus() async {
    setState(() {
      if(!mounted)
         return;
      isPressed=!isPressed;
    });
   await OfyApi.instance.toogleBookmark(opp_id: widget.opportunity.id.toString(), key: _authToken);
  }

  String _parseHtmlString(String htmlString) {
    var document = parse(htmlString);
    // print(document);
    // print('*******************************');
    String parsedString = parse(document.body.text).documentElement.text;
    print(parsedString);
    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.black);
    // FlutterStatusbarTextColor.setTextColor(FlutterStatusbarTextColor.light);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    var bgColor = themeChange.darkTheme ? Colors.black : Colors.white;

    List<TabWrapper> list = List<TabWrapper>();
    if (widget.opportunity.description != null &&
        widget.opportunity.description.trim().isNotEmpty) {
      list.add(TabWrapper(
          utf8.decode(widget.opportunity.description.runes.toList()).replaceAll(new RegExp(
              r'(<strong>)|(</strong>)|(<i>)|(</i>)'),""),
          "DESCRIPTION"));
    }
    if (widget.opportunity.benefit != null &&
        widget.opportunity.benefit.trim().isNotEmpty)
      list.add(TabWrapper(
          utf8.decode(widget.opportunity.benefit.runes.toList()), "BENEFITS"));
    if (widget.opportunity.eligibility != null &&
        widget.opportunity.eligibility.trim().isNotEmpty)
      list.add(TabWrapper(
          utf8.decode(widget.opportunity.eligibility.runes.toList()),
          "ELIGIBILITY"));
    if (widget.opportunity.applicationProcess != null &&
        widget.opportunity.applicationProcess.trim().isNotEmpty)
      list.add(TabWrapper(
          utf8.decode(widget.opportunity.applicationProcess.runes.toList()),
          "APPLICATION PROCESS"));
    if (widget.opportunity.other != null &&
        widget.opportunity.other.trim().isNotEmpty)
      list.add(TabWrapper(
          utf8.decode(widget.opportunity.other.runes.toList()), "OTHERS"));

    List<Tab> tabs = List<Tab>();
    for (TabWrapper tw in list) {
      tabs.add(Tab(text: tw.title));
    }

    Color _color = Theme.of(context).brightness == Brightness.light
        ? Color(0xff474747)
        : Colors.white70;
    List<Widget> tabBars = List<Widget>();
    for (TabWrapper tw in list) {
      tabBars.add(
        SingleChildScrollView(
            child: Container(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          child: Column(
            children: [
              SizedBox(height: 40.0),
              Container(
                padding: const EdgeInsets.only(top: 16.0, left: 12.0, right: 8.0),
                child: HtmlWidget(
                  tw.content,
                  customStylesBuilder: (element){
                    if(element.parentNode.toString().contains("p")){
                      return {'font-size':"20px" };
                    }else if(element.parentNode.toString().contains("li")){
                      return {'font-size':"18px" };
                    }
                     if(element.localName.contains("strong")){
                      return {'font-weight':'normal' };
                    }
                    return null;
                  },
                  textStyle: TextStyle(
                    fontSize: 20, //default font-size
                      fontFamily: "Georgia",
                      fontWeight: FontWeight.normal,
                      height: 1.6,
                      color: Theme
                          .of(context)
                          .brightness == Brightness.light
                          ? Colors.black87
                                : Colors.white70),
                  ),
                ),

                // Html(
                //   style: {
                //    "p": Style.fromTextStyle(
                //      TextStyle(
                //         fontSize: 18,
                //         fontFamily: "Georgia",
                //         color: Theme.of(context).brightness == Brightness.light
                //             ? Color.fromRGBO(80, 80, 80, 1)
                //             : Colors.white),
                //    ),
                //   "ul": Style.fromTextStyle(
                //     TextStyle(
                //         height: 1.2,
                //         fontSize: 18,
                //         fontFamily: "Georgia",
                //         color: Theme.of(context).brightness == Brightness.light
                //             ? Color.fromRGBO(80, 80, 80, 1)
                //             : Colors.white),
                //   ),
                //   },
                //   data: tw.content,
                // ),
            ],
          ),
        )),
      );
    }

    void setReminder() {
      calendarServices.insert(
          utf8.decode(widget.opportunity.title.runes.toList()),
          DateTime.now(),
          widget.opportunity.deadline.split('').reversed.join(''));
    }

    void launchUrl(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    void showSnackBar(BuildContext context, String type) {
      var snackBar = SnackBar(
        content: Text("Sorry :( , $type was not found!"),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {},
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }

    Widget calenderFabButton = Container(
      width: 60.0,
      height: 60.0,
      child: FloatingActionButton(
        onPressed: () {
          setReminder();
        },
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.alarm,
          color: Colors.white,
        ),
      ),
    );

    double getExpandedHt() {
      double height = 0;
      if (widget.opportunity.title.length < 35)
        height = 300;
      else if (widget.opportunity.title.length >= 35 &&
          widget.opportunity.title.length < 70)
        height = 320;
      else if (widget.opportunity.title.length > 70) height = 340;
      return height;
    }

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: list.length,
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(

                  floating: true,
                  snap: false,
                  title:Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 220.0,
                              child:  _showTitle? Text(
                                utf8.decode(
                                    widget.opportunity.title.runes.toList()),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ) : null,
                            ),
                            FutureBuilder(
                              future: Provider.of<LoginProvider>(context).isSignedIn,
                              builder: (ctx,snapshot) {
                                if(snapshot.connectionState == ConnectionState.done){
                                  var isSignedIn = snapshot.data;
                                  if(isSignedIn){
                                    return IconButton(
                                        icon: isPressed
                                            ? Icon(
                                          Icons.bookmark,
                                          size: 30.0,
                                          color: Colors.white,
                                        )
                                            : Icon(
                                          Icons.bookmark_border,
                                          size: 30.0,
                                          color: Colors.white,
                                        ),
                                        onPressed:  toggleBookMarkStatus
                                    );
                                  }
                                }
                                return Container();
                              },
                            ) ,
                          ],
                        ),
                      ),
                  backgroundColor: Colors.black,
                  pinned: true,
                  expandedHeight: getExpandedHt(),
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // FlutterStatusbarcolor.setStatusBarColor(Colors.white);
                      // FlutterStatusbarTextColor.setTextColor(
                      //     FlutterStatusbarTextColor.dark);
                      Navigator.pop(context);
                    },
                  ),

                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(

                      child: Stack(
                        children: [
                      ColoredBox(
                        color: bgColor,
                        child: Column(
                          children: <Widget>[

                            Container(
                              child: Image(
                                height: 160,
                                width: width,
                                fit: BoxFit.fill,
                                image: NetworkImage(widget.opportunity.image),
                              ),
                            ),
                            SizedBox(
                              height: 2.0,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 12.0),
                                child: Text(
                                  widget.opportunity.opportunityType +
                                      " | " +
                                      widget.opportunity.region,
                                  style: TextStyle(
                                      fontSize: 14.0, color: _color,
                                  fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 12.0),
                                child: Text(
                                  utf8.decode(widget.opportunity.title.runes
                                      .toList()),
                                  style: TextStyle(
                                      fontSize: 21,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w900,
                                      color: _color),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0, right: 2.0),
                                    child: Icon(
                                      Icons.monetization_on,
                                      color: _color,
                                      size: 15.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.opportunity.fundingType,
                                      style: TextStyle(color: _color,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 2.0),
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: _color,
                                      size: 15.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Deadline: " +
                                          widget.opportunity.deadline,
                                      style: TextStyle(color: _color,fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 6.0, bottom: 8.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12.0, right: 2.0),
                                      child: Icon(
                                        Icons.timer,
                                        color: _color,
                                        size: 15.0,
                                      ),
                                    ),
                                    Text(
                                      widget.opportunity.timeLeft,
                                      style: TextStyle(color: _color,fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                          Container(
                            height: 160,
                            width: width,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin:Alignment.topLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      Colors.black12,
                                      Colors.black26
                                    ],
                                    tileMode: TileMode.repeated
                                )
                            ),
                          ),
                          // Positioned(
                          //   top: 130.0,
                          //   right: 30.0,
                          //   child: calenderFabButton,
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        isScrollable: true,
                        tabs: tabs,
                        labelColor:
                            (Theme.of(context).brightness == Brightness.light)
                                ? Colors.black
                                : Colors.white,
                        labelStyle: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w900,
                            color: (Theme.of(context).brightness ==
                                    Brightness.light)
                                ? Colors.black
                                : Colors.white),
                      ),
                    ),
                  ),
                ),
              ];
            },

            /*
            TabBar(
                      isScrollable: true,
                      tabs: tabs,
                      labelColor: (Theme.of(context).brightness == Brightness.light)
                          ? Colors.black
                          : Colors.white,
                      labelStyle: TextStyle(
                          color: (Theme.of(context).brightness == Brightness.light)
                              ? Colors.black
                              : Colors.white),
                    ),
                  ),
             */

            body: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : Colors.black,
                      child: TabBarView(
                        children: tabBars,
                      ),
                    ),
                  ),
                  Container(
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          elevation: 0.0,
                          color:
                              (Theme.of(context).brightness == Brightness.light)
                                  ? Colors.white
                                  : Colors.black,
                          child: Text(
                            "Apply URL",
                            style: TextStyle(fontSize: 12.0, color: _color,fontWeight: FontWeight.bold),
                          ),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Color(0xffE8E8E8)),
                              borderRadius: BorderRadius.circular(5.0)),
                          onPressed: () {
                            if (widget.opportunity.applyUrl == null ||
                                widget.opportunity.applyUrl.trim().length ==
                                    0) {
                              showSnackBar(context, "Apply URL");
                            } else {
                              launchUrl(widget.opportunity.applyUrl);
                            }
                          },
                        ),
                        SizedBox(
                          width: 50.0,
                        ),
                        RaisedButton(
                          elevation: 0.0,
                          color:
                              (Theme.of(context).brightness == Brightness.light)
                                  ? Colors.white
                                  : Colors.black,
                          child: Text(
                            "Official Link",
                            style: TextStyle(fontSize: 12.0, color: _color,fontWeight: FontWeight.bold),
                          ),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Color(0xffE8E8E8)),
                              borderRadius: BorderRadius.circular(5.0)),
                          onPressed: () {
                            if (widget.opportunity.url == null ||
                                widget.opportunity.url.trim().length == 0) {
                              showSnackBar(context, "Official Link");
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OfficialLinkView(
                                            opportunity: widget.opportunity,
                                          )));
                            }
                          },
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        color:
                            (Theme.of(context).brightness == Brightness.light)
                                ? Colors.white
                                : Colors.black,
                        border: Border(
                          top: BorderSide(width: 1.2, color: Colors.black26),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
//        } ,
//      ),
//    );
  }
}

class TabWrapper {
  String _title;
  String _content;

  TabWrapper(this._content, this._title);

  String get content => _content;

  set content(String value) {
    _content = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Theme.of(context).brightness == Brightness.light
          ? Color(0xffe3e3e3)
          : Colors.black,
      child: _tabBar,
    );
  }

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
