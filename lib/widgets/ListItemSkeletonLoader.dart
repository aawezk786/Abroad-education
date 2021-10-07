import 'package:flutter/material.dart';
import 'package:ofy_flutter/widgets/SkeletonContainer.dart';

class ListItemSkeletonLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bgColor = Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white;
    var titleTextColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
    var bodyTextColor = Theme.of(context).brightness == Brightness.dark ? Colors.white: Color.fromRGBO(56,56,56,10.0);
    double iconSize =15;
    double iconFontSize = 12;

    return Column(children: [
      SizedBox(
        height: 5.0,
        width: 2.0,
      ),
      Container(
        padding: const EdgeInsets.only(top: 10,bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
            width: 0,
          ),
          //  color: Colors.red,
          color: bgColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 0.5,
              blurRadius: 3.5,
              offset: Offset(0, 0), //(x,y)
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 9.0),
                child: SkeletonContainer.circular(width: 50,height: iconFontSize,)
              ),
              SizedBox(height:5),
              Container(
                      padding: const EdgeInsets.only(left: 9.0),
                      width: MediaQuery.of(context).size.width - 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SkeletonContainer.circular(
                            width: MediaQuery.of(context).size.width*0.6,
                            height: iconFontSize,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SkeletonContainer.circular(
                            width: MediaQuery.of(context).size.width*0.4,
                            height: iconFontSize,
                          ),
                          SizedBox(
                            height: 5,
                          ),

                        ],
                      )),
            ],
          ),
            SkeletonContainer.circular(width: 65,height: 65,borderRadius: 4),
          ]
        ),
      ),
      SizedBox(
            height: 7.0,
          )

    ]);
  }
}
