//
//  LabelCore
//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//

import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:sparc_sports_app/src/store/enum/toasts_enums.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/models/cart_line_item.dart';
import 'package:sparc_sports_app/src/store/order/order_wc.dart';
import 'package:sparc_sports_app/src/store/pages/checkout_confirmation_page.dart';
import 'package:sparc_sports_app/src/store/utils/toasts/toast_notification.dart';
import 'package:sparc_sports_app/src/store/widgets/checkout_paypal.dart';
import 'package:woosignal/models/payload/order_wc.dart';
import 'package:woosignal/models/response/order.dart';
import 'package:woosignal/models/response/tax_rate.dart';


payPalPay(context,
    {required CheckoutConfirmationPageState state, TaxRate? taxRate}) async {
  await checkout(taxRate, (total, billingDetails, cart) async {
    List<CartLineItem> cartLineItems = await cart.getCart();
    String description = await cart.cartShortDesc();
    final appTranslations = locator<AppTranslations>();

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PayPalCheckout(
                description: description,
                amount: total,
                cartLineItems: cartLineItems)
        )
    ).then((value) async {
      if (value is! Map<String, dynamic>) {
          ToastHelper().showToastNotification(
            context,
            title: appTranslations.translate("Payment Cancelled"),
            description: appTranslations.translate("The payment has been cancelled"),
            style: ToastNotificationStyleType.WARNING
          );
        state.reloadState(showLoader: false);
        return;
      }

      state.reloadState(showLoader: true);
      if (value.containsKey("status") && value["status"] == "success") {
        OrderWC orderWC = await buildOrderWC(taxRate: taxRate, markPaid: true);
        Order? order = await (appWooSignal((api) => api.createOrder(orderWC)));

        if (order == null) {
          ToastHelper().showToastNotification(
            context,
            title: appTranslations.translate("Error"),
            description:
                appTranslations.translate("Something went wrong, please contact our store"),
            style: ToastNotificationStyleType.DANGER
          );
          return;
        }
        Navigator.pushNamed(context, "/checkout-status", arguments: order);
        return;
      } else {
        ToastHelper().showToastNotification(
          context,
          title: appTranslations.translate("Payment Cancelled"),
          description: appTranslations.translate("The payment has been cancelled"),
          style: ToastNotificationStyleType.WARNING
        );
      }
    });

    state.reloadState(showLoader: false);
  });
}
