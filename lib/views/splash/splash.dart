
import 'package:animate_do/animate_do.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../config/app_config.dart';
import '../../helpers/app_navigator.dart';
import '../welcome/welcome.dart';

class Splash extends StatefulWidget {

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  final splashImage = Image.asset('assets/images/app_icon.png');

  @override
  void didChangeDependencies() {
    precacheImage(splashImage.image, context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    checkLogin(context);
  }

  void checkLogin(BuildContext context) async{
    await Future.delayed(Duration(milliseconds: 3000));
    try{
      AppNavigator.pushReplace(context: context, page: Welcome());
    }catch(error){
      if(!AppConfig.isPublished){
        print('Error: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            top: 0,
            child: Diagonal(
              clipHeight: 150.0,
              axis: Axis.horizontal,
              position: DiagonalPosition.BOTTOM_LEFT,

              child: Container(
                color: AppColors.primaryColor,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.85,
              ),
            ),
          ),

          Center(
            child: FadeInDown(
              from: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Container(
                    width: 130,
                    height: 130,
                    //padding: EdgeInsets.all(2),
                    child: Image.asset('assets/images/app_icon.png'),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 15,
                            offset: Offset(0, 1), // changes position of shadow
                          )
                        ]
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Text(AppConfig.appName, style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.normal)),
                  SizedBox(height: 30.0),

                ],
              ),
            ),
          ),

          Positioned(
            bottom: 50,
            child: FadeInUp(
              from: 10,
              child: SizedBox(
                  child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation(AppColors.primaryColor)
                  ),
                  height: 20.0,
                  width: 20.0
              ),
            ),
          ),
        ],
      ),
    );
  }
}