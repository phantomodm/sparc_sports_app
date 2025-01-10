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
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';

class AppVersionWidget extends StatelessWidget {
  AppVersionWidget({Key? key}) : super(key: key);
  final appTranslations = locator<AppTranslations>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (BuildContext context, data) => Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        child: Text("${appTranslations.trans(context,"Version")}: ${data.data?.version}",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w300)),
      ),
      //loading: SizedBox.shrink(),
    );
  }
}
