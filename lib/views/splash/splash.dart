
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../config/app_config.dart';

class Splash extends StatefulWidget {

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeInUp(
          from: 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/app_icon.png',
                height: 100.0,
                width: 100.0,
                fit: BoxFit.fill,
              ),
              SizedBox(height: 50.0),
              Text(AppConfig.appName, style: TextStyle(color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
              SizedBox(height: 30.0),
              SizedBox(
                child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation(Colors.grey[400])
                ),
                height: 18.0,
                width: 18.0
              ),
            ],
          ),
        ),
      ),
    );
  }
}