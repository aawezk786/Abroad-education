import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonContainer extends StatelessWidget {
  double _width, _height;
  BorderRadius _borderRadius;
  SkeletonContainer._(
      {double width = double.infinity,double height = double.infinity,double borderRadius=0}) :
        this._width=width,this._height=height,this._borderRadius=BorderRadius.all(Radius.circular(borderRadius));

  SkeletonContainer.squared(
  {double width,double height}) : this._(width:width,height:height);

  SkeletonContainer.circular(
  {double width,double height,double borderRadius=8}) :
    this._(width:width,height:height,borderRadius:borderRadius);

  @override
  Widget build(BuildContext context) => SkeletonAnimation(
    borderRadius: _borderRadius,
    child: Container(
      width: _width,
      height: _height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: _borderRadius
      ),
    ),
  );

}
