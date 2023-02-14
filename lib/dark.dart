// import 'package:flutter/cupertino.dart';

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   Brightness? _brightness;

//   @override
//   void initState() {
//     WidgetsBinding.instance.addObserver(this);
//     _brightness = WidgetsBinding.instance.window.platformBrightness;
//     super.initState();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangePlatformBrightness() {
//     if (mounted) {
//       setState(() {
//         _brightness = WidgetsBinding.instance.window.platformBrightness;
//       });
//     }

//     super.didChangePlatformBrightness();
//   }

//   CupertinoThemeData get _lightTheme =>
//       CupertinoThemeData(brightness: Brightness.light, /* light theme settings */);

//   CupertinoThemeData get _darkTheme => CupertinoThemeData(
//         brightness: Brightness.dark, /* dark theme settings */
//       );

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoApp(
//       title: 'Demo App',
//       theme: _brightness == Brightness.dark ? _darkTheme : _lightTheme,
     
//     );
//   }
// }


import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

final dbBytes =  rootBundle.load('assets/file'); // <= your ByteData

//=======================
Future<File> writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = tempPath + '/file_01.tmp'; // file_01.tmp is dump file, can be anything
    return new File(filePath).writeAsBytes(
       buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}