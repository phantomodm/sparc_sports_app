//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';

class TopNavWidget extends StatelessWidget {
  TopNavWidget({super.key, this.onPressBrowseCategories});
  final Function()? onPressBrowseCategories;
  final appTranslations = locator<AppTranslations>();


  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "${(appTranslations.trans(context, "Shop").capitalize())} / ",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
              AutoSizeText(
                appTranslations.trans(context, "Newest"),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
            ],
          ),
          Flexible(
            child: MaterialButton(
              minWidth: 100,
              height: 60,
              onPressed:
                () => {
                  if(onPressBrowseCategories != null){
                    onPressBrowseCategories!() // Call the function only if it's not null
                  }
                },
              child: AutoSizeText(
                appTranslations.trans(context, "Browse categories"),
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 1,
                textAlign: TextAlign.right,
              ),
            ),
          )
        ],
      );
}
