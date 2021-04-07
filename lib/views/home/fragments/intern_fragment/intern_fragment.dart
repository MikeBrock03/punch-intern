import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../helpers/app_localizations.dart';

class InternFragment extends StatefulWidget {

  final GlobalKey<ScaffoldState> globalScaffoldKey;
  InternFragment({ this.globalScaffoldKey });

  @override
  _InternFragmentState createState() => _InternFragmentState();
}

class _InternFragmentState extends State<InternFragment> with AutomaticKeepAliveClientMixin<InternFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: internFragmentBody(),
    );
  }

  Widget internFragmentBody(){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          SizedBox(height: 20),
          Center(child: Text(AppLocalizations.of(context).translate('interns_title'), style: TextStyle(fontSize: 20, color: Colors.grey[600]))),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
