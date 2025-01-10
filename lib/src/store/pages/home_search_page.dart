//  Label StoreMax
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
import 'package:sparc_sports_app/src/store/widgets/buttons.dart';
import 'package:sparc_sports_app/src/store/widgets/safearea_widget.dart';
import '../widgets/woosignal_ui.dart';

class HomeSearchPage extends StatefulWidget {
  const HomeSearchPage();

  @override
  _HomeSearchPageState createState() => _HomeSearchPageState();
}

class _HomeSearchPageState extends State<HomeSearchPage> {
  _HomeSearchPageState();

  final TextEditingController _txtSearchController = TextEditingController();
  final appTranslations = locator<AppTranslations>();

  @override
  void initState() {
    super.initState();
  }

  _actionSearch() {
    Navigator.pushNamed(context, "/product-search",
            arguments: _txtSearchController.text)
        .then((search) {
      if (["notic", "compo"].contains(AppHelper.instance.appConfig!.theme) ==
          false) {
        if (mounted) {
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StoreLogo(height: 55),
        centerTitle: true,
      ),
      body: SafeAreaWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search)),
              controller: _txtSearchController,
              style: Theme.of(context).textTheme.displaySmall,
              keyboardType: TextInputType.text,
              autocorrect: false,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: PrimaryButton(
                title: appTranslations.trans(context, "Search"),
                action: _actionSearch,
              ),
            )
          ],
        ),
      ),
    );
  }
}
