import 'package:flutter/material.dart';
import '../../helpers/app_localizations.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context).translate('register')),
      ),
      body: registerBody(),
    );
  }

  Widget registerBody(){
    return Container(
      child: Text('register'),
    );
  }
}
