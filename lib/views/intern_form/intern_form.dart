
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:provider/provider.dart';
import 'components/avatar_picker.dart';
import 'components/time_picker_field.dart';
import '../../view_models/interns_view_model.dart';
import '../../view_models/companies_view_model.dart';
import '../../services/firebase_storage.dart';
import '../../helpers/loading_dialog.dart';
import '../../services/firebase_auth_service.dart';
import '../../models/user_model.dart';
import '../../services/firestore_service.dart';
import '../../view_models/user_view_model.dart';
import '../../helpers/fading_edge_scrollview.dart';
import '../../helpers/app_text_field.dart';
import '../../config/app_config.dart';
import '../../helpers/app_localizations.dart';
import '../../helpers/message.dart';

class InternForm extends StatefulWidget {

  final UserModel userModel;
  final Function() onFinish;

  InternForm({ this.userModel, this.onFinish });

  @override
  _InternFormState createState() => _InternFormState();
}

class _InternFormState extends State<InternForm> {

  final _formKey = GlobalKey<FormState>();
  final _globalScaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();

  String companyID, companyName, firstName, lastName, email, imageUrl;

  DateTime satInTime, satOutTime, sunInTime, sunOutTime, monInTime, monOutTime,
      tusInTime, tusOutTime, wedInTime, wedOutTime, thiInTime, thiOutTime,
      friInTime, friOutTime;

  final now = new DateTime.now();

  bool submitSt = true;

