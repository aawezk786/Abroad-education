import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:ofy_flutter/screens/home.dart';
import 'package:ofy_flutter/services/selected_items.dart';
import 'package:ofy_flutter/utilities/LoginProvider.dart';
import 'package:ofy_flutter/utilities/theme.dart';
import 'package:ofy_flutter/utilities/theme_data.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(OfyApp());
}

class OfyApp extends StatefulWidget {
  @override
  _OfyAppState createState() => _OfyAppState();
}

class _OfyAppState extends State<OfyApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    SelectedItems.fetchLists();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(
        themeChangeProvider.darkTheme ? Colors.black : Colors.white);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(
        themeChangeProvider.darkTheme);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: themeChangeProvider,
        ),
        ChangeNotifierProvider(
          create: (_) => LoginProvider(),
        ),
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (ctx, darkThemeProvider, _) => MaterialApp(
          title: 'Tribly',
          debugShowCheckedModeBanner: false,
          theme: Styles.themeData(darkThemeProvider.darkTheme, ctx),
          home: Home(),
        ),
      ),
    );
  }
}
