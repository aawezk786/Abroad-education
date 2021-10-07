import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ofy_flutter/models/banner.dart';
import 'package:ofy_flutter/models/opportunity.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OfficialLinkView extends StatefulWidget {
  final Opportunity opportunity;
  final Banners banner;
  OfficialLinkView({this.opportunity,this.banner});
  @override
  _OfficialLinkViewState createState() => _OfficialLinkViewState();
}

class _OfficialLinkViewState extends State<OfficialLinkView> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    //print("Aditya"+widget.banner.url);
    return Scaffold(
      appBar: widget.opportunity != null ? AppBar(
        title: Text(widget.opportunity.title.substring(0,29) + "..."),
      ) : null,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: WebView(
          initialUrl:  widget.opportunity != null ? widget.opportunity.url : widget.banner.url,
          onWebViewCreated: (WebViewController webViewController){
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}
