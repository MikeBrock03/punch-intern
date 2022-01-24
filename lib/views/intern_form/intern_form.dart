import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:provider/provider.dart';
import 'package:punch_app/constants/app_colors.dart';
import 'package:punch_app/main.dart';
import 'package:punch_app/models/clock_field_model.dart';
import 'components/avatar_picker.dart';
import 'components/clock_fields.dart';
import 'components/time_picker_field.dart';
import '../../view_models/company_view_model.dart';
import '../../view_models/user_view_model.dart';
import '../../view_models/interns_view_model.dart';
import '../../services/firebase_storage.dart';
import '../../helpers/loading_dialog.dart';
import '../../models/user_model.dart';
import '../../services/firestore_service.dart';
import '../../helpers/fading_edge_scrollview.dart';
import '../../helpers/app_text_field.dart';
import '../../config/app_config.dart';
import '../../helpers/app_localizations.dart';
import '../../helpers/message.dart';

class InternForm extends StatefulWidget {
  UserModel userModel;
  final Function() onFinish;

  InternForm({this.userModel, this.onFinish});

  @override
  _InternFormState createState() => _InternFormState();
}

class _InternFormState extends State<InternForm> {
  final _formKey = GlobalKey<FormState>();
  final _globalScaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();

  String firstName, phone, lastName, imageUrl;

  DateTime satInTime,
      satOutTime,
      sunInTime,
      sunOutTime,
      monInTime,
      monOutTime,
      tusInTime,
      tusOutTime,
      wedInTime,
      wedOutTime,
      thiInTime,
      thiOutTime,
      friInTime,
      friOutTime;

  final now = new DateTime.now();

  bool submitSt = true;

  List<ClockFieldModel> sunModelList = [];
  List<ClockFieldModel> monModelList = [];
  List<ClockFieldModel> tusModelList = [];
  List<ClockFieldModel> wedModelList = [];
  List<ClockFieldModel> thiModelList = [];
  List<ClockFieldModel> friModelList = [];
  List<ClockFieldModel> satModelList = [];

