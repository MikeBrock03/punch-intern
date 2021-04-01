import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../helpers/app_localizations.dart';

class EmployerFragment extends StatefulWidget {

  final GlobalKey<ScaffoldState> globalScaffoldKey;
  EmployerFragment({ this.globalScaffoldKey });

  @override
  _EmployerFragmentState createState() => _EmployerFragmentState();
}

class _EmployerFragmentState extends State<EmployerFragment> with AutomaticKeepAliveClientMixin<EmployerFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: internFragmentBody(),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addEmployer',
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        child: Icon(Icons.add, size: 25,),
        onPressed: () {

        },
      ),
    );
  }

  Widget internFragmentBody(){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          SizedBox(height: 20),
          Center(child: Text(AppLocalizations.of(context).translate('company_employers'), style: TextStyle(fontSize: 20, color: Colors.grey[600]))),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
