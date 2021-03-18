
import 'dart:io';
import 'package:flutter/material.dart';
import 'custom_page_route.dart';

class AppNavigator{

  static void push({ @required BuildContext context, @required Widget page }){
    if (Platform.isAndroid) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    }else{
      Navigator.push(context, PageTransition(type: PageTransitionType.downToUpWithFade, child: page));
    }
  }

  static void pushReplace({ @required BuildContext context, @required Widget page }){
    if (Platform.isAndroid) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
    }else{
      Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.downToUpWithFade, child: page));
    }
  }

}