import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../helpers/app_localizations.dart';
import '../../helpers/app_navigator.dart';
import '../../models/user_model.dart';
import '../../views/intern_form/intern_form.dart';

class ClocksDetail extends StatefulWidget {
  UserModel intern;
  ClocksDetail({this.intern});

  @override
  _ClocksDetailState createState() => _ClocksDetailState();
}

class _ClocksDetailState extends State<ClocksDetail> {
  final _globalScaffoldKey = GlobalKey<ScaffoldState>();
  final DateTime date = DateTime.now();
  String today;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    today = DateFormat('EEEE').format(date).substring(0, 3).toLowerCase();

    return Scaffold(
      key: _globalScaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.primaryColor),
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate('clock_in_out'),
            style: TextStyle(fontSize: 18, color: AppColors.primaryColor)),
        centerTitle: true,
        brightness: Brightness.dark,
      ),
      backgroundColor: Colors.white,
      body: clocksDetailBody(),
    );
  }

  Widget clocksDetailBody() {
    String scheduleClockIn = '-';
    String scheduleClockOut = '-';

    if (widget.intern.schedules[today]['clock_in'] != null &&
        widget.intern.schedules[today]['clock_in'] != '') {
      scheduleClockIn =
          '${widget.intern.schedules[today]['clock_in'].toDate().hour.toString().padLeft(2, '0')}:${widget.intern.schedules[today]['clock_in'].toDate().minute.toString().padLeft(2, '0')}' ??
              '-';
    }

    if (widget.intern.schedules[today]['clock_out'] != null &&
        widget.intern.schedules[today]['clock_out'] != '') {
      scheduleClockOut =
          '${widget.intern.schedules[today]['clock_out'].toDate().hour.toString().padLeft(2, '0')}:${widget.intern.schedules[today]['clock_out'].toDate().minute.toString().padLeft(2, '0')}' ??
              '-';
    }

    String clockedIn = '-';
    String clockedOut = '-';

    if (widget.intern.clocks[today]['clock_in'] != null &&
        widget.intern.clocks[today]['clock_in'] != '') {
      clockedIn = DateFormat.yMMMd()
          .add_jm()
          .format(widget.intern.clocks[today]['clock_in'].toDate());
    }

    if (widget.intern.clocks[today]['clock_out'] != null &&
        widget.intern.clocks[today]['clock_out'] != '') {
      clockedOut = DateFormat.yMMMd()
          .add_jm()
          .format(widget.intern.clocks[today]['clock_out'].toDate());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Hero(
              tag: widget.intern.uID,
              child: Container(
                  width: 130,
                  height: 130,
                  margin: EdgeInsets.only(top: 50),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(600),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: widget.intern.imageURL != null &&
                          widget.intern.imageURL != ''
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(600),
                          child: CachedNetworkImage(
                            placeholder: (context, url) =>
                                Container(color: Colors.grey[200]),
                            imageUrl: widget.intern.imageURL,
                            width: 130,
                            height: 130,
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(600),
                          child: Container(
                              color: Colors.grey[200],
                              child: Center(
                                  child: Text(widget.intern.firstName,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[500],
                                          decoration: TextDecoration.none)))))),
            ),
          ),
          SizedBox(height: 20),
          Text('${widget.intern.firstName} ${widget.intern.lastName}',
              style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          SizedBox(height: 20),
          Divider(),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
                controller: ScrollController(),
                physics: BouncingScrollPhysics(),
                children: [
                  Column(children: [
                    Text(
                        '${AppLocalizations.of(context).translate('today')}\'s ${AppLocalizations.of(context).translate('work_schedule')}',
                        style:
                            TextStyle(fontSize: 18, color: Colors.grey[600])),
                    SizedBox(height: 25),
                    Text('$scheduleClockIn to $scheduleClockOut',
                        style:
                            TextStyle(fontSize: 16, color: Colors.grey[500])),
                    SizedBox(height: 50),
                    Text(
                        '${widget.intern.firstName} ${AppLocalizations.of(context).translate('clocked_in_at').toLowerCase()}',
                        style:
                            TextStyle(fontSize: 18, color: Colors.grey[600])),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        clockedIn != '-'
                            ? Row(
                                children: [
                                  Icon(Icons.access_time_outlined,
                                      color: Colors.green[500], size: 20),
                                  SizedBox(width: 10),
                                ],
                              )
                            : Container(),
                        Text('$clockedIn',
                            style: TextStyle(
                                fontSize: 16, color: Colors.green[500])),
                      ],
                    ),
                    SizedBox(height: 50),
                    Text(
                        '${widget.intern.firstName} ${AppLocalizations.of(context).translate('clocked_out_at').toLowerCase()}',
                        style:
                            TextStyle(fontSize: 18, color: Colors.grey[600])),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        clockedOut != '-'
                            ? Row(
                                children: [
                                  Icon(Icons.access_time_outlined,
                                      color: Colors.grey[500], size: 20),
                                  SizedBox(width: 10),
                                ],
                              )
                            : Container(),
                        Text('$clockedOut',
                            style: TextStyle(
                                fontSize: 16, color: Colors.green[500])),
                      ],
                    ),
                    SizedBox(height: 50),
                    Text(
                        '${widget.intern.firstName} ${AppLocalizations.of(context).translate('is_at').toLowerCase()}',
                        style:
                            TextStyle(fontSize: 18, color: Colors.grey[600])),
                    SizedBox(height: 25),
                    Text(
                        widget.intern.address != null &&
                                widget.intern.address != ''
                            ? widget.intern.address
                            : AppLocalizations.of(context)
                                .translate('no_address'),
                        style:
                            TextStyle(fontSize: 16, color: Colors.grey[500])),
                    SizedBox(height: 25),
                  ])
                ]),
          )
        ],
      ),
    );
  }
}