  @override
  void initState() {
    super.initState();

    if(widget.userModel != null){
      companyID = widget.userModel.companyID;
      companyName = widget.userModel.companyName;
      firstName = widget.userModel.firstName;
      lastName = widget.userModel.lastName;
      email = widget.userModel.email;
      imageUrl = widget.userModel.imageURL != null && widget.userModel.imageURL != '' ? widget.userModel.imageURL : null;

      print('sssss: ${widget.userModel.schedules['sun']['clock_in']}');
      print('sssss: ${widget.userModel.schedules['sun']['clock_out']}');

      sunInTime = widget.userModel.schedules['sun']['clock_in']?.toDate();
      sunOutTime = widget.userModel.schedules['sun']['clock_out']?.toDate();

      monInTime = widget.userModel.schedules['mon']['clock_in']?.toDate();
      monOutTime = widget.userModel.schedules['mon']['clock_out']?.toDate();

      tusInTime = widget.userModel.schedules['tue']['clock_in']?.toDate();
      tusOutTime = widget.userModel.schedules['tue']['clock_out']?.toDate();

      wedInTime = widget.userModel.schedules['wed']['clock_in']?.toDate();
      wedOutTime = widget.userModel.schedules['wed']['clock_out']?.toDate();

      thiInTime = widget.userModel.schedules['thu']['clock_in']?.toDate();
      thiOutTime = widget.userModel.schedules['thu']['clock_out']?.toDate();

      friInTime = widget.userModel.schedules['fri']['clock_in']?.toDate();
      friOutTime = widget.userModel.schedules['fri']['clock_out']?.toDate();

      satInTime = widget.userModel.schedules['sat']['clock_in']?.toDate();
      satOutTime = widget.userModel.schedules['sat']['clock_out']?.toDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusWatcher(
      child: Scaffold(
        key: _globalScaffoldKey,
        appBar: AppBar(
          title: Text( widget.userModel != null ? AppLocalizations.of(context).translate('edit') + ' ' + widget.userModel.firstName : AppLocalizations.of(context).translate('add_intern'), style: TextStyle(fontSize: 18)),
          centerTitle: true,
          brightness: Brightness.dark,
          actions: [
            TextButton(
              onPressed: () {
                if(submitSt){
                  if(widget.userModel != null){
                    updateProfile();
                  }else{
                    submitForm();
                  }
                }
              },
              style: TextButton.styleFrom(
                shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
                primary: Colors.white,
              ),
              child: Text(AppLocalizations.of(context).translate('save'), style: TextStyle(color: Colors.white, fontSize: 15)),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: internFormBody(),
      ),
    );
  }

  Widget internFormBody(){
    return FadingEdgeScrollView.fromSingleChildScrollView(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        controller: scrollController,
        child: FadeInUp(
          from: 10,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 40, 12, 12),
            child: Column(
              children: [

                Center(child: SizedBox(width: 180, height: 180,child: AvatarPicker(imageURL: imageUrl, enabled: submitSt, onImageCaptured: (path){
                  setState(() {
                    imageUrl = path;
                  });
                }))),

                Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        SizedBox(height: 25),

                        AppTextField(
                          isEnable: submitSt,
                          labelText: AppLocalizations.of(context).translate('first_name'),
                          inputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                          value: firstName,
                          onValidate: (value){
                            if (value.isEmpty) {
                              return AppLocalizations.of(context).translate('first_name_empty_validate');
                            }

                            if (value.length < 3) {
                              return AppLocalizations.of(context).translate('first_name_len_validate');
                            }

                            return null;
                          },

                          onChanged: (value){
                            firstName = value;
                          },
                        ),

                        AppTextField(
                          isEnable: submitSt,
                          labelText: AppLocalizations.of(context).translate('last_name'),
                          inputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                          value: lastName,
                          onValidate: (value){
                            if (value.isEmpty) {
                              return AppLocalizations.of(context).translate('last_name_empty_validate');
                            }

                            if (value.length < 3) {
                              return AppLocalizations.of(context).translate('last_name_len_validate');
                            }

                            return null;
                          },

                          onChanged: (value){
                            lastName = value;
                          },
                        ),

                        widget.userModel == null ? AppTextField(
                          isEnable: submitSt,
                          labelText: AppLocalizations.of(context).translate('email'),
                          textInputFormatter: [FilteringTextInputFormatter.deny(RegExp('[ ]'))],
                          inputAction: TextInputAction.done,
                          textInputType: TextInputType.emailAddress,
                          value: email,
                          onValidate: (value){

                            Pattern pattern = '[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}';

                            if (value.isEmpty) {
                              return AppLocalizations.of(context).translate('email_empty_validate');
                            }

                            if (!RegExp(pattern).hasMatch(value)){
                              return AppLocalizations.of(context).translate('email_validate');
                            }

                            return null;
                          },

                          onFieldSubmitted: (value){
                            email = value;
                            FocusScope.of(context).unfocus();
                          },

                          onChanged: (value){
                            email = value;
                          },
                        ) : Container(),

                        SizedBox(height: 18),

                        Container(
                          width: MediaQuery.of(context).size.width - 90,
                          child: DropdownButtonFormField(
                            value: companyID,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                              isDense: true,
                              contentPadding: EdgeInsets.fromLTRB(22, 20, 22, 12),
                              errorMaxLines: 1,
                              errorStyle: TextStyle(fontSize: 12),
                            ),
                            items: Provider.of<CompaniesViewModel>(context, listen: false).companyList.map((UserModel model) {
                              return DropdownMenuItem<String>(
                                value: model.uID,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: new Text(model.companyName, style: TextStyle(color: Colors.grey[700])),
                                ),
                              );
                            }).toList(),
                            dropdownColor: Colors.white,
                            validator: (value) {
                              if (value == null) {
                                return AppLocalizations.of(context).translate('company_select_empty_validate');
                              }
                              return null;
                            },
                            hint: Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Text(AppLocalizations.of(context).translate('select_company'), style: TextStyle(color: Colors.grey[500])),
                            ),
                            onChanged: submitSt ? (value) => setState(() => companyID = value) : null,
                          ),
                        ),

                        SizedBox(height: 50),

                        Center(child: Text(AppLocalizations.of(context).translate('schedules'), style: TextStyle(fontSize: 18 ,color: Colors.grey[600], fontWeight: FontWeight.bold))),

                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(AppLocalizations.of(context).translate('sunday'), style: TextStyle(fontSize: 16 ,color: Colors.grey[600], fontWeight: FontWeight.normal)),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TimePickerField(
                                enabled: submitSt,
                                onTimePicked: (time){
                                  sunInTime = new DateTime(now.year, now.month, now.day, time.hour, time.minute);
                                },
                                value: sunInTime,
                                hint: AppLocalizations.of(context).translate('clock_id'),
                                helpText: '${AppLocalizations.of(context).translate('sunday')} ${AppLocalizations.of(context).translate('clock_id')} time',
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TimePickerField(
                                enabled: submitSt,
                                onTimePicked: (time){
                                  sunOutTime = new DateTime(now.year, now.month, now.day, time.hour, time.minute);
                                },
                                value: sunOutTime,
                                hint: AppLocalizations.of(context).translate('clock_out'),
                                helpText: '${AppLocalizations.of(context).translate('sunday')} ${AppLocalizations.of(context).translate('clock_out')} time',
                              ),
                            ),

                          ],
                        ),

                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(AppLocalizations.of(context).translate('monday'), style: TextStyle(fontSize: 16 ,color: Colors.grey[600], fontWeight: FontWeight.normal)),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TimePickerField(
                                enabled: submitSt,
                                onTimePicked: (time){
                                  monInTime = new DateTime(now.year, now.month, now.day, time.hour, time.minute);
                                },
                                value: monInTime,
                                hint: AppLocalizations.of(context).translate('clock_id'),
                                helpText: '${AppLocalizations.of(context).translate('monday')} ${AppLocalizations.of(context).translate('clock_id')} time',
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TimePickerField(
                                enabled: submitSt,
                                onTimePicked: (time){
                                  monOutTime = new DateTime(now.year, now.month, now.day, time.hour, time.minute);
                                },
                                value: monOutTime,
                                hint: AppLocalizations.of(context).translate('clock_out'),
                                helpText: '${AppLocalizations.of(context).translate('monday')} ${AppLocalizations.of(context).translate('clock_out')} time',
                              ),
                            ),

                          ],
                        ),

                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(AppLocalizations.of(context).translate('tuesday'), style: TextStyle(fontSize: 16 ,color: Colors.grey[600], fontWeight: FontWeight.normal)),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TimePickerField(
                                enabled: submitSt,
                                onTimePicked: (time){
                                  tusInTime = new DateTime(now.year, now.month, now.day, time.hour, time.minute);
                                },
                                value: tusInTime,
                                hint: AppLocalizations.of(context).translate('clock_id'),
                                helpText: '${AppLocalizations.of(context).translate('tuesday')} ${AppLocalizations.of(context).translate('clock_id')} time',
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TimePickerField(
                                enabled: submitSt,
                                onTimePicked: (time){
                                  tusOutTime = new DateTime(now.year, now.month, now.day, time.hour, time.minute);
                                },
                                value: tusOutTime,
                                hint: AppLocalizations.of(context).translate('clock_out'),
                                helpText: '${AppLocalizations.of(context).translate('tuesday')} ${AppLocalizations.of(context).translate('clock_out')} time',
                              ),
                            ),

                          ],
                        ),

                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(AppLocalizations.of(context).translate('wednesday'), style: TextStyle(fontSize: 16 ,color: Colors.grey[600], fontWeight: FontWeight.normal)),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TimePickerField(
                                enabled: submitSt,
                                onTimePicked: (time){
                                  wedInTime = new DateTime(now.year, now.month, now.day, time.hour, time.minute);
                                },
                                value: wedInTime,
                                hint: AppLocalizations.of(context).translate('clock_id'),
                                helpText: '${AppLocalizations.of(context).translate('wednesday')} ${AppLocalizations.of(context).translate('clock_id')} time',
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TimePickerField(
                                enabled: submitSt,
                                onTimePicked: (time){
                                  wedOutTime = new DateTime(now.year, now.month, now.day, time.hour, time.minute);
                                },
                                value: wedOutTime,
                                hint: AppLocalizations.of(context).translate('clock_out'),
                                helpText: '${AppLocalizations.of(context).translate('wednesday')} ${AppLocalizations.of(context).translate('clock_out')} time',
                              ),
                            ),

                          ],
                        ),

                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(AppLocalizations.of(context).translate('thursday'), style: TextStyle(fontSize: 16 ,color: Colors.grey[600], fontWeight: FontWeight.normal)),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TimePickerField(
                                enabled: submitSt,
                                onTimePicked: (time){
                                  thiInTime = new DateTime(now.year, now.month, now.day, time.hour, time.minute);
                                },
                                value: thiInTime,
                                hint: AppLocalizations.of(context).translate('clock_id'),
                                helpText: '${AppLocalizations.of(context).translate('thursday')} ${AppLocalizations.of(context).translate('clock_id')} time',
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TimePickerField(
                                enabled: submitSt,
                                onTimePicked: (time){
                                  thiOutTime = new DateTime(now.year, now.month, now.day, time.hour, time.minute);
                                },
                                value: thiOutTime,
                                hint: AppLocalizations.of(context).translate('clock_out'),
                                helpText: '${AppLocalizations.of(context).translate('thursday')} ${AppLocalizations.of(context).translate('clock_out')} time',
                              ),
                            ),

                          ],
                        ),

                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(AppLocalizations.of(context).translate('friday'), style: TextStyle(fontSize: 16 ,color: Colors.grey[600], fontWeight: FontWeight.normal)),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TimePickerField(
                                enabled: submitSt,
                                onTimePicked: (time){
                                  friInTime = new DateTime(now.year, now.month, now.day, time.hour, time.minute);
                                },
                                value: friInTime,
                                hint: AppLocalizations.of(context).translate('clock_id'),
                                helpText: '${AppLocalizations.of(context).translate('friday')} ${AppLocalizations.of(context).translate('clock_id')} time',
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TimePickerField(
                                enabled: submitSt,
                                onTimePicked: (time){
                                  friOutTime = new DateTime(now.year, now.month, now.day, time.hour, time.minute);
                                },
                                value: friOutTime,
                                hint: AppLocalizations.of(context).translate('clock_out'),
                                helpText: '${AppLocalizations.of(context).translate('friday')} ${AppLocalizations.of(context).translate('clock_out')} time',
                              ),
                            ),

                          ],
                        ),

                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(AppLocalizations.of(context).translate('saturday'), style: TextStyle(fontSize: 16 ,color: Colors.grey[600], fontWeight: FontWeight.normal)),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TimePickerField(
                                enabled: submitSt,
                                onTimePicked: (time){
                                  satInTime = new DateTime(now.year, now.month, now.day, time.hour, time.minute);
                                },
                                value: satInTime,
                                hint: AppLocalizations.of(context).translate('clock_id'),
                                helpText: '${AppLocalizations.of(context).translate('saturday')} ${AppLocalizations.of(context).translate('clock_id')} time',
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TimePickerField(
                                enabled: submitSt,
                                onTimePicked: (time){
                                  satOutTime = new DateTime(now.year, now.month, now.day, time.hour, time.minute);
                                },
                                value: satOutTime,
                                hint: AppLocalizations.of(context).translate('clock_out'),
                                helpText: '${AppLocalizations.of(context).translate('saturday')} ${AppLocalizations.of(context).translate('clock_out')} time',
                              ),
                            ),

                          ],
                        ),

                        SizedBox(height: 50),
                        Center(child: Text(AppLocalizations.of(context).translate('long_tap_remove_time'), style: TextStyle(fontSize: 13 ,color: Colors.grey[400], fontWeight: FontWeight.normal))),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitForm() async{

    FocusScope.of(context).unfocus();

    if (_formKey.currentState.validate()) {

      Future.delayed(Duration(milliseconds: 250), (){
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context){
            return LoadingDialog();
          },
        );
      });

      setState(() {
        submitSt = false;
      });

      try{

        dynamic result = await Provider.of<FirebaseAuthService>(context, listen: false).registerWithoutAuth(email: email.trim());

        if (result is UserModel) {

          if(imageUrl != null){
            dynamic uploadResult =  await Provider.of<FirebaseStorage>(context, listen: false).uploadAvatar(imagePath: imageUrl, uID: result.uID);
            result.imageURL = uploadResult != null && Uri.tryParse(uploadResult).isAbsolute ? uploadResult : null;
            createProfile(result);
          }else{
            createProfile(result);
          }

        } else {
          setState(() {
            submitSt = true;
          });

          await Future.delayed(Duration(milliseconds: 1500), (){Navigator.pop(context);});
          await Future.delayed(Duration(milliseconds: 800), (){Message.show(_globalScaffoldKey, result.toString());});
        }
      }catch(error){
        if(!AppConfig.isPublished){
          print('$error');
        }

        setState(() {
          submitSt = true;
        });

        await Future.delayed(Duration(milliseconds: 1500), (){Navigator.pop(context);});
        await Future.delayed(Duration(milliseconds: 800), (){Message.show(_globalScaffoldKey, AppLocalizations.of(context).translate('intern_add_fail'));});

      }
    }
  }

  void createProfile(UserModel model) async{

    try{
      String regCode = model.uID.toUpperCase().substring(0, 6);

      Map<String, dynamic> schedules = {
        'sat': { 'clock_in': satInTime, 'clock_out': satOutTime },
        'sun': { 'clock_in': sunInTime, 'clock_out': sunOutTime },
        'mon': { 'clock_in': monInTime, 'clock_out': monOutTime },
        'tue': { 'clock_in': tusInTime, 'clock_out': tusOutTime },
        'wed': { 'clock_in': wedInTime, 'clock_out': wedOutTime },
        'thu': { 'clock_in': thiInTime, 'clock_out': thiOutTime },
        'fri': { 'clock_in': friInTime, 'clock_out': friOutTime },
      };

      Map<String, dynamic> clocks = {
        'sat': { 'clock_in': null, 'clock_out': null },
        'sun': { 'clock_in': null, 'clock_out': null },
        'mon': { 'clock_in': null, 'clock_out': null },
        'tue': { 'clock_in': null, 'clock_out': null },
        'wed': { 'clock_in': null, 'clock_out': null },
        'thu': { 'clock_in': null, 'clock_out': null },
        'fri': { 'clock_in': null, 'clock_out': null },
      };

      UserModel userModel = UserModel(
        uID: model.uID,
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        imageURL: model.imageURL != null ? model.imageURL : '',
        companyID: companyID,
        email: email.trim(),
        platform: Platform.operatingSystem,
        registererID: Provider.of<UserViewModel>(context, listen: false).uID,
        createdAt: Timestamp.now(),
        roleID: AppConfig.internUserRole.toDouble(),
        tags: [firstName.trim().toLowerCase(), lastName.trim().toLowerCase(), '${firstName.trim().toLowerCase()} ${lastName.trim().toLowerCase()}' , email.trim().toLowerCase(), regCode],
        schedules: schedules,
        clocks: clocks,
        regCode: regCode,
        status: true,
        verified: false,
        hasPassword: false
      );

      await Provider.of<FirestoreService>(context, listen: false).createProfile(userModel: userModel);
      await Provider.of<UserViewModel>(context, listen: false).sendEmail( message: 'Your registration code is: $regCode', email: userModel.email);
      await Provider.of<UserViewModel>(context, listen: false).sendEmail( message: '${firstName.trim()} ${lastName.trim()} intern registration code is: $regCode', email: Provider.of<UserViewModel>(context, listen: false).email);
      //Provider.of<CompaniesViewModel>(context, listen: false).addToList(model: userModel);

      await Future.delayed(Duration(milliseconds: 1500), (){Navigator.pop(context);});
      await Future.delayed(Duration(milliseconds: 800), (){Message.show(_globalScaffoldKey, AppLocalizations.of(context).translate('intern_add_success'));});
      await Future.delayed(Duration(milliseconds: 1500), (){Navigator.pop(context);});

    }catch(error){
      if(!AppConfig.isPublished){
        print('$error');
      }

      setState(() {
        submitSt = true;
      });

      await Future.delayed(Duration(milliseconds: 1500), (){Navigator.pop(context);});
      await Future.delayed(Duration(milliseconds: 800), (){Message.show(_globalScaffoldKey, AppLocalizations.of(context).translate('intern_add_fail'));});
    }
  }

  void updateProfile() async{

    FocusScope.of(context).unfocus();

    if (_formKey.currentState.validate()) {
      Future.delayed(Duration(milliseconds: 250), () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return LoadingDialog();
          },
        );
      });

      setState(() {
        submitSt = false;
      });

      try{

        UserModel model = widget.userModel;

        if(imageUrl != null && !imageUrl.startsWith('http')){
          dynamic uploadResult =  await Provider.of<FirebaseStorage>(context, listen: false).uploadAvatar(imagePath: imageUrl, uID: model.uID);
          model.imageURL = uploadResult != null && Uri.tryParse(uploadResult).isAbsolute ? uploadResult : null;
        }else{
          model.imageURL = imageUrl;
        }

        model.firstName = firstName.trim();
        model.lastName = lastName.trim();
        model.companyID = companyID;

        Map<String, dynamic> schedules = {
          'sat': { 'clock_in': satInTime != null ? Timestamp.fromDate(satInTime) : null, 'clock_out': satOutTime != null ? Timestamp.fromDate(satOutTime) : null },
          'sun': { 'clock_in': sunInTime != null ? Timestamp.fromDate(sunInTime) : null, 'clock_out': sunOutTime != null ? Timestamp.fromDate(sunOutTime) : null },
          'mon': { 'clock_in': monInTime != null ? Timestamp.fromDate(monInTime) : null, 'clock_out': monOutTime != null ? Timestamp.fromDate(monOutTime) : null },
          'tue': { 'clock_in': tusInTime != null ? Timestamp.fromDate(tusInTime) : null, 'clock_out': tusOutTime != null ? Timestamp.fromDate(tusOutTime) : null },
          'wed': { 'clock_in': wedInTime != null ? Timestamp.fromDate(wedInTime) : null, 'clock_out': wedOutTime != null ? Timestamp.fromDate(wedOutTime) : null },
          'thu': { 'clock_in': thiInTime != null ? Timestamp.fromDate(thiInTime) : null, 'clock_out': thiOutTime != null ? Timestamp.fromDate(thiOutTime) : null },
          'fri': { 'clock_in': friInTime != null ? Timestamp.fromDate(friInTime) : null, 'clock_out': friOutTime != null ? Timestamp.fromDate(friOutTime) : null },
        };

        model.schedules = schedules;

        dynamic result = await Provider.of<FirestoreService>(context, listen: false).updateInternProfile(userModel: model);

        if(result is bool && result){
          Provider.of<InternsViewModel>(context, listen: false).updateList(model: model);

          await Future.delayed(Duration(milliseconds: 1500), (){Navigator.pop(context);});
          await Future.delayed(Duration(milliseconds: 800), (){Message.show(_globalScaffoldKey, AppLocalizations.of(context).translate('intern_update_success'));});
          await Future.delayed(Duration(milliseconds: 1500), (){Navigator.pop(context);});
          widget.onFinish();
        }else{
          setState(() {
            submitSt = true;
          });
          widget.onFinish();
          await Future.delayed(Duration(milliseconds: 1500), (){Navigator.pop(context);});
          await Future.delayed(Duration(milliseconds: 800), (){Message.show(_globalScaffoldKey, AppLocalizations.of(context).translate('intern_update_fail'));});
        }

      }catch(error){
        if(!AppConfig.isPublished){
          print('$error');
        }

        setState(() {
          submitSt = true;
        });

        await Future.delayed(Duration(milliseconds: 1500), (){Navigator.pop(context);});
        await Future.delayed(Duration(milliseconds: 800), (){Message.show(_globalScaffoldKey, AppLocalizations.of(context).translate('intern_update_fail'));});
      }
    }
  }
}