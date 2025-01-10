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
import 'package:sparc_sports_app/src/store/widgets/buttons.dart';
import 'package:sparc_sports_app/src/store/widgets/product_quantity_widget.dart';
import 'package:woosignal/models/response/product.dart';

class ProductDetailFooterActionsWidget extends StatelessWidget {
  ProductDetailFooterActionsWidget(
      {super.key,
      required this.product,
      required this.quantity,
      required this.onAddToCart,
      required this.onViewExternalProduct,
      required this.onAddQuantity,
      required this.onRemoveQuantity});
  final Product? product;
  final Function onViewExternalProduct;
  final Function onAddToCart;
  final Function onAddQuantity;
  final Function onRemoveQuantity;
  final int quantity;

  final appTranslations = locator<AppTranslations>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15.0,
            spreadRadius: -17,
            offset: Offset(
              0,
              -10,
            ),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (product!.type != "external")
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  appTranslations.trans(context, "Quantity"),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.grey),
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        size: 28,
                      ),
                      onPressed: onRemoveQuantity as void Function()?,
                    ),
                    ProductQuantity(productId: product!.id!),
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle_outline,
                        size: 28,
                      ),
                      onPressed: onAddQuantity as void Function()?,
                    ),
                  ],
                )
              ],
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                  child: Align(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(
                  formatStringCurrency(
                      total:
                          (parseWcPrice(product!.price) * quantity).toString()),
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              )),
              product!.type == "external"
                  ? Flexible(
                      child: PrimaryButton(
                        title: appTranslations.trans(context, "Buy Product"),
                        action: onViewExternalProduct,
                      ),
                    )
                  : Flexible(
                      child: PrimaryButton(
                        title: appTranslations.trans(context, "Add to cart"),
                        action: onAddToCart,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
