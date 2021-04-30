import 'package:flutter/material.dart';

const LargeTextSize = 26.0;
const MediumTextSize = 20.0;
const BodyTextSize = 16.0;

const String FontNameDefault = 'Roboto';

const AppBarTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  //fontWeight: FontWeight.w300,  // se definirmos weight no ficheiro pubspec.yaml
  fontSize: MediumTextSize,
  color: Colors.white,
);

const TitleTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  //fontWeight: FontWeight.w300,  // se definirmos weight no ficheiro pubspec.yaml
  fontSize: LargeTextSize,
  color: Colors.black,
);

const BodyTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  //fontWeight: FontWeight.w300,  // se definirmos weight no ficheiro pubspec.yaml
  fontSize: BodyTextSize,
  color: Colors.black,
);