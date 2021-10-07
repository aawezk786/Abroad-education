import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ofy_flutter/screens/bookmark_list.dart';
import 'package:ofy_flutter/screens/submissions.dart';
import 'package:ofy_flutter/utilities/LoginProvider.dart';
import 'package:ofy_flutter/utilities/theme.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  var isSignedIn;

  @override
  void initState() {
    isSignedIn=false;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    print("TESTING PROFILE REBUILD");
    final themeChange = Provider.of<DarkThemeProvider>(context, listen: false);
    final authProvider = Provider.of<LoginProvider>(context);

    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Align(
              alignment: Alignment.center,
              child: FutureBuilder(
                  future: authProvider.isSignedIn,
                  builder: (ctx,snapShot) {
                    if(snapShot.connectionState == ConnectionState.done) {
                      var isSignedInValue = snapShot.data;
                      return GestureDetector(
                        onTap: () {
                          if (isSignedInValue)
                            authProvider.signOut();
                          else
                            authProvider.signIn();
                        },
                        child: Text(
                          isSignedInValue ? "Sign Out" : "Sign In",
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).brightness == Brightness.light
                                  ? Colors.black87
                                  : Colors.white),
                        ),
                      );
                    }return CircularProgressIndicator();

                  }
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: Column(children: [
        SizedBox(
          height: 30.0,
        ),
        CircleAvatar(
            radius: 50.0,
            backgroundColor: Colors.blueGrey,
            backgroundImage: authProvider.imageUrl != null
                ? NetworkImage(authProvider?.imageUrl)
                : null),
        SizedBox(
          height: 15.0,
        ),
        Text(
          authProvider.username ?? "Guest",
          style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black54
                  : Colors.white60,
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            child: Align(
              alignment: Alignment.centerLeft,
            )),
        Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(authProvider.email ?? "")),
        SizedBox(
          height: 25.0,
        ),
        Card(
          elevation: 3.0,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SubmissionsScreen()));
            },
            child: ListTile(
              leading: Icon(Icons.present_to_all),
              title: Text("Submissions"),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 15.0,
              ),
            ),
          ),
        ),
        Card(
          elevation: 3.0,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BookmarkListScreen()));
            },
            child: ListTile(
              leading: Icon(Icons.collections_bookmark),
              title: Text("Bookmarks"),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 15.0,
              ),
            ),
          ),
        ),
        // Card(
        //   elevation: 3.0,
        //   child: GestureDetector(
        //     onTap: () {
        //       Navigator.push(context,
        //           MaterialPageRoute(
        //               builder: (context) => EditPreferences()));
        //     },
        //     child: ListTile(
        //       leading: Icon(Icons.favorite),
        //       title: Text("Edit Prefernces"),
        //       trailing: Icon(
        //         Icons.arrow_forward_ios,
        //         size: 15.0,
        //       ),
        //     ),
        //   ),
        // ),
        Card(
            elevation: 3.0,
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Dark Theme"),
                  Checkbox(
                      value: themeChange.darkTheme,
                      onChanged: (bool value) {
                        themeChange.darkTheme = value;
                      })
                ],
              ),
            )),
      ])),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
