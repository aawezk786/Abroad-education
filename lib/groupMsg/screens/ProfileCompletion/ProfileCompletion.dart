import 'package:flutter/material.dart';
import 'P2.dart';
import 'profileGlobal.dart';

class ProfileCompletion extends StatefulWidget {
  @override
  _ProfileCompletionState createState() => _ProfileCompletionState();
}

class _ProfileCompletionState extends State<ProfileCompletion> {

  final phone = TextEditingController();
  final city= TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    phone.dispose();
    city.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Complete Your Profile"),
            SizedBox(width: 10,),
            CircleAvatar(child: Icon(Icons.looks_one)),
            Icon(Icons.looks_two),
            Icon(Icons.looks_3),
            


          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              child: TextField(
                controller: phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'phone',
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: 300,
              child: TextField(
                controller: city,

                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'City',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 45),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 200,
                      child: ElevatedButton(onPressed: (){

                        user_city = city.text;
                        user_phone =phone.text;


                        Navigator.push(
                          context,MaterialPageRoute(builder: (context)=>P2())
                        );

                      }, child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Next"),
                          Icon(Icons.navigate_next)

                        ],
                      ))),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}