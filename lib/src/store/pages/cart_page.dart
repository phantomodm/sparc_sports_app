//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparc_sports_app/src/store/classes/app_config.dart';
import 'package:sparc_sports_app/src/store/classes/sparc_widgets.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/enum/toasts_enums.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/helpers/shared_pref/sp_auth.dart';
import 'package:sparc_sports_app/src/store/models/cart_models.dart';
import 'package:sparc_sports_app/src/store/utils/toasts/toast_notification.dart';
import 'package:sparc_sports_app/src/store/widgets/buttons.dart';
import 'package:sparc_sports_app/src/store/widgets/safearea_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/text_row_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/woosignal_ui.dart';

import '../bloc/state_management.dart';

class CartPage extends StatefulWidget {
  const CartPage();

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends SparcState<CartPage> {
  _CartPageState();

  List<CartLineItem> _cartLines = [];
  final appTranslations = locator<AppTranslations>();

  @override
  initState() {
    boot();
    super.initState();
  }

  boot() async {
    await _cartCheck();
    CheckoutSession.getInstance.coupon = null;
  }

  _cartCheck() async {
    List<CartLineItem> cart = await Cart.getInstance.getCart();

    if (cart.isEmpty) {
      return;
    }
    List<Map<String, dynamic>> cartJSON = cart.map((c) => c.toJson()).toList();

    List<dynamic> cartRes =
        await (appWooSignal((api) => api.cartCheck(cartJSON)));

    if (cartRes.isEmpty) {
      Cart.getInstance.saveCartToPref(cartLineItems: []);
      return;
    }
    _cartLines = cartRes.map((json) => CartLineItem.fromJson(json)).toList();
    print(_cartLines);
    if (_cartLines.isNotEmpty) {
      Cart.getInstance.saveCartToPref(cartLineItems: _cartLines);
    }
  }

  void _actionProceedToCheckout() async {
    List<CartLineItem> cartLineItems = await Cart.getInstance.getCart();

    if (isLoading()) {
      return;
    }

    if (cartLineItems.isEmpty) {
      ToastHelper().showToastNotification(
        context,
        title: appTranslations.trans(context, "Cart"),
        description: appTranslations.trans(
            context, "You need items in your cart to checkout"),
        style: ToastNotificationStyleType.WARNING,
        icon: Icons.shopping_cart,
      );
      return;
    }

    if (!cartLineItems.every(
        (c) => c.stockStatus == 'instock' || c.stockStatus == 'onbackorder')) {
      ToastHelper().showToastNotification(
        context,
        title: appTranslations.trans(context, "Cart"),
        description:
            appTranslations.trans(context, "There is an item out of stock"),
        style: ToastNotificationStyleType.WARNING,
        icon: Icons.shopping_cart,
      );
      return;
    }

    CheckoutSession.getInstance.initSession();
    CustomerAddress? sfCustomerAddress =
        await CheckoutSession.getInstance.getBillingAddress();

    if (sfCustomerAddress != null) {
      CheckoutSession.getInstance.billingDetails!.billingAddress =
          sfCustomerAddress;
      CheckoutSession.getInstance.billingDetails!.shippingAddress =
          sfCustomerAddress;
    }

    if (AppHelper.instance.appConfig!.wpLoginEnabled == 1 &&
        !(await authCheck())) {
      UserAuth.instance.redirect = "/checkout";
      Navigator.pushNamed(context, "/account-landing");
      return;
    }

    Navigator.pushNamed(context, "/checkout");
  }

  actionIncrementQuantity({required CartLineItem cartLineItem}) async {
    if (cartLineItem.isManagedStock! &&
        cartLineItem.quantity + 1 > cartLineItem.stockQuantity!) {
      ToastHelper().showToastNotification(
        context,
        title: appTranslations.trans(context, "Cart"),
        description: appTranslations.trans(context, "Maximum stock reached"),
        style: ToastNotificationStyleType.WARNING,
        icon: Icons.shopping_cart,
      );
      return;
    }
    context.read<ProductBloc>().add(IncrementQuantity());
    // await Cart.getInstance.updateQuantity(cartLineItem: cartLineItem, incrementQuantity: 1);
    cartLineItem.quantity += 1;
    setState(() {});
  }

  actionDecrementQuantity({required CartLineItem cartLineItem}) async {
    context.read<ProductBloc>().add(DecrementQuantity());
    if (cartLineItem.quantity - 1 <= 0) {
      return;
    }
    // await Cart.getInstance.updateQuantity(cartLineItem: cartLineItem, incrementQuantity: -1);
    cartLineItem.quantity -= 1;
    setState(() {});
  }

  actionRemoveItem({required int index}) async {
    await Cart.getInstance.removeCartItemForIndex(index: index);
    _cartLines.removeAt(index);
    ToastHelper().showToastNotification(
      context,
      title: appTranslations.trans(context, "Updated"),
      description: appTranslations.trans(context, "Item removed"),
      style: ToastNotificationStyleType.WARNING,
      icon: Icons.remove_shopping_cart,
    );
    setState(() {});
  }

  _clearCart() async {
    await Cart.getInstance.clear();
    _cartLines = [];
    ToastHelper().showToastNotification(context,
        title: appTranslations.trans(context, "Success"),
        description: appTranslations.trans(context, "Cart cleared"),
        style: ToastNotificationStyleType.SUCCESS,
        icon: Icons.delete_outline);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            appTranslations.trans(context, "Shopping Cart"),
          ),
          elevation: 1,
          actions: <Widget>[
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                context.read<CartBloc>().add(ClearCart());
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    appTranslations.trans(context, "Clear Cart"),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            )
          ],
          centerTitle: true,
        ),
        body: SafeAreaWidget(
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              print(state);
              return switch (state) {
                CartLoading() => const CircularProgressIndicator(),
                CartError() => const Text('Something went wrong!'),
                CartItemLoaded() =>
                  CartItemsView(cartItems: state.cartItems, context: context),
                // TODO: Handle this case.
                CartState() => throw UnimplementedError(),
              };
            },
          ),
        ));
  }
}

