import 'package:flutter/material.dart';
import 'package:log_9/login.dart';
import 'package:log_9/pallete.dart';
import 'package:log_9/splash.dart';
import 'package:log_9/thankyou.dart';
import 'form_view.dart';
import 'location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      
      theme: ThemeData(
      primarySwatch: Palette.kToDark,
      // backgroundColor: Color.fromARGB(255, 236, 236, 236),
      ),
      
      debugShowCheckedModeBanner: false,
      home:  Splash(),
    );
  }
}

