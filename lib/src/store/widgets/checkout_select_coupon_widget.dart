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
import 'package:sparc_sports_app/src/store/utils/toasts/toast_notification.dart';
import 'package:sparc_sports_app/src/store/models/checkout_session.dart';
import 'package:sparc_sports_app/src/store/utils/toasts/toasts.dart';


class CheckoutSelectCouponWidget extends StatelessWidget {
  CheckoutSelectCouponWidget(
      {Key? key,
      required this.context,
      required this.checkoutSession,
      required this.resetState})
      : super(key: key);

  final CheckoutSession checkoutSession;
  final BuildContext context;
  final Function resetState;
  final appTranslations = locator<AppTranslations>();

  @override
  Widget build(BuildContext context) {
    bool hasCoupon = checkoutSession.coupon != null;
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: _actionCoupon,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasCoupon == true)
              IconButton(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  onPressed: _clearCoupon,
                  icon: const Icon(
                    Icons.close,
                    size: 19,
                  )),
            Text(
              hasCoupon
                  ? "Coupon Applied: ${checkoutSession.coupon!.code!}"
                  : appTranslations.trans(context, 'Apply Coupon'),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }

  _clearCoupon() {
    CheckoutSession.getInstance.coupon = null;
    resetState();
  }

  _actionCoupon() {
    if (checkoutSession.billingDetails!.billingAddress == null) {
      ToastHelper().showToastNotification(
        context,
        title: appTranslations.trans(context,"Oops"),
        description:
            appTranslations.trans(context, "Please select add your billing/shipping address to proceed"),
        style: ToastNotificationStyleType.WARNING,
        icon: Icons.local_shipping,
      );

      return;
    }
    if (checkoutSession.billingDetails?.billingAddress?.hasMissingFields() ??
        true) {
      ToastHelper().showToastNotification(
        context,
        title: appTranslations.trans(context,"Oops"),
        description: appTranslations.trans(context,"Your billing/shipping details are incomplete"),
        style: ToastNotificationStyleType.WARNING,
        icon: Icons.local_shipping,
      );
      return;
    }
    Navigator.pushNamed(context, "/checkout-coupons")
        .then((value) => resetState());
  }
}
