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
import 'package:sparc_sports_app/src/store/enum/toasts_enums.dart';
import 'package:sparc_sports_app/src/store/models/checkout_session.dart';
import 'package:sparc_sports_app/src/store/models/customer_address.dart';
import 'package:sparc_sports_app/src/store/utils/toasts/toast_notification.dart';
import 'package:sparc_sports_app/src/store/widgets/woosignal_ui.dart';
import 'package:woosignal/models/response/woosignal_app.dart';
import 'package:sparc_sports_app/src/store/utils/toasts/toasts.dart';


class CheckoutShippingTypeWidget extends StatelessWidget {
  CheckoutShippingTypeWidget(
      {super.key,
      required this.context,
      required this.wooSignalApp,
      required this.checkoutSession,
      this.resetState});
  final appTranslations = locator<AppTranslations>();

  final CheckoutSession checkoutSession;
  final BuildContext context;
  final Function? resetState;
  final WooSignalApp? wooSignalApp;

  @override
  Widget build(BuildContext context) {
    bool hasDisableShipping = wooSignalApp!.disableShipping == 1;
    if (hasDisableShipping == true) {
      return const SizedBox.shrink();
    }
    bool hasSelectedShippingType = checkoutSession.shippingType != null;
    return CheckoutRowLine(
      heading: appTranslations.trans(context,
          hasSelectedShippingType ? "Shipping selected" : "Select shipping"),
      leadImage: const Icon(Icons.local_shipping),
      leadTitle: hasSelectedShippingType
          ? checkoutSession.shippingType!.getTitle()
          : appTranslations.trans(context,"Select a shipping option"),
      action: _actionSelectShipping,
      showBorderBottom: true,
    );
  }

  _actionSelectShipping() {
    CustomerAddress? shippingAddress =
        checkoutSession.billingDetails!.shippingAddress;
    // ignore: unnecessary_null_comparison
    if (shippingAddress == null || shippingAddress.customerCountry == null) {
      ToastHelper().showToastNotification(
        context,
        title: appTranslations.trans(context,"Oops"),
        description: appTranslations.trans(context,"Add your shipping details first"),
        icon: Icons.local_shipping,
        style: ToastNotificationStyleType.WARNING,
      );
      return;
    }
    Navigator.pushNamed(context, "/checkout-shipping-type")
        .then((value) => resetState!());
  }
}
