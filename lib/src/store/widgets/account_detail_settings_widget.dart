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
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/helpers/shared_pref/sp_auth.dart';


class AccountDetailSettingsWidget extends StatelessWidget {
  AccountDetailSettingsWidget({Key? key, required this.refreshAccount})
      : super(key: key);
  final Function refreshAccount;
  final appTranslations = locator<AppTranslations>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Card(
          child: ListTile(
            leading: const Icon(Icons.account_circle),
            title: Text(appTranslations.trans(context, "Update details")),
            onTap: () =>
                Navigator.pushNamed(context, "/account-update").then((onValue) {
              refreshAccount();
            }),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.local_shipping),
            title: Text(appTranslations.trans(context, "Billing/shipping details")),
            onTap: () =>
                Navigator.pushNamed(context, "/account-shipping-details"),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.no_accounts_rounded),
            title: Text(appTranslations.trans(context, "Delete Account")),
            onTap: () => Navigator.pushNamed(context, "/account-delete"),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text(appTranslations.trans(context, "Logout")),
            onTap: () => authLogout(context),
          ),
        ),
      ],
    );
  }
}
