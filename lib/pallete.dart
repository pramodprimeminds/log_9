import 'package:flutter/material.dart';

class Palette {
  static MaterialColor kToDark = MaterialColor(
    0xff06BFE1, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff1a436a), //10%
      100: Color(0xff1a436a), //20%
      200: Color(0xff1a436a), //30%
      300: Color(0xff1a436a), //40%
      400: Color(0xff1a436a), //50%
      500: Color(0xff5c261d), //60%
      600: Color(0xff451c16), //70%
      700: Color(0xff2e130e), //80%
      800: Color(0xff170907), //90%
      900: Color(0xff000000), //100%
    },
  );
}
