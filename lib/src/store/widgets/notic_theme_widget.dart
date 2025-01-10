//
//  LabelCore
//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//

import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:sparc_sports_app/src/store/classes/app_config.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/helpers/shared_pref/sp_auth.dart';
import 'package:sparc_sports_app/src/store/models/bottom_nav_item.dart';
import 'package:sparc_sports_app/src/store/pages/pages.dart';
import 'package:sparc_sports_app/src/store/widgets/app_loader_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/notic_home_widget.dart';
import 'package:woosignal/models/response/woosignal_app.dart';

class NoticThemeWidget extends StatefulWidget {
  const NoticThemeWidget(
      {super.key, required this.globalKey, required this.wooSignalApp});
  final GlobalKey globalKey;
  final WooSignalApp? wooSignalApp;

  @override
  _NoticThemeWidgetState createState() => _NoticThemeWidgetState();
}

class _NoticThemeWidgetState extends State<NoticThemeWidget> {
  Widget? activeWidget;
  final appTranslations = locator<AppTranslations>();

  int _currentIndex = 0;
  List<BottomNavItem>? allNavWidgets;

  @override
  void initState() {
    super.initState();
    activeWidget = NoticHomeWidget(wooSignalApp: widget.wooSignalApp);
    _loadTabs();
  }

  _loadTabs() async {
    allNavWidgets = await bottomNavWidgets();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: activeWidget,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: allNavWidgets == null
          ? const AppLoaderWidget()
          : BottomNavigationBar(
              onTap: (currentIndex) =>
                  _changeMainWidget(currentIndex, allNavWidgets!),
              currentIndex: _currentIndex,
              unselectedItemColor: Colors.black54,
              fixedColor: Colors.black87,
              selectedLabelStyle: const TextStyle(color: Colors.black),
              unselectedLabelStyle: const TextStyle(
                color: Colors.black87,
              ),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items:
                  allNavWidgets!.map((e) => e.bottomNavigationBarItem).toList(),
            ),
    );
  }

  Future<List<BottomNavItem>> bottomNavWidgets() async {
    List<BottomNavItem> items = [];
    items.add(
      BottomNavItem(
          id: 1,
          bottomNavigationBarItem: BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: appTranslations.translate('Home'),
          ),
          tabWidget: NoticHomeWidget(wooSignalApp: widget.wooSignalApp)),
    );

    items.add(
      BottomNavItem(
          id: 2,
          bottomNavigationBarItem: BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: appTranslations.translate('Search'),
          ),
          tabWidget: const HomeSearchPage()),
    );

    if (AppHelper.instance.appConfig!.wishlistEnabled == true) {
      items.add(BottomNavItem(
        id: 3,
        bottomNavigationBarItem: BottomNavigationBarItem(
          icon: const Icon(Icons.favorite_border),
          label: appTranslations.translate('Wishlist'),
        ),
        tabWidget: WishListPageWidget(),
      ));
    }

    items.add(BottomNavItem(
      id: 4,
      bottomNavigationBarItem: BottomNavigationBarItem(
        icon: const Icon(Icons.shopping_cart),
        label: appTranslations.translate('Cart'),
      ),
      tabWidget: const CartPage(),
    ));

    if (AppHelper.instance.appConfig!.wpLoginEnabled == 1) {
      items.add(BottomNavItem(
        id: 5,
        bottomNavigationBarItem: BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: appTranslations.translate('Account'),
        ),
        tabWidget: (await authCheck())
            ?  AccountDetailPage(showLeadingBackButton: false)
            :  AccountLandingPage(
                showBackButton: false,
              ),
      ));
    }
    return items;
  }

  _changeMainWidget(
      int currentIndex, List<BottomNavItem> bottomNavWidgets) async {
    _currentIndex = currentIndex;
    activeWidget = bottomNavWidgets[_currentIndex].tabWidget;
    setState(() {});
  }
}
