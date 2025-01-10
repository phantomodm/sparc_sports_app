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

class NoResultsForProductsWidget extends StatelessWidget {
  NoResultsForProductsWidget({super.key});
  final appTranslations = locator<AppTranslations>();

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          Text(
            appTranslations.trans(context, "No results"),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      );
}
