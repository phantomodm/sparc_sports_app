//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/classes/app_config.dart';
import 'package:sparc_sports_app/src/store/classes/sparc_widgets.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/models/cart_models.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:woosignal/models/response/woosignal_app.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';


class PayPalCheckout extends StatefulWidget {
  final String? description;
  final String? amount;
  final List<CartLineItem>? cartLineItems;

  const PayPalCheckout(
      {super.key, this.description, this.amount, this.cartLineItems});

  @override
  WebViewState createState() => WebViewState();
}

class WebViewState extends SparcState<PayPalCheckout> {
  /*final Completer<WebViewController> _controller =
      Completer<WebViewController>();*/

  String? payerId = '';
  int intCount = 0;
  StreamSubscription<String>? _onUrlChanged;
  final WooSignalApp? _wooSignalApp = AppHelper.instance.appConfig;
  String? formCheckoutShippingAddress;
  late final WebViewController _controller;
  final appTranslations = locator<AppTranslations>();

  setCheckoutShippingAddress(CustomerAddress customerAddress) {
    String tmp = "";
    if (customerAddress.firstName != null) {
      tmp +=
          '<input type="hidden" name="first_name" value="${customerAddress.firstName!.replaceAll(RegExp(r'[^\d\w\s,\-+]+'), '')}">\n';
    }
    if (customerAddress.lastName != null) {
      tmp +=
          '<input type="hidden" name="last_name" value="${customerAddress.lastName!.replaceAll(RegExp(r'[^\d\w\s,\-+]+'), '')}">\n';
    }
    if (customerAddress.addressLine != null) {
      tmp +=
          '<input type="hidden" name="address1" value="${customerAddress.addressLine!.replaceAll(RegExp(r'[^\d\w\s,\-+]+'), '')}">\n';
    }
    if (customerAddress.city != null) {
      tmp +=
          '<input type="hidden" name="city" value="${customerAddress.city!.replaceAll(RegExp(r'[^\d\w\s,\-+]+'), '')}">\n';
    }
    if (customerAddress.customerCountry!.hasState() &&
        customerAddress.customerCountry!.state!.name != null) {
      tmp +=
          '<input type="hidden" name="state" value="${customerAddress.customerCountry!.state!.name!.replaceAll(RegExp(r'[^\d\w\s,\-+]+'), '')}">\n';
    }
    if (customerAddress.postalCode != null) {
      tmp +=
          '<input type="hidden" name="zip" value="${customerAddress.postalCode!.replaceAll(RegExp(r'[^\d\w\s,\-+]+'), '')}">\n';
    }
    if (customerAddress.customerCountry!.countryCode != null) {
      tmp +=
          '<input type="hidden" name="country" value="${customerAddress.customerCountry!.countryCode!.replaceAll(RegExp(r'[^\d\w\s,\-+]+'), '')}">\n';
    }
    formCheckoutShippingAddress = tmp;
  }

  String getPayPalItemName() {
    return truncateString(
        widget.description!.replaceAll(RegExp(r'[^\w\s]+'), ''), 124);
  }

  String getPayPalPaymentType() {
    return Platform.isAndroid ? "PayPal - Android App" : "PayPal - IOS App";
  }

  String getPayPalUrl() {
    bool? liveMode =
        envVal('PAYPAL_LIVE_MODE', defaultValue: _wooSignalApp!.paypalLiveMode);
    return liveMode == true
        ? "https://www.paypal.com/cgi-bin/webscr"
        : "https://www.sandbox.paypal.com/cgi-bin/webscr";
  }

  @override
  void initState() {
    super.initState();
    setCheckoutShippingAddress(
        CheckoutSession.getInstance.billingDetails!.shippingAddress!);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(_loadHTML()) // Load your HTML string
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar or show progress indicator
          },
          onPageStarted: (String url) {
            // Handle page start (e.g., show loading indicator)
          },
          onPageFinished: (String url) {
            // Handle page finish (e.g., hide loading indicator)
            if (intCount > 0) {
              url = url.replaceAll("~", "_");
            }

            intCount = intCount + 1;
            if (url.contains("payment_success")) {
              var uri = Uri.parse(url);
              setState(() {
                payerId = uri.queryParameters['PayerID'];
              });
              Navigator.pop(context, {
                "status": payerId == null ? "cancelled" : "success",
                "payerId": payerId
              });
            } else if (url.contains("payment_failure")) {
              Navigator.pop(context, {"status": "cancelled"});
            }
          },
          onWebResourceError: (WebResourceError error) {
            // Handle web resource errors
            print("Web resource error: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            // Control navigation requests (you can customize this logic)
            return NavigationDecision.navigate;
          },
        ),
      );
    setState(() {});
  }

  @override
  void dispose() {
    if (_onUrlChanged != null) {
      _onUrlChanged!.cancel();
    }
    super.dispose();
  }

  String _loadHTML() {
    final String strProcessingPayment = appTranslations.trans(context, "Processing Payment");
    final String strPleaseWait = appTranslations.trans(context,
        "Please wait, your order is being processed and you will be redirected to the PayPal website.");
    final String strRedirectMessage = appTranslations.trans(context,
        "If you are not automatically redirected to PayPal within 5 seconds");

    return '''
      <html><head><title>$strProcessingPayment...</title></head>
<body onload="document.forms['paypal_form'].submit();">
<div style="text-align:center;">
<img src="https://woosignal.com/images/paypal_logo.png" height="50" />
</div>
<center><h4>$strPleaseWait</h4></center>
<form method="post" name="paypal_form" action="${getPayPalUrl()}">
<input type="hidden" name="cmd" value="_xclick">
<input type="hidden" name="amount" value="${widget.amount}">
<input type="hidden" name="lc" value="${envVal('PAYPAL_LOCALE', defaultValue: _wooSignalApp!.paypalLocale)}">
<input type="hidden" name="currency_code" value="${_wooSignalApp.currencyMeta!.code}">
<input type="hidden" name="business" value="${envVal('PAYPAL_ACCOUNT_EMAIL', defaultValue: _wooSignalApp.paypalEmail)}">
<input type="hidden" name="return" value="https://woosignal.com/paypal/payment~success">
<input type="hidden" name="cancel_return" value="https://woosignal.com/paypal/payment~failure">
<input type="hidden" name="item_name" value="${getPayPalItemName()}">
<input type="hidden" name="custom" value="${getPayPalPaymentType()}">
<input type="hidden" name="address_override" value="1">
$formCheckoutShippingAddress
<center><br><br>$strRedirectMessage...<br><br>
<input type="submit" value="Click Here"></center>
</form></body></html>
'''
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: WebViewWidget(
            controller: _controller,
        )
      ),
    );

}}
