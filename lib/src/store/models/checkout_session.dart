//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'dart:convert';
import 'package:sparc_sports_app/src/store/classes/app_config.dart';
import 'package:sparc_sports_app/src/core/boot/init.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/models/cart_models.dart';
import 'package:woosignal/models/response/coupon.dart';
import 'package:woosignal/models/response/tax_rate.dart';

class CheckoutSession {
  bool? shipToDifferentAddress = false;

  CheckoutSession._privateConstructor();
  static final CheckoutSession getInstance = CheckoutSession._privateConstructor();

  BillingDetails? billingDetails;
  ShippingType? shippingType;
  PaymentType? paymentType;
  Coupon? coupon;

  void initSession() {
    billingDetails = BillingDetails();
    shippingType = null;
  }

  void clear() {
    billingDetails = null;
    shippingType = null;
    paymentType = null;
    coupon = null;
  }

  saveBillingAddress() async {
    CustomerAddress? customerAddress =
        CheckoutSession.getInstance.billingDetails!.billingAddress;

    if (customerAddress == null) {
      return;
    }

    String billingAddress = jsonEncode(customerAddress.toJson());
    await prefs.setString(SharedKey.customerBillingDetails, billingAddress);
  }

  Future<CustomerAddress?> getBillingAddress() async {
    String? strCheckoutDetails =
        (prefs.getString(SharedKey.customerBillingDetails));

    if (strCheckoutDetails != null && strCheckoutDetails != "") {
      return CustomerAddress.fromJson(jsonDecode(strCheckoutDetails));
    }
    return null;
  }

  clearBillingAddress() async {
    await prefs.remove(SharedKey.customerBillingDetails);
  }
      

  saveShippingAddress() async {
    CustomerAddress? customerAddress =
        CheckoutSession.getInstance.billingDetails!.shippingAddress;
    if (customerAddress == null) {
      return;
    }
    String shippingAddress = jsonEncode(customerAddress.toJson());
    await prefs.setString(SharedKey.customerShippingDetails, shippingAddress);
  }

  Future<CustomerAddress?> getShippingAddress() async {
    String? strCheckoutDetails =
        (prefs.getString(SharedKey.customerShippingDetails));
    if (strCheckoutDetails != null && strCheckoutDetails != "") {
      return CustomerAddress.fromJson(jsonDecode(strCheckoutDetails));
    }
    return null;
  }

  clearShippingAddress() async =>
        await prefs.remove(SharedKey.customerShippingDetails);

  Future<String> total({bool withFormat = false, TaxRate? taxRate}) async {
    double totalCart = parseWcPrice(await Cart.getInstance.getTotal());
    double totalShipping = 0;
    if (shippingType != null && shippingType!.object != null) {
      switch (shippingType!.methodId) {
        case "flat_rate":
          totalShipping = parseWcPrice(shippingType!.cost);
          break;
        case "free_shipping":
          totalShipping = parseWcPrice(shippingType!.cost);
          break;
        case "local_pickup":
          totalShipping = parseWcPrice(shippingType!.cost);
          break;
        default:
          break;
      }
    }

    double total = totalCart + totalShipping;

    if (taxRate != null) {
      String taxAmount = await Cart.getInstance.taxAmount(taxRate);
      total += parseWcPrice(taxAmount);
    }

    if (withFormat == true) {
      return formatDoubleCurrency(total: total);
    }
    return total.toStringAsFixed(2);
  }
}
