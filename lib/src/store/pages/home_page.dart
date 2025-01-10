import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/store/classes/app_config.dart';
import 'package:sparc_sports_app/src/store/widgets/compo_theme_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/mello_theme_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/notic_theme_widget.dart';
import 'package:woosignal/models/response/woosignal_app.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final GlobalKey _key = GlobalKey();
  final WooSignalApp? _wooSignalApp = AppHelper.instance.appConfig;

  @override
  Widget build(BuildContext context) {
    print(WooSignalApp);
    Widget theme = MelloThemeWidget(globalKey: _key,wooSignalApp: _wooSignalApp);
    print(AppHelper.instance.appConfig?.theme == 'notic');
    if(AppHelper.instance.appConfig?.theme == 'notic'){
      theme = NoticThemeWidget(globalKey: _key, wooSignalApp: _wooSignalApp);
    }
    if(AppHelper.instance.appConfig?.theme == 'compo'){
      theme = CompoThemeWidget(globalKey: _key, wooSignalApp: _wooSignalApp);
    }
    return theme;
  }
}