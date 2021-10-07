import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loading_animations/loading_animations.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class JobsScreen extends StatefulWidget {
  @override
  _JobsScreenState createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  Future getData() async {
    final response =
        await http.get('https://jobs.github.com/positions.json?location=india');
    return jsonDecode(response.body);
  }

  var jobs = [];

  @override
  void initState() {
    fetch();
    super.initState();
  }

  fetch() async {
    await getData().then((value) {
      setState(() {
        if(!mounted)
           return
        jobs = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'Jobs in India',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          child: Center(
            child: jobs.length == 0
                ? LoadingFlipping.square(
                    borderColor: Colors.cyan,
                    size: 30.0,
                  )
                : ListView.builder(
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      return JobCard(
                        size: size,
                        companyName: jobs[index]['company'],
                        title: jobs[index]['title'],
                        type: jobs[index]['type'],
                        location: jobs[index]['location'],
                        urlLink: jobs[index]['url'],
                        desc: jobs[index]['description'],
                        logoUrl: jobs[index]['company_logo'],
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}

class JobCard extends StatefulWidget {
  const JobCard(
      {Key key,
      @required this.size,
      @required this.companyName,
      @required this.title,
      @required this.type,
      @required this.location,
      @required this.urlLink,
      @required this.logoUrl,
      @required this.desc})
      : super(key: key);

  final Size size;
  final String companyName;
  final String title;
  final String type;
  final String location;
  final String urlLink;
  final String desc;
  final String logoUrl;

  @override
  _JobCardState createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        width: widget.size.width * 0.9,
//            height: size.height * 0.33,
        decoration: BoxDecoration(
          color: Colors.orangeAccent.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Company Name :',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FittedBox(
                child: Container(
                  child: Text(
                    widget.companyName,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              Text(
                'Title :',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FittedBox(
                child: Container(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              Text(
                'Type :',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.type,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              Text(
                'Location :',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.location,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              Row(
                children: [
                  Spacer(),
                  RaisedButton(
                    onPressed: () async {
                      String url = widget.urlLink;
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Text(
                      'Know More',
                    ),
                  ),
                  Spacer(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
