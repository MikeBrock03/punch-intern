import 'package:flutter/material.dart';
import 'package:punch_app/helpers/app_localizations.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('profile'), style: TextStyle(fontSize: 18)),
        centerTitle: true,
        brightness: Brightness.dark,
      ),
      backgroundColor: Colors.white,
      body: profileBody(),
    );
  }

  Widget profileBody(){
    return Container();
  }
}
