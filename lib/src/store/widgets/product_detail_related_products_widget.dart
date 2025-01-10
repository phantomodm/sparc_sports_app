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
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/utils/wooSignal.dart';
import 'package:woosignal/models/response/product.dart';
import 'package:woosignal/models/response/woosignal_app.dart';

class ProductDetailRelatedProductsWidget extends StatelessWidget {
  const ProductDetailRelatedProductsWidget(
      {super.key, required this.product, required this.wooSignalApp});

  final Product? product;
  final WooSignalApp? wooSignalApp;

  @override
  Widget build(BuildContext context) {
    final appTranslations = locator<AppTranslations>();

    if (wooSignalApp!.showRelatedProducts == false) {
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
                appTranslations.trans(context, "Related products"),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 18),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 300,
          child: FutureBuilder<List<Product>>(
            future: fetchRelated(),
            builder: (context, relatedProducts) {
              // ignore: unnecessary_null_comparison
              if (relatedProducts == null) return const SizedBox.shrink();

              if (relatedProducts.data!.isEmpty) {
                return const SizedBox.shrink();
              }
              return ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: relatedProducts.data!
                    .map((e) => SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: ProductItemContainer(product: e)))
                    .toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<List<Product>> fetchRelated() async => await (appWooSignal(
        (api) => api.getProducts(perPage: 100, include: product!.relatedIds, status: "publish"),
  ));
}
