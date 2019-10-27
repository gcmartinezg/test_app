import 'package:flutter/material.dart';
import 'package:test_firebase/pages/root_page.dart';
import 'package:test_firebase/services/authentication.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'Baby Names',
     debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new RootPage(auth: new Auth())
   );
 }

}