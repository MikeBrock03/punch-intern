
import 'package:cloud_firestore/cloud_firestore.dart';

class ClockFieldModel {
  String day;
  DateTime clockIn;
  DateTime clockOut;
  String location;
  Timestamp historyClockIn;
  Timestamp historyClockOut;

  ClockFieldModel({ this.day, this.clockIn, this.clockOut, this.location, this.historyClockIn, this.historyClockOut });

  Map<String, dynamic> toMap(){
    return{
      //'day':       this.day,
      'clockIn':   this.clockIn,
      'clockOut':  this.clockOut,
    };
  }

  Map<String, dynamic> toMapForFirebase(){
    return{
      //'day':       this.day,
      'clockIn':   this.clockIn != null ? Timestamp.fromDate(this.clockIn) : null,
      'clockOut':  this.clockOut != null ? Timestamp.fromDate(this.clockOut) : null,
    };
  }

  Map<String, dynamic> toMapForFirebaseHistory(){
    return{
      'clock_in':   this.historyClockIn ?? null,
      'clock_out':  this.historyClockOut ?? null,
      'location':   this.location,
    };
  }

  factory ClockFieldModel.fromJson(Map<String, dynamic> json) {
    return ClockFieldModel(
      historyClockIn:   json["clock_in"],
      historyClockOut:  json["clock_out"],
      location:         json["location"],
    );
  }

}