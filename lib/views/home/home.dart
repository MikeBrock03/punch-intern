import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:punch_app/helpers/question_dialog.dart';
import '../../views/welcome/welcome.dart';
import '../../config/app_config.dart';
import '../../helpers/app_localizations.dart';
import '../../helpers/app_navigator.dart';
import '../../services/firebase_auth_service.dart';
import '../../views/profile/profile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final globalScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('app_title'), style: TextStyle(fontSize: 18)),
        centerTitle: true,
        brightness: Brightness.dark,
        leading: IconButton(
          tooltip: AppLocalizations.of(context).translate('profile'),
          icon: Icon(Icons.person),
          onPressed: () => AppNavigator.push(context: context, page: Profile()),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(
              tooltip: AppLocalizations.of(context).translate('logout'),
              icon: Icon(Icons.logout),
              onPressed: () => logout(),
            ),
          ),
        ],
      ),
      body: homeBody(),
    );
  }

  Widget homeBody(){
    return Center(

    );
  }

  void logout(){
    Future.delayed(Duration(milliseconds: 250), (){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return QuestionDialog(
            globalKey: globalScaffoldKey,
            title: AppLocalizations.of(context).translate('exit_from_account_description'),
            onYes: () async{
              await Future.delayed(Duration(milliseconds: 450));
              try{
                await Provider.of<FirebaseAuthService>(context, listen: false).signOut();
                AppNavigator.pushReplace(context: context, page: Welcome());
              }catch(error) {
                if (!AppConfig.isPublished) {
                  print('Error: $error');
                }
              }
            },
          );
        },
      );
    });
  }
}
