//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/store/bloc/cart_bloc.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:woosignal/models/response/product.dart';
import 'package:woosignal/models/response/product_variation.dart'
    as ws_product_variation;

import '../models/cart_models.dart';
import 'controller.dart';

class ProductDetailController extends Controller {
  int quantity = 1;
  Product? product;
  final appTranslations = locator<AppTranslations>();
  final cartBloc = locator<CartBloc>();

  @override
  construct(BuildContext context) {
    super.construct(context);
    this.context = context;
    //product = data() as Product?;
  }
   viewExternalProduct() {
     if (product!.externalUrl != null && product!.externalUrl!.isNotEmpty) {
       openBrowserTab(url: product!.externalUrl!);
     }
   }

   itemAddToCart(BuildContext context,
       {required CartLineItem cartLineItem, Function? onSuccess}) async {

     print('Controller adding to Cart Bloc');
     cartBloc.add(AddToCart(cartLineItem, context));
     await Cart.getInstance.addToCart(cartLineItem: cartLineItem);

     showStatusAlert(
       context,
       title: appTranslations.translate("Success"),
       subtitle: appTranslations.translate("Added to cart"),
       duration: 1,
       icon: Icons.add_shopping_cart,
     );
     //updateState(CartQuantity.state);
     if (onSuccess != null) {
       onSuccess();
     }

   }

  ws_product_variation.ProductVariation? findProductVariation(
      {required Map<int, dynamic> tmpAttributeObj,
      required List<ws_product_variation.ProductVariation> productVariations}) {
    ws_product_variation.ProductVariation? tmpProductVariation;

    Map<String?, dynamic> tmpSelectedObj = {};
    for (var attributeObj in tmpAttributeObj.values) {
      tmpSelectedObj[attributeObj["name"]] = attributeObj["value"];
    }

    for (var productVariation in productVariations) {
      Map<String?, dynamic> tmpVariations = {};

      for (var attr in productVariation.attributes) {
        tmpVariations[attr.name] = attr.option;
      }

      if (tmpVariations.toString() == tmpSelectedObj.toString()) {
        tmpProductVariation = productVariation;
      }
    }

    return tmpProductVariation;
  }
}
