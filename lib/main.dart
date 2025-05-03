


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/auth/login.dart';
import 'app/auth/sign_up.dart';
import 'app/home.dart';
import 'app/notes/add_notes.dart';
import 'app/notes/edit_notes.dart';
late SharedPreferences sharedPref;

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref=await SharedPreferences.getInstance();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute:sharedPref.getString("id")==null ?  "login" :"home",
      routes: {
        "login": (context) => Login(),
        "signUp": (context) => SignUp(),
        "home": (context) => Home(),
        "addNotes": (context) => AddNotes(),
        "editNote": (context) => EditNote(),
      },
      // home: SignUp(),
    );
  }
}
