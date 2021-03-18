import 'package:flutter/material.dart';
import '../../helpers/app_localizations.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context).translate('login')),
      ),
      body: loginBody(),
    );
  }

  Widget loginBody(){
    return Container(
      child: Text('login'),
    );
  }
}
