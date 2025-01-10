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
import 'package:sparc_sports_app/src/store/widgets/woosignal_ui.dart';
import 'package:sparc_sports_app/src/store/models/checkout_session.dart';

class CheckoutPaymentTypeWidget extends StatelessWidget {
  CheckoutPaymentTypeWidget(
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
    bool hasPaymentType = checkoutSession.paymentType != null;
    return CheckoutRowLine(
      heading: appTranslations.trans(context, hasPaymentType ? "Payment method" : "Pay with"),
      leadImage: hasPaymentType
          ? Container(
              color: Colors.white,
              child: Image.asset(
                getImageAsset(checkoutSession.paymentType!.assetImage),
                width: 70,
              ),
            )
          : const Icon(Icons.payment),
      leadTitle: hasPaymentType
          ? checkoutSession.paymentType!.desc
          : appTranslations.trans(context, "Select a payment method"),
      action: _actionPayWith,
      showBorderBottom: true,
    );
  }

  _actionPayWith() {
    Navigator.pushNamed(context, "/checkout-payment-type")
        .then((value) => resetState!());
  }
}
