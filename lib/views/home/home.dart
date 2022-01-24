import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:punch_app/view_models/interns_view_model.dart';
import '../../view_models/company_view_model.dart';
import '../../views/intern_form/intern_form.dart';
import '../../view_models/user_view_model.dart';
import '../../helpers/message.dart';
import '../../database/storage.dart';
import '../../constants/app_colors.dart';
import '../../helpers/question_dialog.dart';
import '../../views/home/fragments/interns_fragment/interns_fragment.dart';
import '../../views/home/fragments/punch_fragment/punch_fragment.dart';
import '../../views/welcome/welcome.dart';
import '../../config/app_config.dart';
import '../../helpers/app_localizations.dart';
import '../../helpers/app_navigator.dart';
import '../../services/firebase_auth_service.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Storage storage = new Storage();
  final globalScaffoldKey = GlobalKey<ScaffoldState>();
  int bottomSelectedIndex = 0;
  var _punchPage, _internsPage;
  int backPress = 0;

  @override
  Widget build(BuildContext context) {
    backPress = 0;

    return WillPopScope(
      onWillPop: () async {
        if (bottomSelectedIndex == 0) {
          if (backPress == 0) {
            globalScaffoldKey.currentState.hideCurrentSnackBar();
            Message.show(globalScaffoldKey,
                AppLocalizations.of(context).translate('exit_message'));
            backPress++;
          } else {
            return true;
          }
        } else {
          bottomTapped(0);
        }

        return false;
      },
      child: Scaffold(
        key: globalScaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors.primaryColor),
          elevation: 0,
          shadowColor: Colors.white,
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context).translate('app_title'),
            style: TextStyle(fontSize: 18, color: AppColors.primaryColor),
          ),
          centerTitle: true,
          brightness: Brightness.dark,
          leading: IconButton(
            tooltip: AppLocalizations.of(context).translate('profile'),
            icon: Icon(
              Icons.person,
              color: AppColors.primaryColor,
            ),
            onPressed: () => AppNavigator.push(
                context: context,
                page: InternForm(
                  userModel: Provider.of<UserViewModel>(context, listen: false)
                      .userModel,
                  onFinish: () => setState(() {}),
                )),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: IconButton(
                color: AppColors.primaryColor,
                tooltip: AppLocalizations.of(context).translate('logout'),
                icon: Icon(Icons.logout),
                onPressed: () => logout(),
              ),
            ),
          ],
        ),
        body: buildPageView(),
        bottomNavigationBar: bottomNavBar(),
      ),
    );
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  static PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  Widget buildPageView() {
    return PageView.builder(
      itemBuilder: (context, index) {
        if (index == 0) return this.punchInit();
        if (index == 1) return this.internsInit();
        return null;
      },
      physics: BouncingScrollPhysics(),
      controller: pageController,
      itemCount: 2,
      onPageChanged: (index) {
        pageChanged(index);
        FocusScope.of(context).requestFocus(new FocusNode());
      },
    );
  }

  Widget bottomNavBar() {
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[200], width: 1))),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 1,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey[400],
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        currentIndex: bottomSelectedIndex,
        onTap: (index) {
          bottomTapped(index);
        },
        items: [
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.clock, size: 22),
              title: Padding(
                  padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                  child: Text(
                      AppLocalizations.of(context).translate('app_title'),
                      style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.normal)))),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.users, size: 22),
              title: Padding(
                  padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                  child: Text(AppLocalizations.of(context).translate('interns'),
                      style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.normal)))),
        ],
      ),
    );
  }

  Widget punchInit() {
    if (this._punchPage == null)
      this._punchPage = PunchFragment(globalScaffoldKey: globalScaffoldKey);
    return this._punchPage;
  }

  Widget internsInit() {
    if (this._internsPage == null)
      this._internsPage = InternsFragment(
          globalScaffoldKey: globalScaffoldKey,
          company:
              Provider.of<CompanyViewModel>(context, listen: false).userModel);
    return this._internsPage;
  }

  void logout() {
    Future.delayed(Duration(milliseconds: 250), () {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return QuestionDialog(
            globalKey: globalScaffoldKey,
            title: AppLocalizations.of(dialogContext)
                .translate('exit_from_account_description'),
            onYes: () async {
              performLogout();
            },
          );
        },
      );
    });
  }

  void performLogout() async {
    await Future.delayed(Duration(milliseconds: 450));
    try {
      await Provider.of<FirebaseAuthService>(context, listen: false).signOut();
      await storage.clear('verified');
      Provider.of<UserViewModel>(context, listen: false).setUserModel(null);
      Provider.of<InternsViewModel>(context, listen: false).internList.clear();
      AppNavigator.pushReplace(context: context, page: Welcome());
    } catch (error) {
      if (!AppConfig.isPublished) {
        print('Error: $error');
      }
    }
  }
}
