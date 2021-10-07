/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:flutter/material.dart';
import 'package:ofy_flutter/groupMsg/services/DatabaseService.dart';
import 'screens/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'models/User.dart';
import 'services/AuthService.dart';
import 'package:firebase_core/firebase_core.dart';
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//
//   runApp(MyApp());
// }

class GroupsBase extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
    MultiProvider(
      providers: [
        StreamProvider<gUser>(create: (_)=> AuthService().user),
        StreamProvider<List<gUser>>(create: (_)=> DatabaseService().users),
      ],
      child: MaterialApp(
        theme: ThemeData.fallback(),
        title: "Tribly",
        debugShowCheckedModeBanner: false,
        home : HomeScreen(
        ),
      ),
    );
  }
}
