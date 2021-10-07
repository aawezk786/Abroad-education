import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';

class MyNativeAd extends StatefulWidget {
  final NativeAdmobType _adType;
  double _adWidth, _adHeight;

  MyNativeAd(this._adType, {double adWidth = 250, double adHeight}) {
    if (this._adType == NativeAdmobType.full) {
      _adWidth = adWidth;
      _adHeight = adHeight ?? 248;
    } else {
      this._adWidth = adWidth;
      this._adHeight = adHeight ?? 100;
    }
  }

  @override
  _MyNativeAdState createState() => _MyNativeAdState();
}

class _MyNativeAdState extends State<MyNativeAd> {
  final String nativeAdUnitId = "ca-app-pub-4469832093134965/1596203805";
  final _nativeAdController = NativeAdmobController();

  bool _showAd = true;
  StreamSubscription _subscription;

  @override
  void initState() {
    _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    super.initState();
  }

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        // print("TESTING AD LOADING");
        break;
      case AdLoadState.loadCompleted:
        setState(() {
          // print("TESTING AD DONE");
          _showAd = true;
        });
        break;
      case AdLoadState.loadError:
        setState(() {
          // print("TESTING AD ERROR");
          _showAd = false;
        });
        break;
    }
  }

  Widget NativeAdBuilder(BuildContext context) {
    var textColor = Colors.blueGrey;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: NativeAdmob(
          adUnitID: nativeAdUnitId,
          error: Center(child: Text("Failed to load")),
          controller: _nativeAdController,
          type: widget._adType,
          options: NativeAdmobOptions(
              headlineTextStyle: NativeTextStyle(
                fontSize: 14,
                color: textColor,
              ),
              adLabelTextStyle: NativeTextStyle(fontSize: 14, color: textColor),
              advertiserTextStyle:
                  NativeTextStyle(fontSize: 12, color: textColor),
              bodyTextStyle: NativeTextStyle(fontSize: 17, color: textColor))),
    );
  }

  @override
  Widget build(BuildContext context) {
    var bgColor = Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : Colors.white;
    return Visibility(
      visible: _showAd,
      child: Container(
        width: widget._adWidth,
        height: widget._adHeight,
        padding: widget._adType == NativeAdmobType.full
            ? const EdgeInsets.only(right: 5.0, left: 5.0)
            : null,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: widget._adType == NativeAdmobType.banner
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                  width: 0,
                ),
              )
            : null,
        child: widget._adType == NativeAdmobType.full
            ? Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: bgColor,
                child: NativeAdBuilder(context),
                elevation: 2,
                shadowColor: Colors.grey[300],
              )
            : NativeAdBuilder(context),
      ),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    _nativeAdController.dispose();
    print("TESTING DISPOSED");
    super.dispose();
  }
}