class CartItemsView extends StatelessWidget {
  final List<CartLineItem> cartItems;
  final appTranslations = locator<AppTranslations>();
  final BuildContext context;

  CartItemsView({Key? key, required this.cartItems, required this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              'assets/images/empty_cart.png',
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 24),
            Text(
              'Your cart is empty',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Looks like you haven\'t added anything yet.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/shop');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Shop Now'),
            ),
          ],
        ),
      );
    } else {
      return FractionallySizedBox(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            Expanded(
                child: ListView.separated(
                    itemCount: cartItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final cartLineItem = cartItems[index];
                      return CartItemContainer(
                        cartLineItem: cartLineItem,
                        actionIncrementQuantity: () {
                          context.read<ProductBloc>().add(IncrementQuantity());
                          context.read<CartBloc>().add(
                                CartProductChange(
                                  cartLineItem: cartLineItem,
                                  quantityChange: 1,
                                ),
                              );
                        },
                        actionDecrementQuantity: () {
                          context.read<ProductBloc>().add(DecrementQuantity());
                          context.read<CartBloc>().add(
                                CartProductChange(
                                  cartLineItem: cartLineItem,
                                  quantityChange: -1,
                                ),
                              );
                        },
                        actionRemoveItem: () {
                          context.read<CartBloc>().add(
                                RemoveFromCart(index),
                              );
                        },
                      );
                    })),
            Divider(
              color: Colors.black45,
            ),
            FutureBuilder<String>(
                future: Cart.getInstance.getTotal(withFormat: true),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15, top: 15),
                      child: TextRowWidget(
                        title: appTranslations.trans(context, "Total"),
                        text: snapshot.data!,
                      ),
                    );
                  } else {
                    return const SizedBox.shrink(); // Or a loading indicator
                  }
                }),
            PrimaryButton(
              title: appTranslations.trans(context, "PROCEED TO CHECKOUT"),
              action: _actionProceedToCheckout,
            ),
          ])
      );
    }
  }

  void _actionProceedToCheckout() async {
    List<CartLineItem> cartLineItems = await Cart.getInstance.getCart();
    /*if (isLoading()) {
      return;
    }*/

    if (cartLineItems.isEmpty) {
      ToastHelper().showToastNotification(
        context,
        title: appTranslations.translate("Cart"),
        description: appTranslations
            .translate("You need items in your cart to checkout"),
        style: ToastNotificationStyleType.WARNING,
        icon: Icons.shopping_cart,
      );
      return;
    }

    if (!cartLineItems.every(
        (c) => c.stockStatus == 'instock' || c.stockStatus == 'onbackorder')) {
      ToastHelper().showToastNotification(
        context,
        title: appTranslations.trans(context, "Cart"),
        description:
            appTranslations.trans(context, "There is an item out of stock"),
        style: ToastNotificationStyleType.WARNING,
        icon: Icons.shopping_cart,
      );
      return;
    }

    CheckoutSession.getInstance.initSession();
    CustomerAddress? sfCustomerAddress =
        await CheckoutSession.getInstance.getBillingAddress();

    if (sfCustomerAddress != null) {
      CheckoutSession.getInstance.billingDetails!.billingAddress =
          sfCustomerAddress;
      CheckoutSession.getInstance.billingDetails!.shippingAddress =
          sfCustomerAddress;
    }

    if (AppHelper.instance.appConfig!.wpLoginEnabled == 1 &&
        !(await authCheck())) {
      UserAuth.instance.redirect = "/checkout";
      Navigator.pushNamed(context, "/account-landing");
      return;
    }

    Navigator.pushNamed(context, "/checkout");
  }
}
