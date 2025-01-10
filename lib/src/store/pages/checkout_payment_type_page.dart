//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/store/classes/sparc_widgets.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';


import '../classes/sparc_classes.dart';
import '../models/cart_models.dart';
import '../widgets/store_widgets.dart';


class CheckoutPaymentTypePage extends StatefulWidget {
  CheckoutPaymentTypePage();

  @override
  _CheckoutPaymentTypePageState createState() =>
      _CheckoutPaymentTypePageState();
}

class _CheckoutPaymentTypePageState extends SparcState<CheckoutPaymentTypePage> {
  _CheckoutPaymentTypePageState();

  List<PaymentType?> _paymentTypes = [];
  final appTranslations = locator<AppTranslations>();
  @override
  initState() async {
    super.initState();

    _paymentTypes = await getPaymentTypes();

    if (_paymentTypes.isEmpty &&
        getEnv('APP_DEBUG', defaultValue: false) == true) {
      SparcLogger().
info(
          'You have no payment methods set. Visit the WooSignal dashboard (https://woosignal.com/dashboard) to set a payment method.');
    }

    // print(CheckoutSession.getInstance.paymentType?.name);
    if (CheckoutSession.getInstance.paymentType == null) {
      if (_paymentTypes.isNotEmpty) {
        CheckoutSession.getInstance.paymentType = _paymentTypes.firstWhere(
            (paymentType) => paymentType?.id == 20,
            orElse: () => _paymentTypes.first);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(appTranslations.trans(context, "Payment Method")),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SafeAreaWidget(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: LayoutBuilder(
            builder: (context, constraints) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  child: Center(
                    child: Image.asset(getImageAsset("credit_cards.png"),
                        fit: BoxFit.fitHeight, height: 100),
                  ),
                  padding: EdgeInsets.only(top: 20),
                ),
                SizedBox(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          child: _paymentTypes.isEmpty
                              ? Container(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(
                                    appTranslations.trans(context, "No payment methods are available"),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: _paymentTypes.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    PaymentType paymentType =
                                        _paymentTypes[index]!;

                                    return ListTile(
                                      contentPadding: EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 8,
                                        right: 8,
                                      ),
                                      leading: Container(
                                        decoration:
                                            BoxDecoration(color: Colors.white),
                                        padding: EdgeInsets.all(4),
                                        child: Image.asset(
                                          getImageAsset(paymentType.assetImage),
                                          width: 60,
                                          fit: BoxFit.contain,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                      title: Text(paymentType.desc,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                      selected: true,
                                      trailing: (CheckoutSession.getInstance
                                                  .paymentType?.id ==
                                              paymentType.id
                                          ? Icon(Icons.check)
                                          : null),
                                      onTap: () {
                                        CheckoutSession.getInstance
                                            .paymentType = paymentType;
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                  separatorBuilder: (cxt, i) => Divider(
                                    color: Colors.black12,
                                  ),
                                ),
                        ),
                        LinkButton(
                          title: appTranslations.trans(context, "CANCEL"),
                          action: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurface,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow:
                          (Theme.of(context).brightness == Brightness.light)
                              ? wsBoxShadow()
                              : null,
                    ),
                    padding: EdgeInsets.all(8),
                  ),
                  height: (constraints.maxHeight - constraints.minHeight) * 0.5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
