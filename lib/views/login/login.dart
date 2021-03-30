import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:provider/provider.dart';
import 'package:punch_app/models/user_model.dart';
import 'package:punch_app/views/welcome/welcome.dart';
import '../../services/firebase_auth_service.dart';
import '../../views/home/home.dart';
import '../../helpers/app_navigator.dart';
import '../../views/register/register.dart';
import '../../config/app_config.dart';
import '../../helpers/message.dart';
import '../../constants/app_colors.dart';
import '../../helpers/app_text_field.dart';
import '../../helpers/fading_edge_scrollview.dart';
import '../../helpers/progress_button.dart';
import '../../helpers/app_localizations.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin{

  final _formKey = GlobalKey<FormState>();
  final _globalScaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController _buttonAnimationController;
  ScrollController scrollController = ScrollController();

  String email, password;
  bool emailSt = true, passwordSt = true, submitSt = true;

  @override
  void initState() {
    super.initState();

    _buttonAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FocusWatcher(
      child: WillPopScope(
        onWillPop: () async {
          AppNavigator.pushReplace(context: context, page: Welcome());
          return true;
        },
        child: Scaffold(
          key: _globalScaffoldKey,
          resizeToAvoidBottomInset : false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            brightness: Brightness.dark,
            title: Text(AppLocalizations.of(context).translate('login'), style: TextStyle(fontSize: 17)),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => AppNavigator.pushReplace(context: context, page: Welcome()),
            ),
          ),
          body: loginBody(),
        ),
      ),
    );
  }

  Widget loginBody(){
    return Column(
      children: [
        FadingEdgeScrollView.fromSingleChildScrollView(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            controller: scrollController,
            child: Form(
              key: _formKey,
              child: FadeInUp(
                from: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  width: MediaQuery.of(context).size.width,
                  child: Column(

                    children: <Widget>[

                      SizedBox(height: 40),

                      Text(AppLocalizations.of(context).translate('login_title'), style: TextStyle(fontSize: 16, color: Colors.grey[500])),

                      SizedBox(height: 30),

                      AppTextField(
                        isEnable: emailSt,
                        labelText: AppLocalizations.of(context).translate('email'),
                        textInputFormatter: [FilteringTextInputFormatter.deny(RegExp('[ ]'))],
                        textInputType: TextInputType.emailAddress,
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

                        onChanged: (value){
                          email = value;
                        },
                      ),

                      AppTextField(
                        isEnable: passwordSt,
                        labelText: AppLocalizations.of(context).translate('password'),
                        inputAction: TextInputAction.done,
                        isPassword: true,
                        onValidate: (value){
                          if (value.isEmpty) {
                            return AppLocalizations.of(context).translate('password_empty_validate');
                          }

                          if (value.length < 3) {
                            return AppLocalizations.of(context).translate('password_len_validate');
                          }

                          return null;
                        },

                        onFieldSubmitted: (value){
                          password = value;
                          submitForm();
                        },

                        onChanged: (value){
                          password = value;
                        },
                      ),

                      SizedBox(height: 18),

                      SizedBox(
                        width: MediaQuery.of(context).size.width - 65,
                        height: 50,
                        child: ProgressButton(
                          animationController: _buttonAnimationController,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: AppColors.primaryColor,
                          progressIndicatorSize: 15,
                          strokeWidth: 2,
                          child: Text(AppLocalizations.of(context).translate('login'), style:  TextStyle(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                          onPressed: (AnimationController controller) {
                            if(submitSt){
                              submitForm();
                            }
                          },
                        ),
                      ),

                      SizedBox(height: 60),

                      Text(AppLocalizations.of(context).translate('register_instead'), style: TextStyle(fontSize: 14, color: Colors.grey[500])),

                      SizedBox(height: 10),

                      SizedBox(
                          height: 40,
                          width: 150,
                          child: TextButton(
                            onPressed: submitSt ? () async{
                              await Future.delayed(Duration(milliseconds: 200));
                              AppNavigator.pushReplace(context: context, page: Register());
                            } : null,
                            child: Text(AppLocalizations.of(context).translate('register_now'), style: TextStyle(color: AppColors.primaryColor, fontSize: 14, fontWeight: FontWeight.normal)),
                          )
                      ),

                      SizedBox(height: 20)

                    ],

                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void submitForm() async{

    FocusScope.of(context).unfocus();

    if (_formKey.currentState.validate()) {

      _buttonAnimationController.forward();

      setState(() {
        emailSt = false;
        passwordSt = false;
        submitSt = false;
      });

      dynamic result;

      try{

        result = await Provider.of<FirebaseAuthService>(context, listen: false).login(
          email: email.trim(),
          password: password.trim()
        );

      }catch(error){
        if(!AppConfig.isPublished){
          print('$error');
        }

        setState(() {
          emailSt = true;
          passwordSt = true;
          submitSt = true;
        });

        _buttonAnimationController.reverse();
        Message.show(_globalScaffoldKey, error);
      }finally{

        if (result is UserModel) {
          //await getData();
          AppNavigator.pushReplace(context: context, page: Home());
        } else {
          setState(() {
            emailSt = true;
            passwordSt = true;
            submitSt = true;
          });

          _buttonAnimationController.reverse();
          Message.show(_globalScaffoldKey, result.toString());
        }
      }
    }
  }
}
