import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../config/app_config.dart';
import '../../../../constants/app_colors.dart';
import '../../../../helpers/message.dart';
import '../../../../helpers/no_glow_scroll_behavior.dart';
import '../../../../view_models/company_view_model.dart';
import '../../../../views/contact_info/contact_info.dart';
import '../../../../view_models/interns_view_model.dart';
import '../../../../models/user_model.dart';
import '../../../../helpers/app_navigator.dart';
import '../../../../helpers/fading_edge_scrollview.dart';
import '../../../../helpers/app_localizations.dart';

class InternsFragment extends StatefulWidget {

  final GlobalKey<ScaffoldState> globalScaffoldKey;
  final UserModel company;
  InternsFragment({ this.globalScaffoldKey, this.company });

  @override
  _InternsFragmentState createState() => _InternsFragmentState();
}

class _InternsFragmentState extends State<InternsFragment> with AutomaticKeepAliveClientMixin<InternsFragment> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: internsFragmentBody(),
    );
  }

  Widget internsFragmentBody(){

    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: SmartRefresher(
        enablePullUp: false,
        enablePullDown: true,
        controller: _refreshController,
        header: MaterialClassicHeader(distance: 36, color: AppColors.primaryColor),
        onRefresh: () => refresh(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(child: Text('${widget.company.companyName} Interns', style: TextStyle(fontSize: 20, color: Colors.grey[600]))),
              SizedBox(height: 25),
              Expanded(child: companyDetailBody())
            ],
          ),
        ),
      ),
    );
  }

  Widget companyDetailBody(){
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        children: [
          Row(
            children: [

              Hero(
                tag: widget.company.uID,
                child: GestureDetector(
                  onTap: (){
                    AppNavigator.push(context: context, page: ContactInfo(userModel: widget.company, isIntern: false));
                  },
                  child: Container(
                      width: 95,
                      height: 95,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: widget.company.logoURL != null && widget.company.logoURL != '' ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          placeholder:(context, url) => Container(color: Colors.grey[200]),
                          imageUrl: widget.company.logoURL,
                          width: 95,
                          height: 95,
                          fit: BoxFit.cover,
                        ),
                      ) : ClipRRect(borderRadius: BorderRadius.circular(10), child: Container(padding: EdgeInsets.symmetric(horizontal: 10) ,color: Colors.grey[200], child: Center(child: Text(widget.company.companyName, style: TextStyle(fontSize: 13, color: Colors.grey[500], decoration: TextDecoration.none), textAlign: TextAlign.center))))
                  ),
                ),
              ),

              SizedBox(width: 20),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Company: ${widget.company.companyName}', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                    SizedBox(height: 15),
                    Text('Employer: ${widget.company.firstName} ${widget.company.lastName}', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                  ],
                ),
              )
            ],
          ),

          SizedBox(height: 20),
          Divider(),
          Expanded(
              child: Consumer<InternsViewModel>(
                builder: (BuildContext context, InternsViewModel value, Widget child) {
                  return value.internList.isEmpty ? FadeInUp(from: 8, child: notFoundView()) : Container(
                      child: FadingEdgeScrollView.fromListView(
                          child: ListView(
                            controller: ScrollController(),
                            physics: BouncingScrollPhysics(),
                            children: [

                              Column(
                                children: [
                                  SizedBox(height: 10),
                                  GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.all(12),
                                    itemCount: value.internList.length,
                                    scrollDirection: Axis.vertical,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 20, mainAxisSpacing: 20),
                                    itemBuilder: (BuildContext context, int index) {

                                      var intern = value.internList[index];

                                      return Hero(
                                        tag: intern.uID,
                                        child: GestureDetector(
                                          onTap: (){
                                            AppNavigator.push(context: context, page: ContactInfo(userModel: intern, isIntern: true));
                                          },
                                          child: Container(
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
                                              child: intern.imageURL != null && intern.imageURL != '' ? ClipRRect(
                                                borderRadius: BorderRadius.circular(600),
                                                child: CachedNetworkImage(
                                                  placeholder:(context, url) => Container(color: Colors.grey[200]),
                                                  imageUrl: intern.imageURL,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ) : ClipRRect(borderRadius: BorderRadius.circular(600), child: Container(padding: EdgeInsets.all(5) ,color: Colors.grey[200], child: Center(child: Text(intern.firstName, style: TextStyle(fontSize: 13, color: Colors.grey[500], decoration: TextDecoration.none), textAlign: TextAlign.center))))
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          )
                      )
                  );
                }
              )
          )
        ],
      ),
    );
  }

  Widget notFoundView(){
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FaIcon(FontAwesomeIcons.users, size: 60, color: Colors.grey[300]),
            SizedBox(height: 15),
            Text(AppLocalizations.of(context).translate('there_is_nothing_to_show'), style: TextStyle(fontSize: 14, color: Colors.grey[400])),
            SizedBox(height: 70)
          ],
        )
    );
  }

  void refresh() async{
    try{

      dynamic result = await Provider.of<InternsViewModel>(context, listen: false).fetchData(uID: Provider.of<CompanyViewModel>(context, listen: false).uID, refresh: true);

      if(result is bool && result){
        _refreshController.loadComplete();
        _refreshController.refreshCompleted();

        setState(() {});
      }else{
        _refreshController.loadComplete();
        _refreshController.refreshCompleted();
        Message.show(widget.globalScaffoldKey, result);
      }

    }catch(error){
      if(!AppConfig.isPublished){
        print('Error: $error');
      }
      _refreshController.loadComplete();
      _refreshController.refreshCompleted();
      Message.show(widget.globalScaffoldKey, AppLocalizations.of(context).translate('receive_error'));
    }
  }

  @override
  bool get wantKeepAlive => true;
}