//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/enum/toasts_enums.dart';
import 'package:sparc_sports_app/src/store/helpers/shared_pref/sp_auth.dart';
import 'package:sparc_sports_app/src/store/utils/toasts/toast_notification.dart';
import 'package:sparc_sports_app/src/store/widgets/store_widgets.dart';
import 'package:wp_json_api/exceptions/invalid_user_token_exception.dart';
import 'package:wp_json_api/models/responses/wc_customer_info_response.dart';
import 'package:wp_json_api/wp_json_api.dart';

class AccountDetailPage extends StatefulWidget {
  final bool showLeadingBackButton;
  final appTranslations = locator<AppTranslations>();

  AccountDetailPage({this.showLeadingBackButton = true});

  @override
  _AccountDetailPageState createState() => _AccountDetailPageState();
}

class _AccountDetailPageState extends State<AccountDetailPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool _isLoading = true;
  int _currentTabIndex = 0;
  WCCustomerInfoResponse? _wcCustomerInfoResponse;
  final appTranslations = locator<AppTranslations>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _fetchWpUserData();
  }

  _fetchWpUserData() async {
    String? userToken = await readAuthToken();

    WCCustomerInfoResponse? wcCustomerInfoResponse;
    try {
      wcCustomerInfoResponse = await WPJsonAPI.instance
          .api((request) => request.wcCustomerInfo(userToken:userToken!));
    } on InvalidUserTokenException catch (_) {
      if(mounted){
        ToastHelper().showToastNotification(
        context,
        title: appTranslations.trans(context, "Oops!"),
        description: appTranslations.trans(context, "Something went wrong"),
        style: ToastNotificationStyleType.DANGER,
      );
      await authLogout(context);
      }
      
    } on Exception catch (_) {
      if(mounted){
      ToastHelper().showToastNotification(
        context,
        title: appTranslations.trans(context, "Oops!"),
        description: appTranslations.trans(context, "Something went wrong"),
        style: ToastNotificationStyleType.DANGER,
      );}
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    if (wcCustomerInfoResponse != null &&
        wcCustomerInfoResponse.status == 200) {
      setState(() {
        _wcCustomerInfoResponse = wcCustomerInfoResponse;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? activeBody;
    if (_currentTabIndex == 0) {
      activeBody = AccountDetailOrdersWidget();
    } else if (_currentTabIndex == 1) {
      activeBody = AccountDetailSettingsWidget(
        refreshAccount: () {
          setState(() {
            _isLoading = true;
          });
          _fetchWpUserData();
        },
      );
    }

    if (activeBody == null) {
      return const SizedBox.shrink();
    }
    String? userAvatar;
    String? userFirstName = "";
    String? userLastName = "";
    if (_wcCustomerInfoResponse != null &&
        _wcCustomerInfoResponse!.data != null) {
      userAvatar = _wcCustomerInfoResponse!.data!.avatar;

      userFirstName = _wcCustomerInfoResponse!.data!.firstName;
      userLastName = _wcCustomerInfoResponse!.data!.lastName;
    }
    return Scaffold(
      appBar: AppBar(
        leading: widget.showLeadingBackButton
            ? Container(
                margin: const EdgeInsets.only(left: 0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context),
                ),
              )
            : Container(),
        title: Text(appTranslations.trans(context, "Account")),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeAreaWidget(
        child: _isLoading
            ? const AppLoaderWidget()
            : Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow:
                          (Theme.of(context).brightness == Brightness.light)
                              ? wsBoxShadow()
                              : null,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              height: 90,
                              width: 90,
                              child: userAvatar != null
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(userAvatar),
                                    )
                                  : const Icon(
                                      Icons.account_circle_rounded,
                                      size: 65,
                                    ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  [userFirstName, userLastName]
                                      .where((t) => (t != null || t != ""))
                                      .toList()
                                      .join(" "),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TabBar(
                            tabs: [
                              Tab(text: appTranslations.trans(context, "Orders")),
                              Tab(text: appTranslations.trans(context, "Settings")),
                            ],
                            controller: _tabController,
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.black87,
                            indicator: const BubbleTabIndicator(
                              indicatorHeight: 30.0,
                              indicatorRadius: 5,
                              indicatorColor: Colors.black87,
                              tabBarIndicatorSize: TabBarIndicatorSize.tab,
                            ),
                            onTap: _tabsTapped,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: activeBody),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  _tabsTapped(int i) {
    setState(() {
      _currentTabIndex = i;
    });
  }
}
