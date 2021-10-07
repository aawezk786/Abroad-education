import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ofy_flutter/models/article_item.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

Color colorInUse = Colors.blue;
Color inactiveColor = Colors.white;

String selectedCategory;
String selectedSubCategory;
bool visible = false;
bool articleVisibility = false;

var categories = [];
var subcategories = [];
var visibleArticles = [];
var arr = [];

class ArticlePage extends StatefulWidget {
  final String fromScreen;
  ArticlePage({
    @required this.articlesToShow, this.fromScreen
  });
  final List articlesToShow;
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {

  List<ArticleItem> articlesList = [];

  @override
  void initState() {
    arr.clear();
    super.initState();
    //checkForDuplicates();
    articlesList = widget.articlesToShow;
    print(articlesList[0].heading);
    print(articlesList[0].category);
    print(articlesList[0].heading_link);
    print(articlesList[0].heading_type);
  }

  checkForDuplicates(){
    List temp = widget.articlesToShow;
    for (int i=0 ; i<temp.length ; i++){
      for (int j=0 ; j<temp.length ; j++){
        if (temp[i]['id'] == temp[j]['id']){
          temp.remove(temp[j]);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: widget.fromScreen == "YD" ? AppBar(
          centerTitle: true,
          title: Text("ofy"),
        ) : null,
          body: Container(
            color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
            //height: size.height * 0.45,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: widget.articlesToShow.length,
              itemBuilder: (context, index) {
                return
                  articlesList[index].heading_type
                    .toString()
                    .toLowerCase() ==
                    "video"
                    ?
                //Container(height: 50.0,color: Colors.red,) :
                VideoCard(
                  //size: size,
                  type: widget.articlesToShow[index]["heading_type"],
                  heading: widget.articlesToShow[index]["heading"],
                  url: widget.articlesToShow[index]["heading_link"],
                  img_url: widget.articlesToShow[index]["image_link"],
                ) :
                ArticleCard(
                  //size: size,
                  type: articlesList[index].heading_type,
                  heading: articlesList[index].heading,
                  url: articlesList[index].heading_link,
                  img_url: articlesList[index].image_link,
                );
              },
            ),
          )),
    );
  }
}

class ArticleCard extends StatefulWidget {
  const ArticleCard(
      {Key key,
        //@required this.size,
        @required this.heading,
        @required this.url,
        @required this.type,
        // ignore: non_constant_identifier_names
        @required this.img_url})
      : super(key: key);

  //final Size size;
  final String heading;
  final String url;
  // ignore: non_constant_identifier_names
  final String img_url;
  final String type;

  @override
  _ArticleCardState createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WikipediaExplorer(
                    url:widget.url,
                    heading: widget.heading,
                  )));
        });
      },
      child: Card(
        elevation: 2.0,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
          height: 110.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
//            boxShadow: [BoxShadow(
//              blurRadius: 5.0
//            )]
            //color: Colors.red
          ),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(widget.type,style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black38 : Colors.white60),),
                    ),
                    SizedBox(height: 10.0,),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width-110,
                        alignment: Alignment.centerLeft,
                        child: Text(widget.heading,style: TextStyle(fontSize: 15,color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),),
                      ),
                    )
                  ],
                ),
                Container(
                  height: 80.0,width: 80.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.blueGrey
                  ),
                  child: widget.img_url.isNotEmpty ? ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(widget.img_url),
                    ),
                  ) : Container(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WikipediaExplorer extends StatefulWidget {
  const WikipediaExplorer({
    this.url,
    this.heading,
  });
  final String heading;
  final String url;
  @override
  _WikipediaExplorerState createState() => _WikipediaExplorerState();
}

class _WikipediaExplorerState extends State<WikipediaExplorer> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.heading),
      ),
      body: WebView(
        initialUrl: widget.url,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}

class VideoCard extends StatefulWidget {
  const VideoCard(
      {Key key,
       // @required this.size,
        @required this.heading,
        @required this.url,
        @required this.type,
        // ignore: non_constant_identifier_names
        @required this.img_url})
      : super(key: key);

  //final Size size;
  final String heading;
  final String url;
  // ignore: non_constant_identifier_names
  final String img_url;
  final String type;

  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  List ytResult = [];

  @override
  void initState() {
    fetch();
    super.initState();
  }

  String getVideoID(String url) {
    url = url.replaceAll("https://www.youtube.com/watch?v=", "");
    url = url.replaceAll("https://m.youtube.com/watch?v=", "");
    return url;
  }

  Future getData() async {
    String id = getVideoID(widget.url);
    final response = await http.get(
        'https://www.googleapis.com/youtube/v3/videos?id=' +
            id +
            '&key=<API_KEY>&part=snippet');
    return jsonDecode(response.body);
  }

  fetch() async {
    await getData().then((value) {
      setState(() {
        ytResult.clear();
        ytResult.add(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
//      onTap: () async {
//        String url = widget.url;
//        if (await canLaunch(url)) {
//          await launch(url);
//        } else {
//          throw 'Could not launch $url';
//        }
//      },
      onTap: () {
        setState(() {
          YoutubeVideoId = getVideoID(widget.url);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => VideoPlayerr()));
        });
      },
      child: Card(
        elevation: 2.0,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
          height: 110.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            //color: Colors.red
          ),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(widget.type,style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black38 : Colors.white60),),
                    ),
                    SizedBox(height: 10.0,),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width-110,
                        alignment: Alignment.centerLeft,
                        child: Text(widget.heading,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Color(0xff474747) : Colors.white),),
                      ),
                    )
                  ],
                ),
                Container(
                  height: 80.0,width: 80.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.blueGrey
                  ),
                  child: widget.img_url.isNotEmpty ? ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image(
                      height: 70.0,
                      width: 70.0,
                      fit: BoxFit.fill,
                      image: NetworkImage(widget.img_url),
                    ),
                  ) : Container(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
String YoutubeVideoId;

class VideoPlayerr extends StatelessWidget {
  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: YoutubeVideoId,
    flags: YoutubePlayerFlags(
      hideControls: false,
      autoPlay: true,
      mute: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: _controller,
            ),
            builder: (context, player) {
              return Column(
                children: <Widget>[player],
              );
            },
          ),
        ),
      ),
    );
  }
}