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
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/utils/wooSignal.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:woosignal/models/response/product.dart';

class ProductDetailDescriptionWidget extends StatelessWidget {
  ProductDetailDescriptionWidget({super.key, required this.product});

  final Product? product;
  final appTranslations = locator<AppTranslations>();

  @override
  Widget build(BuildContext context) {
    
    
    if (product!.shortDescription!.isEmpty && product!.description!.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                appTranslations.trans(context, "Description"),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 18),
                textAlign: TextAlign.left,
              ),
              if (product!.shortDescription!.isNotEmpty &&
                  product!.description!.isNotEmpty)
                MaterialButton(
                  height: 50,
                  minWidth: 60,
                  onPressed: () => _modalBottomSheetMenu(context),
                  child: Text(
                    appTranslations.trans(context, "Full description"),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 14),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          child: HtmlWidget(
              product!.shortDescription!.isNotEmpty
                  ? product!.shortDescription!
                  : product!.description!,
              renderMode: RenderMode.column, onTapUrl: (String url) async {
            await launchUrl(Uri.parse(url));
            return true;
          }, textStyle: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }

  _modalBottomSheetMenu(BuildContext context) {
    wsModalBottom(
      context,
      title: appTranslations.trans(context, "Description"),
      bodyWidget: SingleChildScrollView(
        child: HtmlWidget(product!.description!),
      ),
    );
  }
}
