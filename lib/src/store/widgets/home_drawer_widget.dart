//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:sparc_sports_app/src/store/classes/app_config.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/helpers/shared_pref/sp_auth.dart';
import 'package:sparc_sports_app/src/store/widgets/app_version_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/cached_image_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/woosignal_ui.dart';
import 'package:woosignal/models/menu_link.dart';
import 'package:woosignal/models/response/woosignal_app.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeDrawerWidget extends StatefulWidget {
  HomeDrawerWidget({super.key, required this.wooSignalApp});

  final WooSignalApp? wooSignalApp;

  @override
  _HomeDrawerWidgetState createState() => _HomeDrawerWidgetState();
}

class _HomeDrawerWidgetState extends State<HomeDrawerWidget> {
  List<MenuLink> _menuLinks = [];
  String? _themeType;
  final appTranslations = locator<AppTranslations>();

  @override
  void initState() {
    super.initState();
    _menuLinks = AppHelper.instance.appConfig?.menuLinks ?? [];
    _themeType = AppHelper.instance.appConfig!.theme;
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = false;
    return Drawer(
      child: Container(
        color: Theme.of(context).colorScheme.onSurface,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              child: const Center(child: StoreLogo()),
            ),
            if (["compo"].contains(_themeType) == false)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    child: Text(
                      appTranslations.trans(context, "Menu"),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  if (widget.wooSignalApp!.wpLoginEnabled == 1)
                    ListTile(
                      title: Text(
                        appTranslations.trans(context, "Profile"),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 16),
                      ),
                      leading: const Icon(Icons.account_circle),
                      onTap: _actionProfile,
                    ),
                  if (widget.wooSignalApp!.wishlistEnabled == true)
                    ListTile(
                      title: Text(
                        appTranslations.trans(context, "Wishlist"),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 16),
                      ),
                      leading: const Icon(Icons.favorite_border),
                      onTap: _actionWishlist,
                    ),
                  ListTile(
                    title: Text(
                      appTranslations.trans(context, "Cart"),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 16),
                    ),
                    leading: const Icon(Icons.shopping_cart),
                    onTap: _actionCart,
                  ),
                ],
              ),
            if (widget.wooSignalApp!.appTermsLink != null &&
                widget.wooSignalApp!.appPrivacyLink != null)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                child: Text(
                  appTranslations.trans(context, "About Us"),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            if (widget.wooSignalApp!.appTermsLink != null &&
                widget.wooSignalApp!.appTermsLink!.isNotEmpty)
              ListTile(
                title: Text(
                  appTranslations.trans(context, "Terms and conditions"),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 16),
                ),
                leading: const Icon(Icons.menu_book_rounded),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                onTap: () => {},//_actionTerms,
              ),
            if (widget.wooSignalApp!.appPrivacyLink != null &&
                widget.wooSignalApp!.appPrivacyLink!.isNotEmpty)
              ListTile(
                title: Text(
                  appTranslations.trans(context, "Privacy policy"),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 16),
                ),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                leading: const Icon(Icons.account_balance),
                onTap: () => {},//_actionPrivacy,
              ),
            ListTile(
              title: Text(
                // ignore: dead_code
                appTranslations.trans(context, (isDark ? "Light Mode" : "Dark Mode")),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 16),
              ),
              leading: const Icon(Icons.brightness_4_rounded),
              onTap: () {
                // setState(() {
                //   NyTheme.set(context,
                //       id: isDark
                //           ? "default_light_theme"
                //           : "default_dark_theme");
                // });
              },
            ),
            if (_menuLinks.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                child: Text(
                  appTranslations.trans(context, "Social"),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ..._menuLinks
                .where((element) => element.label != "")
                .map((menuLink) => ListTile(
                      title: Text(menuLink.label,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: 16)),
                      leading: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: CachedImageWidget(
                          image: menuLink.iconUrl,
                          width: 40,
                        ),
                      ),
                      onTap: () async =>
                          await launchUrl(Uri.parse(menuLink.linkUrl)),
                    ))
                ,//.toList(),
            ListTile(
              title: AppVersionWidget(),
            ),
          ],
        ),
      ),
    );
  }


  _actionTerms() => openBrowserTab(url: widget.wooSignalApp!.appTermsLink!);

  _actionPrivacy() => openBrowserTab(url: widget.wooSignalApp!.appPrivacyLink!);


  _actionProfile() async {
    Navigator.pop(context);
    if (widget.wooSignalApp!.wpLoginEnabled == 1 && !(await authCheck())) {
      UserAuth.instance.redirect = "/account-detail";
      if(mounted){
      Navigator.pushNamed(context, "/account-landing");
      return;
      }
    }
    if(mounted){
      Navigator.pushNamed(context, "/account-detail");
    }
  }

  _actionWishlist() async {
    Navigator.pop(context);
    Navigator.pushNamed(context, "/wishlist");
  }

  _actionCart() {
    Navigator.pop(context);
    Navigator.pushNamed(context, "/cart");
  }
}