  @override
  void initState() {
    super.initState();

    if (widget.userModel != null) {
      firstName = widget.userModel.firstName;
      lastName = widget.userModel.lastName;
      phone = widget.userModel.mobile;
      imageUrl =
          widget.userModel.imageURL != null && widget.userModel.imageURL != ''
              ? widget.userModel.imageURL
              : null;

      Iterable sunSchedules = widget.userModel.schedules['sun'];
      sunSchedules.forEach((element) {
        sunModelList.add(ClockFieldModel(
            day: 'sunday',
            clockIn: element['clockIn'] != null
                ? DateTime.parse(element['clockIn'].toDate().toString())
                : null,
            clockOut: element['clockOut'] != null
                ? DateTime.parse(element['clockOut'].toDate().toString())
                : null));
      });

      Iterable monSchedules = widget.userModel.schedules['mon'];
      monSchedules.forEach((element) {
        monModelList.add(ClockFieldModel(
            day: 'monday',
            clockIn: element['clockIn'] != null
                ? DateTime.parse(element['clockIn'].toDate().toString())
                : null,
            clockOut: element['clockOut'] != null
                ? DateTime.parse(element['clockOut'].toDate().toString())
                : null));
      });

      Iterable tueSchedules = widget.userModel.schedules['tue'];
      tueSchedules.forEach((element) {
        tusModelList.add(ClockFieldModel(
            day: 'tuesday',
            clockIn: element['clockIn'] != null
                ? DateTime.parse(element['clockIn'].toDate().toString())
                : null,
            clockOut: element['clockOut'] != null
                ? DateTime.parse(element['clockOut'].toDate().toString())
                : null));
      });

      Iterable wedSchedules = widget.userModel.schedules['wed'];
      wedSchedules.forEach((element) {
        wedModelList.add(ClockFieldModel(
            day: 'wednesday',
            clockIn: element['clockIn'] != null
                ? DateTime.parse(element['clockIn'].toDate().toString())
                : null,
            clockOut: element['clockOut'] != null
                ? DateTime.parse(element['clockOut'].toDate().toString())
                : null));
      });

      Iterable thuSchedules = widget.userModel.schedules['thu'];
      thuSchedules.forEach((element) {
        thiModelList.add(ClockFieldModel(
            day: 'thursday',
            clockIn: element['clockIn'] != null
                ? DateTime.parse(element['clockIn'].toDate().toString())
                : null,
            clockOut: element['clockOut'] != null
                ? DateTime.parse(element['clockOut'].toDate().toString())
                : null));
      });

      Iterable friSchedules = widget.userModel.schedules['fri'];
      friSchedules.forEach((element) {
        friModelList.add(ClockFieldModel(
            day: 'friday',
            clockIn: element['clockIn'] != null
                ? DateTime.parse(element['clockIn'].toDate().toString())
                : null,
            clockOut: element['clockOut'] != null
                ? DateTime.parse(element['clockOut'].toDate().toString())
                : null));
      });

      Iterable satSchedules = widget.userModel.schedules['sat'];
      satSchedules.forEach((element) {
        satModelList.add(ClockFieldModel(
            day: 'saturday',
            clockIn: element['clockIn'] != null
                ? DateTime.parse(element['clockIn'].toDate().toString())
                : null,
            clockOut: element['clockOut'] != null
                ? DateTime.parse(element['clockOut'].toDate().toString())
                : null));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusWatcher(
      child: Scaffold(
        key: _globalScaffoldKey,
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors.primaryColor),
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          elevation: 0,
          title: Text(
              AppLocalizations.of(context).translate('edit') +
                  ' ' +
                  AppLocalizations.of(context).translate('profile'),
              style: TextStyle(fontSize: 18, color: AppColors.primaryColor)),
          centerTitle: true,
          brightness: Brightness.dark,
          actions: [
            TextButton(
              onPressed: () {
                if (submitSt) {
                  updateProfile();
                }
              },
              style: TextButton.styleFrom(
                shape:
                    CircleBorder(side: BorderSide(color: Colors.transparent)),
                primary: Colors.white,
              ),
              child: Text(AppLocalizations.of(context).translate('save'),
                  style: TextStyle(
                      color: AppColors.primaryDarkColor, fontSize: 15)),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: internFormBody(),
      ),
    );
  }

  Widget internFormBody() {
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
                Center(
                    child: SizedBox(
                        width: 180,
                        height: 180,
                        child: AvatarPicker(
                            imageURL: imageUrl,
                            enabled: submitSt,
                            onImageCaptured: (path) {
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
                          isEnable: false,
                          labelText: AppLocalizations.of(context)
                              .translate('first_name'),
                          inputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                          value: firstName,
                          onValidate: (value) {
                            if (value.isEmpty) {
                              return AppLocalizations.of(context)
                                  .translate('first_name_empty_validate');
                            }

                            if (value.length < 3) {
                              return AppLocalizations.of(context)
                                  .translate('first_name_len_validate');
                            }

                            return null;
                          },
                          onChanged: (value) {
                            firstName = value;
                          },
                        ),
                        AppTextField(
                          isEnable: false,
                          labelText: AppLocalizations.of(context)
                              .translate('last_name'),
                          inputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                          value: lastName,
                          onValidate: (value) {
                            if (value.isEmpty) {
                              return AppLocalizations.of(context)
                                  .translate('last_name_empty_validate');
                            }

                            if (value.length < 3) {
                              return AppLocalizations.of(context)
                                  .translate('last_name_len_validate');
                            }

                            return null;
                          },
                          onChanged: (value) {
                            lastName = value;
                          },
                        ),
                        AppTextField(
                          isEnable: false,
                          labelText: AppLocalizations.of(context)
                              .translate('company_name'),
                          inputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                          value: Provider.of<CompanyViewModel>(context,
                                  listen: false)
                              .companyName,
                        ),
                        AppTextField(
                          isEnable: submitSt,
                          labelText: AppLocalizations.of(context)
                              .translate('phone_number'),
                          textInputFormatter: [
                            FilteringTextInputFormatter.deny(RegExp('[ ]'))
                          ],
                          inputAction: TextInputAction.next,
                          value: phone,
                          textInputType: TextInputType.phone,
                          onChanged: (value) {
                            phone = value;
                          },
                        ),
                        SizedBox(height: 50),
                        Center(
                            child: Text(
                                AppLocalizations.of(context)
                                    .translate('schedules'),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold))),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                              AppLocalizations.of(context).translate('sunday'),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.normal)),
                        ),
                        ...getClockFields('sunday', sunModelList),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                              AppLocalizations.of(context).translate('monday'),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.normal)),
                        ),
                        ...getClockFields('monday', monModelList),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                              AppLocalizations.of(context).translate('tuesday'),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.normal)),
                        ),
                        ...getClockFields('tuesday', tusModelList),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                              AppLocalizations.of(context)
                                  .translate('wednesday'),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.normal)),
                        ),
                        ...getClockFields('wednesday', wedModelList),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                              AppLocalizations.of(context)
                                  .translate('thursday'),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.normal)),
                        ),
                        ...getClockFields('thursday', thiModelList),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                              AppLocalizations.of(context).translate('friday'),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.normal)),
                        ),
                        ...getClockFields('friday', friModelList),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                              AppLocalizations.of(context)
                                  .translate('saturday'),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.normal)),
                        ),
                        ...getClockFields('saturday', satModelList),
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

  void updateProfile() async {
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

      try {
        UserModel model = widget.userModel;

        if (imageUrl != null && !imageUrl.startsWith('http')) {
          dynamic uploadResult =
              await Provider.of<FirebaseStorage>(context, listen: false)
                  .uploadAvatar(imagePath: imageUrl, uID: model.uID);
          model.imageURL =
              uploadResult != null && Uri.tryParse(uploadResult).isAbsolute
                  ? uploadResult
                  : null;
        } else {
          model.imageURL = imageUrl;
        }

        model.firstName = firstName.trim();
        model.lastName = lastName.trim();
        model.mobile = phone;

        dynamic result =
            await Provider.of<FirestoreService>(context, listen: false)
                .updateInternProfile(userModel: model);

        if (result is bool && result) {
          Provider.of<InternsViewModel>(context, listen: false)
              .updateList(model: model);
          Provider.of<UserViewModel>(context, listen: false)
              .setImageUrl(model.imageURL);
          Provider.of<UserViewModel>(context, listen: false)
              .setFirstName(model.firstName);
          Provider.of<UserViewModel>(context, listen: false)
              .setLastName(model.lastName);
          Provider.of<UserViewModel>(context, listen: false)
              .setMobile(model.mobile);

          await Future.delayed(Duration(milliseconds: 1500), () {
            Navigator.pop(context);
          });
          await Future.delayed(Duration(milliseconds: 800), () {
            Message.show(
                _globalScaffoldKey,
                AppLocalizations.of(context)
                    .translate('intern_update_success'));
          });
          await Future.delayed(Duration(milliseconds: 1500), () {
            Navigator.pop(context);
          });
          widget.onFinish();
        } else {
          setState(() {
            submitSt = true;
          });
          widget.onFinish();
          await Future.delayed(Duration(milliseconds: 1500), () {
            Navigator.pop(context);
          });
          await Future.delayed(Duration(milliseconds: 800), () {
            Message.show(_globalScaffoldKey,
                AppLocalizations.of(context).translate('intern_update_fail'));
          });
        }
      } catch (error) {
        if (!AppConfig.isPublished) {
          print('$error');
        }

        setState(() {
          submitSt = true;
        });

        await Future.delayed(Duration(milliseconds: 1500), () {
          Navigator.pop(context);
        });
        await Future.delayed(Duration(milliseconds: 800), () {
          Message.show(_globalScaffoldKey,
              AppLocalizations.of(context).translate('intern_update_fail'));
        });
      }
    }
  }

  List<Widget> getClockFields(String day, List<ClockFieldModel> modelList) {
    List<Widget> fieldList = [];
    for (int i = 0; i < modelList.length; i++) {
      fieldList.add(GestureDetector(
        key: UniqueKey(),
        child: ClockFields(
          globalScaffoldKey: _globalScaffoldKey,
          weekName: modelList[i].day,
          dayInTime: modelList[i].clockIn,
          dayOutTime: modelList[i].clockOut,
          type: i == 0 ? 1 : 2,
        ),
      ));
    }
    return fieldList;
  }
}
