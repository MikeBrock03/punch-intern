import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../helpers/loading_dialog.dart';
import '../../../../config/app_config.dart';
import '../../../../services/firestore_service.dart';
import '../../../../database/storage.dart';
import '../../../../models/user_model.dart';
import '../../../../view_models/user_view_model.dart';
import '../../../../helpers/message.dart';
import '../../../../helpers/question_dialog.dart';
import '../../../../view_models/company_view_model.dart';
import '../../../../helpers/app_localizations.dart';

class PunchFragment extends StatefulWidget {
  final GlobalKey<ScaffoldState> globalScaffoldKey;
  PunchFragment({this.globalScaffoldKey});

  @override
  _PunchFragmentState createState() => _PunchFragmentState();
}

class _PunchFragmentState extends State<PunchFragment>
    with AutomaticKeepAliveClientMixin<PunchFragment> {
  int clockSt = -1;
  final Storage storage = new Storage();
  final DateTime date = DateTime.now();
  String dateOfToday;
  String day;

  @override
  void initState() {
    super.initState();
    checkClock();
    dateOfToday = '${date.year}-${date.month}-${date.day}';
  }

  void checkClock() {
    day = DateFormat('EEEE').format(date).substring(0, 3).toLowerCase();

    UserModel model =
        Provider.of<UserViewModel>(context, listen: false).userModel;

    if (model.clocks[day]['clock_in'] == null &&
        model.clocks[day]['clock_out'] == null) {
      setState(() {
        clockSt = 0;
      });
    } else {
      final format = DateFormat("HH:mm");
      DateTime clockIn;
      DateTime clockOut;
      DateTime clockInDate;
      DateTime clockOutDate;

      if (model.clocks[day]['clock_in'] != null) {
        clockIn = format.parse(
            DateFormat.Hm().format(model.clocks[day]['clock_in'].toDate()));
        clockInDate =
            DateTime.parse(model.clocks[day]['clock_in'].toDate().toString());
      }

      if (model.clocks[day]['clock_out'] != null) {
        clockOut = format.parse(
            DateFormat.Hm().format(model.clocks[day]['clock_out'].toDate()));
        clockOutDate =
            DateTime.parse(model.clocks[day]['clock_out'].toDate().toString());
      }

      if (clockOut != null &&
          clockOutDate.year == date.year &&
          clockOutDate.day == date.day) {
        setState(() {
          clockSt = 0;
        });
      } else {
        if (clockInDate.year == date.year && clockInDate.day == date.day) {
          setState(() {
            clockSt = 1;
          });
        } else {
          setState(() {
            clockSt = 0;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: punchFragmentBody(),
    );
  }

  Widget punchFragmentBody() {
    String companyLogo = '';
    String companyName = '';

    if (Provider.of<CompanyViewModel>(context, listen: false).logoURL != null &&
        Provider.of<CompanyViewModel>(context, listen: false).logoURL != '') {
      companyLogo =
          Provider.of<CompanyViewModel>(context, listen: false).logoURL;
    }

    if (Provider.of<CompanyViewModel>(context, listen: false).companyName !=
            null &&
        Provider.of<CompanyViewModel>(context, listen: false).companyName !=
            '') {
      companyName =
          Provider.of<CompanyViewModel>(context, listen: false).companyName;
    }

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          SizedBox(height: 20),
          Center(
              child: Text(
                  AppLocalizations.of(context).translate(
                      clockSt == 1 ? 'good_to_checked_in' : 'interns_title'),
                  style: TextStyle(fontSize: 20, color: Colors.grey[600]))),
          SizedBox(height: 30),
          Expanded(
              child: GestureDetector(
            onTap: () async {
              LocationPermission permission =
                  await Geolocator.checkPermission();
              if (permission == LocationPermission.whileInUse ||
                  permission == LocationPermission.always) {
                clockQuestion();
              } else {
                LocationPermission permission =
                    await Geolocator.requestPermission();
                if (permission.toString() ==
                    'LocationPermission.deniedForever') {
                  Message.show(widget.globalScaffoldKey,
                      'Please updates the location permission in the App settings');
                }
                if (permission == LocationPermission.whileInUse ||
                    permission == LocationPermission.always) {
                  clockQuestion();
                }
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 150,
                    height: 150,
                    margin: EdgeInsets.only(bottom: 30),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: clockSt == 1
                              ? Colors.green
                              : Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: companyLogo != null && companyLogo != ''
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              placeholder: (context, url) =>
                                  Container(color: Colors.grey[200]),
                              imageUrl: companyLogo,
                              width: 100,
                              height: 100,
                              fit: BoxFit.fitHeight,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                                padding: EdgeInsets.all(15),
                                color: Colors.grey[200],
                                child: Center(
                                    child: Text(companyName,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[500],
                                            decoration: TextDecoration.none),
                                        textAlign: TextAlign.center))))),
                Text(
                    AppLocalizations.of(context).translate(
                        clockSt == 1 ? 'tap_to_punch_out' : 'tap_to_punch'),
                    style: TextStyle(fontSize: 13, color: Colors.grey[500])),
                SizedBox(height: 80)
              ],
            ),
          ))
        ],
      ),
    );
  }

  void clockQuestion() {
    if (clockSt == 1) {
      Future.delayed(
        Duration(milliseconds: 250),
        () {
          performClockOut();
        },
      );
    } else if (clockSt == 0) {
      performClockIn();
    }
  }

  void performClockOut() async {
    try {
      dynamic result =
          await Provider.of<FirestoreService>(context, listen: false)
              .updateClocks(
                  uID: Provider.of<UserViewModel>(context, listen: false).uID,
                  type: 'clock_out',
                  day: day,
                  location: '',
                  dateOfToday: dateOfToday);

      await Future.delayed(Duration(milliseconds: 300));

      if (result is bool && result) {
        setState(() {
          clockSt = 0;
        });
      }
    } catch (error) {
      if (!AppConfig.isPublished) {
        print('Error: $error');
      }

      Message.show(widget.globalScaffoldKey,
          AppLocalizations.of(context).translate('clock_out_fail'));
    }
  }

  void performClockIn() async {
    String id = Provider.of<UserViewModel>(context, listen: false).uID;

    Future.delayed(Duration(milliseconds: 800), () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialog();
        },
      );
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      dynamic result =
          await Provider.of<FirestoreService>(context, listen: false)
              .updateClocks(
                  uID: id,
                  type: 'clock_in',
                  day: day,
                  location: '${position.latitude},${position.longitude}',
                  dateOfToday: dateOfToday);

      await Future.delayed(Duration(milliseconds: 1500), () {
        Navigator.pop(context);
      });
      await Future.delayed(Duration(milliseconds: 500));

      if (result is bool && result) {
        setState(() {
          clockSt = 1;
        });
      }
    } catch (error) {
      if (!AppConfig.isPublished) {
        print('Error: $error');
      }

      await Future.delayed(Duration(milliseconds: 1500), () {
        Navigator.pop(context);
      });
      await Future.delayed(Duration(milliseconds: 800), () {
        Message.show(widget.globalScaffoldKey,
            AppLocalizations.of(context).translate('clock_in_fail'));
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
