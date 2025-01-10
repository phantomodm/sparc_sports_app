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
import 'package:sparc_sports_app/src/store/models/cart_models.dart';


class CheckoutCouponAmountWidget extends StatelessWidget {
  CheckoutCouponAmountWidget({Key? key, required this.checkoutSession})
      : super(key: key);

  final CheckoutSession checkoutSession;
  final appTranslations = locator<AppTranslations>();

  @override
  Widget build(BuildContext context) {
    if (checkoutSession.coupon == null) {
      return const SizedBox.shrink();
    }
    return FutureBuilder<String>(
      future: Cart.getInstance.couponDiscountAmount(),
      builder: (BuildContext context, data) => Padding(
        padding: const EdgeInsets.only(bottom: 0, top: 0),
        child: CheckoutMetaLine(
          title: "${appTranslations.trans(context, 'Coupon')}: ${checkoutSession.coupon?.code}",
          amount: "-${formatStringCurrency(total: data.data.toString())}",
        ),
      ),
    );
  }
}
