import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:ofy_flutter/screens/home_page.dart';
import 'package:ofy_flutter/screens/notification_page.dart';
import 'package:ofy_flutter/screens/profile_page.dart';
import 'package:ofy_flutter/screens/search_page.dart';
import 'package:ofy_flutter/screens/youth_deck.dart';
import 'package:provider/provider.dart';
import 'package:ofy_flutter/utilities/theme.dart';
import 'package:ofy_flutter/groupMsg/groupMain.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> _screens = [
    HomePage(),
    SearchPage(),
    YouthDeckPage(),
    // NotificationPage(),
    ProfilePage()
  ];
  PageController _pageController = PageController();

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  int _selectedIndex = 0;
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    FlutterStatusbarcolor.setStatusBarColor(themeChange.darkTheme ? Colors.black : Colors.white);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(themeChange.darkTheme);

    return Scaffold(
      body: PageView(
        children: _screens,
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),

      // body: IndexedStack(
      //   children: _screens,
      //   index: _selectedIndex,
      // ),
      bottomNavigationBar: BottomNavigationBar(

        items: [
          BottomNavigationBarItem(
              title: Text(
                "Home",
                style: TextStyle(
                    color: _selectedIndex == 0 ? Colors.blue : Colors.grey),
              ),
              icon: Icon(
                Icons.home,
                color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
              )),
          BottomNavigationBarItem(
              title: Text(
                "Search",
                style: TextStyle(
                    color: _selectedIndex == 1 ? Colors.blue : Colors.grey),
              ),
              icon: Icon(Icons.search,
                  color: _selectedIndex == 1 ? Colors.blue : Colors.grey)),

          BottomNavigationBarItem(
              title: Text(
                "Youth Deck",
                style: TextStyle(
                    color: _selectedIndex == 2 ? Colors.blue : Colors.grey),
              ),
              icon: Icon(Icons.desktop_mac,
                  color: _selectedIndex == 2 ? Colors.blue : Colors.grey)),


          BottomNavigationBarItem(
              title: Text(
                "Notification",
                style: TextStyle(
                    color: _selectedIndex == 2 ? Colors.blue : Colors.grey),
              ),
              icon: Icon(
                Icons.notifications,
                color: _selectedIndex == 2 ? Colors.blue : Colors.grey,
              )),
          BottomNavigationBarItem(
              title: Text(
                "Profile",
                style: TextStyle(
                    color: _selectedIndex == 3 ? Colors.blue : Colors.grey),
              ),
              icon: Icon(Icons.person,
                  color: _selectedIndex == 3 ? Colors.blue : Colors.grey)),
        ],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
