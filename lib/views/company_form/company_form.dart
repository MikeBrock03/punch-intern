
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:provider/provider.dart';
import 'components/logo_picker.dart';
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

class CompanyForm extends StatefulWidget {
  @override
  _CompanyFormState createState() => _CompanyFormState();
}

class _CompanyFormState extends State<CompanyForm> {

  final _formKey = GlobalKey<FormState>();
  final _globalScaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();

  String companyName, employerFirstName, employerLastName, email, imageUrl, employerEducation, employerCertification;
  bool submitSt = true;

  @override
  Widget build(BuildContext context) {
    return FocusWatcher(
      child: Scaffold(
        key: _globalScaffoldKey,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate('add_company'), style: TextStyle(fontSize: 18)),
          centerTitle: true,
          brightness: Brightness.dark,
          actions: [
            TextButton(
              onPressed: () {
                if(submitSt){
                  submitForm();
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
        body: companyFormBody(),
      ),
    );
  }

  Widget companyFormBody(){
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

                Center(child: SizedBox(width: 180, height: 180,child: LogoPicker(imageURL: imageUrl, enabled: submitSt, onImageCaptured: (path){
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

                      children: <Widget>[

                        SizedBox(height: 25),

                        AppTextField(
                          isEnable: submitSt,
                          labelText: AppLocalizations.of(context).translate('company_name'),
                          inputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                          onValidate: (value){
                            if (value.isEmpty) {
                              return AppLocalizations.of(context).translate('company_name_empty_validate');
                            }

                            if (value.length < 3) {
                              return AppLocalizations.of(context).translate('company_name_len_validate');
                            }

                            return null;
                          },

                          onChanged: (value){
                            companyName = value;
                          },
                        ),

                        AppTextField(
                          isEnable: submitSt,
                          labelText: AppLocalizations.of(context).translate('employer_first_name'),
                          inputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                          onValidate: (value){
                            if (value.isEmpty) {
                              return AppLocalizations.of(context).translate('employer_first_name_empty_validate');
                            }

                            if (value.length < 3) {
                              return AppLocalizations.of(context).translate('employer_first_name_len_validate');
                            }

                            return null;
                          },

                          onChanged: (value){
                            employerFirstName = value;
                          },
                        ),

                        AppTextField(
                          isEnable: submitSt,
                          labelText: AppLocalizations.of(context).translate('employer_last_name'),
                          inputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                          onValidate: (value){
                            if (value.isEmpty) {
                              return AppLocalizations.of(context).translate('employer_last_name_empty_validate');
                            }

                            if (value.length < 3) {
                              return AppLocalizations.of(context).translate('employer_last_name_len_validate');
                            }

                            return null;
                          },

                          onChanged: (value){
                            employerLastName = value;
                          },
                        ),

                        AppTextField(
                          isEnable: submitSt,
                          labelText: AppLocalizations.of(context).translate('employer_education'),
                          inputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (value){
                            employerEducation = value;
                          },
                        ),

                        AppTextField(
                          isEnable: submitSt,
                          labelText: AppLocalizations.of(context).translate('employer_certification'),
                          inputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (value){
                            employerCertification = value;
                          },
                        ),

                        AppTextField(
                          isEnable: submitSt,
                          labelText: AppLocalizations.of(context).translate('employer_email'),
                          textInputFormatter: [FilteringTextInputFormatter.deny(RegExp('[ ]'))],
                          inputAction: TextInputAction.done,
                          textInputType: TextInputType.emailAddress,
                          onValidate: (value){

                            Pattern pattern = '[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}';

                            if (value.isEmpty) {
                              return AppLocalizations.of(context).translate('employer_email_empty_validate');
                            }

                            if (!RegExp(pattern).hasMatch(value)){
                              return AppLocalizations.of(context).translate('employer_email_validate');
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
                        ),

                        SizedBox(height: 20)

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

        dynamic uploadResult;

        if(imageUrl != null){
          uploadResult =  await Provider.of<FirebaseStorage>(context, listen: false).uploadLogo(imagePath: imageUrl);
        }

        dynamic result = await Provider.of<FirebaseAuthService>(context, listen: false).registerWithoutAuth(email: email.trim());

        if (result is UserModel) {
          result.logoURL = uploadResult != null && Uri.tryParse(uploadResult).isAbsolute ? uploadResult : null;
          createProfile(result);
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
        await Future.delayed(Duration(milliseconds: 800), (){Message.show(_globalScaffoldKey, AppLocalizations.of(context).translate('company_add_fail'));});

      }
    }
  }

  void createProfile(UserModel model) async{

    try{
      String regCode = model.uID.toUpperCase().substring(0, 6);

      UserModel userModel = UserModel(
        uID: model.uID,
        firstName: employerFirstName.trim(),
        lastName: employerLastName.trim(),
        logoURL: model.logoURL != null ? model.logoURL : '',
        education: employerEducation.trim(),
        certification: employerCertification.trim(),
        companyName: companyName.trim(),
        email: email.trim(),
        platform: Platform.operatingSystem,
        registererID: Provider.of<UserViewModel>(context, listen: false).uID,
        createdAt: Timestamp.now(),
        roleID: AppConfig.employerUserRole.toDouble(),
        tags: [employerFirstName.trim().toLowerCase(), employerLastName.trim().toLowerCase(), '${employerFirstName.trim().toLowerCase()} ${employerLastName.trim().toLowerCase()}' , email.trim().toLowerCase(), companyName.toLowerCase(), regCode],
        regCode: regCode,
        status: true,
        verified: false,
        hasPassword: false
      );

      await Provider.of<FirestoreService>(context, listen: false).createProfile(userModel: userModel);
      await Provider.of<UserViewModel>(context, listen: false).sendEmail( message: 'Your registration code is: $regCode', email: userModel.email);
      await Provider.of<UserViewModel>(context, listen: false).sendEmail( message: '${companyName.trim()} company registration code is: $regCode', email: Provider.of<UserViewModel>(context, listen: false).email);
      Provider.of<CompaniesViewModel>(context, listen: false).addToList(model: userModel);

      await Future.delayed(Duration(milliseconds: 1500), (){Navigator.pop(context);});
      await Future.delayed(Duration(milliseconds: 800), (){Message.show(_globalScaffoldKey, AppLocalizations.of(context).translate('company_add_success'));});
      await Future.delayed(Duration(milliseconds: 1500), (){Navigator.pop(context);});

    }catch(error){
      if(!AppConfig.isPublished){
        print('$error');
      }

      setState(() {
        submitSt = true;
      });

      await Future.delayed(Duration(milliseconds: 1500), (){Navigator.pop(context);});
      await Future.delayed(Duration(milliseconds: 800), (){Message.show(_globalScaffoldKey, AppLocalizations.of(context).translate('company_add_fail'));});
    }
  }
}