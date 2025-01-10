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
import 'package:sparc_sports_app/src/store/widgets/woosignal_ui.dart';
import 'package:sparc_sports_app/src/store/models/cart_models.dart';


class CheckoutUserDetailsWidget extends StatelessWidget {
  CheckoutUserDetailsWidget(
      {super.key,
      required this.context,
      required this.checkoutSession,
      this.resetState});
  final CheckoutSession checkoutSession;
  final BuildContext context;
  final Function? resetState;
  final appTranslations = locator<AppTranslations>();


  @override
  Widget build(BuildContext context) {
    bool hasUserCheckoutInfo = (checkoutSession.billingDetails != null &&
        checkoutSession.billingDetails!.billingAddress != null);
    return CheckoutRowLine(
      heading: appTranslations.trans( context,"Billing/shipping details"),
      leadImage: const Icon(Icons.home),
      leadTitle: hasUserCheckoutInfo
          ? (checkoutSession.billingDetails == null ||
                  (checkoutSession.billingDetails?.billingAddress
                          ?.hasMissingFields() ??
                      true)
              ? appTranslations.trans(context, "Billing address is incomplete")
              : checkoutSession.billingDetails!.billingAddress?.addressFull())
          : appTranslations.trans(context, "Add billing & shipping details"),
      action: _actionCheckoutDetails,
      showBorderBottom: true,
    );
  }

  _actionCheckoutDetails() {
    Navigator.pushNamed(context, "/checkout-details").then((e) {
      resetState!();
    });
  }
}
