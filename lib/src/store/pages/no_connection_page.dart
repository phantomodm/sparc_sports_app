//  StoreMob
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/store/classes/app_config.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/enum/toasts_enums.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/utils/logger.dart';
import 'package:sparc_sports_app/src/store/utils/toasts/toast_notification.dart';
import 'package:sparc_sports_app/src/store/widgets/buttons.dart';
import 'package:sparc_sports_app/src/store/widgets/safearea_widget.dart';
import 'package:woosignal/models/response/woosignal_app.dart';

class NoConnectionPage extends StatefulWidget {
  const NoConnectionPage();

  @override
  _NoConnectionPageState createState() => _NoConnectionPageState();
}

class _NoConnectionPageState extends State<NoConnectionPage> {
  _NoConnectionPageState();
  final appTranslations = locator<AppTranslations>();

  @override
  void initState() {
    super.initState();
    if (getEnv('APP_DEBUG') == true) {
      SparcLogger.error('WooCommerce site is not connected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeAreaWidget(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.error_outline,
                size: 100,
                color: Colors.black54,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  appTranslations.trans(context, "Oops, something went wrong"),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              LinkButton(title: appTranslations.trans(context, "Retry"), action: _retry),
            ],
          ),
        ),
      ),
    );
  }

  _retry() async {
    WooSignalApp? wooSignalApp = await (appWooSignal((api) => api.getApp()));

    if (wooSignalApp == null) {
      if(mounted){
        ToastHelper().showToastNotification(context,
          title: appTranslations.trans(context, "Oops"),
          description: appTranslations.trans(context, "Retry later"),
          style: ToastNotificationStyleType.WARNING);
      }      
      return;
    }

    AppHelper.instance.appConfig = wooSignalApp;
    if(mounted){
      Navigator.pushNamed(context, "/home");
    }
  }
}
