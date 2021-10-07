import 'dart:convert';
import 'package:ofy_flutter/articles_dir/articles.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class JobDescScreen extends StatefulWidget {
  JobDescScreen(
      {@required this.companyName,
      @required this.url,
      @required this.desc,
      @required this.logoUrl});

  final String companyName;
  final String desc;
  final String url;
  final String logoUrl;
  @override
  _JobDescScreenState createState() => _JobDescScreenState();
}

class _JobDescScreenState extends State<JobDescScreen> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: size.height,
          width: size.width,
          child: WikipediaExplorer(
            heading: widget.companyName,
            url: widget.url,
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
