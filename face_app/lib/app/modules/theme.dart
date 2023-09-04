import 'package:flutter/material.dart';

final appTheme = ThemeData(
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all(EdgeInsets.zero),
      overlayColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return Colors.black12;
        }
        return Colors.transparent;
      }),
    ),
  ),
  fontFamily: 'Montserrat SemiBold',
  primaryColor: const Color(0xff2D9CEA),
);

// final data = box.read('isData');
// final initRoute = (data == null || data == '') ? AppPages.INITIAL : Routes.HOME;
