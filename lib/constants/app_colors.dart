import 'package:flutter/material.dart';

class AppColors {

  static final Color primaryColor      = Color(0xff1b404c);
  static final Color primaryDarkColor  = Color(0xff15313b);
  static final Color accentColor       = Color(0xff143039);
  static final Color menuItemColor     = Color(0xff35849c);
  static final Color menuLineColor     = Color(0xff112930);
  static final Color white             = Colors.white;
  static final Color boxShadow         = Colors.grey.withOpacity(0.5);
  static final Color lightGrey         = Colors.grey[400];
  static final Color lightText         = Colors.grey[300];
  static final Color normalText        = Colors.grey[500];

  static final MaterialColor materialAccentColor = MaterialColor(0xff143039, _materialAccentColorMap);


  static Map<int, Color> _materialAccentColorMap = {
     50:Color.fromRGBO(1,126,254, .1),
    100:Color.fromRGBO(1,126,254, .2),
    200:Color.fromRGBO(1,126,254, .3),
    300:Color.fromRGBO(1,126,254, .4),
    400:Color.fromRGBO(1,126,254, .5),
    500:Color.fromRGBO(1,126,254, .6),
    600:Color.fromRGBO(1,126,254, .7),
    700:Color.fromRGBO(1,126,254, .8),
    800:Color.fromRGBO(1,126,254, .9),
    900:Color.fromRGBO(1,126,254,  1),
  };

}