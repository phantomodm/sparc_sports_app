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
import 'package:sparc_sports_app/src/store/controllers/controllers.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/models/cart_models.dart';
import 'package:sparc_sports_app/src/store/widgets/store_widgets.dart';


import 'package:woosignal/models/response/order.dart' as ws_order;

class CheckoutStatusPage extends SparcStatefulWidget {
  static String path = "/checkout-status";

  @override
  final CheckoutStatusController controller = CheckoutStatusController();

  CheckoutStatusPage({Key? key})
      : super(path, key: key, child: _CheckoutStatusState());
}

class _CheckoutStatusState extends SparcState<CheckoutStatusPage> {
  ws_order.Order? _order;
  final appTranslations = locator<AppTranslations>();
  
  @override
  initState() async {

    //_order = widget.controller.data();
    await Cart.getInstance.clear();
    CheckoutSession.getInstance.clear();
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: StoreLogo(height: 60),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          child: Text(
                            appTranslations.trans(context, "Order Status"),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          padding: EdgeInsets.only(bottom: 15),
                        ),
                        Text(
                          appTranslations.trans(context, "Thank You!"),
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          appTranslations.trans(context, "Your transaction details"),
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "${appTranslations.trans(context,"Order Ref")}. #${_order?.id.toString()}",
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black12, width: 1.0),
                        ),
                        color:
                            (Theme.of(context).brightness == Brightness.light)
                                ? Colors.white
                                : null),
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                  Container(
                    child: Image.asset(
                      getImageAsset("camion.gif"),
                      height: 170,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    width: double.infinity,
                  ),
                ],
              ),
              Align(
                child: Padding(
                  child: Text(
                    appTranslations.trans(context, "Items"),
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.left,
                  ),
                  padding: EdgeInsets.all(8),
                ),
                alignment: Alignment.center,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: _order?.lineItems == null
                        ? 0
                        : _order?.lineItems?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      ws_order.LineItems lineItem = _order!.lineItems![index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: wsBoxShadow(),
                          color:
                              (Theme.of(context).brightness == Brightness.light)
                                  ? Colors.white
                                  : null,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    lineItem.name!,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    softWrap: false,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "x${lineItem.quantity.toString()}",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              formatStringCurrency(
                                total: lineItem.subtotal.toString(),
                              ),
                              style: Theme.of(context).textTheme.bodyLarge,
                            )
                          ],
                        ),
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.all(8),
                      );
                    }),
              ),
              Align(
                child: LinkButton(
                  title: appTranslations.trans(context, "Back to Home"),
                  action: () =>
                      Navigator.pushReplacementNamed(context, "/home"),
                ),
                alignment: Alignment.bottomCenter,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
