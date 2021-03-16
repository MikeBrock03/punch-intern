import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'config/app_config.dart';
import 'constants/app_colors.dart';
import 'database/storage.dart';
import 'helpers/app_localizations.dart';
import 'view_models/font_size_controller.dart';
import 'views/splash/splash.dart';

void main() {
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider<FontSizeController>(create: (BuildContext context) => FontSizeController()),
          ],
          child: App()
      )
  );
}

class App extends StatelessWidget {

  final Storage storage = new Storage();

  @override
  Widget build(BuildContext context) {

    FontSizeController fontSizeController = Provider.of<FontSizeController>(context, listen: false);

    return MaterialApp(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          backgroundColor: Colors.white,
          primaryColor:  AppColors.primaryColor,
          primarySwatch: AppColors.materialAccentColor,
          canvasColor:   Colors.transparent,
        ),

        supportedLocales: [
          const Locale('en', 'US'),
        ],

        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],

        localeResolutionCallback: (locale, supportedLocales) {
          if (locale == null) {
            return supportedLocales.first;
          }

          for(var supportedLocale in supportedLocales){
            if(supportedLocale.languageCode == locale.languageCode && supportedLocale.countryCode == locale.countryCode){
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },

        builder: (BuildContext context, Widget child){

          final MediaQueryData data = MediaQuery.of(context);
          fontSizeController.setBaseTextScaleFactor(data.textScaleFactor > 1.3 ? 1.3 : data.textScaleFactor);
          storage.saveDouble('base_scale', fontSizeController.baseTextScaleFactor);
          getSize(fontSizeController);

          return Consumer<FontSizeController>(
            builder: (cnx, value, ch){
              return MediaQuery(
                data: data.copyWith(textScaleFactor: fontSizeController.baseTextScaleFactor + (value.value)  > 1.3 ? 1.3 : fontSizeController.baseTextScaleFactor + (value.value)),
                child: Splash(),
              );
            },
          );
        },

        home: Splash()
    );
  }

  void getSize(FontSizeController fontSizeController) async{

    double baseScale;
    int currentScale = 0;

    try{
      baseScale = await storage.getDouble('base_scale');
      currentScale = await storage.getInteger('current_scale');
    }catch(error){
      if(!AppConfig.isPublished){
        print(error);
      }
    }finally{
      if(baseScale != fontSizeController.baseTextScaleFactor){
        fontSizeController.reset();
      }else{
        if(currentScale != null){

          switch (currentScale.toInt()){
            case 1:
              fontSizeController.set(-0.2);
              break;
            case 2:
              fontSizeController.set(-0.1);
              break;
            case 3:
              fontSizeController.reset();
              break;
            case 4:
              fontSizeController.set(0.1);
              break;
            case 5:
              fontSizeController.set(0.2);
              break;
          }
        }else{
          fontSizeController.reset();
        }
      }
    }
  }
}