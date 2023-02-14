import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:log_9_mobility/login.dart';
import 'package:log_9_mobility/splash.dart';
import 'form_view.dart';
import 'pallete.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  // DeviceOrientation.portraitDown,
  // DeviceOrientation.portraitUp ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Palette.kToDark,
        // backgroundColor: Color.fromARGB(255, 236, 236, 236),
      ),
      debugShowCheckedModeBanner: false,
      home: Form_view(),
    );
  }
}
