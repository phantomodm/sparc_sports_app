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
import 'package:sparc_sports_app/src/store/models/cart_models.dart';
import 'package:sparc_sports_app/src/store/utils/toasts/toast_notification.dart';
import 'package:sparc_sports_app/src/store/widgets/store_widgets.dart';

import 'package:woosignal/models/response/coupon.dart';

import '../enum/toasts_enums.dart';

class CouponPage extends StatefulWidget {
  @override
  _CouponPageState createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  List<Coupon> _coupons = [];
  bool _isLoading = false;

  final couponController = TextEditingController();
  final appTranslations = locator<AppTranslations>();

  _showAlert({required String message, ToastNotificationStyleType? style}) {
   ToastHelper().showToastNotification(
      context,
      title: appTranslations.trans(context, 'Coupon'),
      description: message,
      style: style ?? ToastNotificationStyleType.SUCCESS,
      icon: Icons.call_to_action,
    );
  }

  _successAddCoupon(Coupon coupon) {
    _showAlert(message: appTranslations.trans(context, "Added to checkout"));
    CheckoutSession.getInstance.coupon = coupon;

    Navigator.of(context).pop();
  }

  Future<void> findCoupon(String couponCode) async {
    setState(() {
      _isLoading = true;
    });

    _coupons = await (appWooSignal(
      (api) => api.getCoupons(code: couponCode, perPage: 100),
    ));

    setState(() {
      _isLoading = false;
    });
  }

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CheckoutSession checkoutSession = CheckoutSession.getInstance;
    return Scaffold(
      body: SafeAreaWidget(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Icon(Icons.local_offer_outlined, size: 30),
            Text(
              appTranslations.trans(context, 'Redeem Coupon'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                autofocus: true,
                controller: couponController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return appTranslations.trans(context, 'Please enter coupon to redeem');
                  }
                  return null;
                },
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 0.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 0.0),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColorLight)),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: appTranslations.trans(context, 'Add coupon code'),
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            (_isLoading == true)
                ? AppLoaderWidget()
                : PrimaryButton(
                    action: () => _applyCoupon(checkoutSession),
                    title: appTranslations.trans(context, 'Apply'),
                  ),
            LinkButton(
                title: appTranslations.trans(context, "Cancel"), action: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  _applyCoupon(CheckoutSession checkoutSession) async {
    await findCoupon(couponController.text);

    if (_formKey.currentState!.validate()) {
      // No coupons found
      if (_coupons.isEmpty) {
        _showAlert(
            message: "${appTranslations.trans(context,'Coupon not found')}.",
            style: ToastNotificationStyleType.WARNING);
        return;
      }

      Coupon coupon = _coupons.first;

      DateTime dateNow = DateTime.now();
      List<CartLineItem> cart = await Cart.getInstance.getCart();
      List<int?> productIds = cart.map((e) => e.productId).toList();

      // Check excludedProductIds
      for (var productId in productIds) {
        if (coupon.excludedProductIds!.contains(productId)) {
          _showAlert(
              message:
                  "${appTranslations.trans(context,'Sorry, this coupon can not be used with your cart')}.",
              style: ToastNotificationStyleType.INFO);
          return;
        }
      }

      // Check email restrictions
      String? emailAddress =
          checkoutSession.billingDetails!.billingAddress?.emailAddress;
      if (coupon.emailRestrictions!.contains(emailAddress)) {
        _showAlert(
            message: appTranslations.trans(context, 'You cannot redeem this coupon'),
            style: ToastNotificationStyleType.DANGER);
        return;
      }

      // Check for minimum amount
      double minimumAmount = double.parse(coupon.minimumAmount!);
      String strSubtotal = await Cart.getInstance.getSubtotal();
      double doubleSubtotal = double.parse(strSubtotal);
      if (minimumAmount != 0 && doubleSubtotal < minimumAmount) {
        _showAlert(
            message: appTranslations.trans(context, "Spend a minimum of minimumAmount to redeem",
                arguments: {
                  "minimumAmount":
                      formatStringCurrency(total: minimumAmount.toString())
                }),
            style: ToastNotificationStyleType.DANGER);
        return;
      }

      // Check maximum amount
      double maximumAmount = double.parse(coupon.maximumAmount!);
      if (maximumAmount != 0 && doubleSubtotal > maximumAmount) {
        _showAlert(
            message: appTranslations.trans(context, "Spend less than maximumAmount to redeem",
                arguments: {
                  "maximumAmount":
                      formatStringCurrency(total: maximumAmount.toString())
                }),
            style: ToastNotificationStyleType.DANGER);
        return;
      }

      // Check if coupon has expired
      if (coupon.dateExpires != null &&
          dateNow.isAfter(
            DateTime.parse(coupon.dateExpires!),
          )) {
        _showAlert(
            message: appTranslations.trans(context, "This coupon has expired"),
            style: ToastNotificationStyleType.WARNING);
        return;
      }

      // Check usage limit
      if (coupon.usageLimit != null &&
          coupon.usageCount! >= coupon.usageLimit!) {
        _showAlert(
            message: appTranslations.trans(context, "Usage limit has been reached"),
            style: ToastNotificationStyleType.WARNING);
        return;
      }

      // Check usage limit per user
      int? limitPerUser = coupon.usageLimitPerUser;
      if (limitPerUser != null &&
          coupon.usedBy!
                  .map((e) => e.toLowerCase())
                  .where((usedBy) => usedBy == emailAddress!.toLowerCase())
                  .length >=
              limitPerUser) {
        _showAlert(
            message: "${appTranslations.trans(context,'You cannot redeem this coupon')}.",
            style: ToastNotificationStyleType.WARNING);
        return;
      }

      _successAddCoupon(coupon);
    }
  }
}
