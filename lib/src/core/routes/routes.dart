// In your main.dart file, or a separate routes.dart file

import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/store/pages/pages.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  "/home": (context) =>  HomePage(),
  "/cart": (context) =>  CartPage(),
  "/checkout": (context) =>  const CheckoutConfirmationPage(),
  "/product-detail": (context) =>  ProductDetailsScreen(),
  "/home-search": (context) =>  const HomeSearchPage(),
  "/product-reviews": (context) =>  ProductReviewsPage(),
  "/product-images": (context) =>  ProductImageViewerPage(),
  "/wishlist": (context) =>  WishListPageWidget(),
  "/no-connection": (context) =>  const NoConnectionPage(),
  "/account-landing": (context) =>  AccountLandingPage(),
  "/account-detail": (context) =>  AccountDetailPage(),
  "/shop": (context) =>  const ProductListScreen(),
  "/browse-category": (context) =>  BrowseCategoryPage(),
  "/checkout-status": (context) =>  CheckoutStatusPage(),
  "/checkout-details": (context) =>  CheckoutDetailsPage(),
  "/checkout-payment-type": (context) =>  CheckoutPaymentTypePage(),
  "/checkout-shipping-type": (context) =>  CheckoutShippingTypePage(),
  "/checkout-coupons": (context) =>  CouponPage(),
  /*"/product-search": (context) =>  BrowseSearchPage(),
  "/product-leave-review": (context) =>  LeaveReviewPage(),
  "/account-order-detail": (context) =>  AccountOrderDetailPage(),

  '/paypal': (context) =>  PayPalCheckout(),
  "/customer-countries": (context) =>  CustomerCountriesPage(),
  "/account-register": (context) =>  AccountRegistrationPage(),
  "/account-update": (context) =>  AccountProfileUpdatePage(),
  "/account-delete": (context) =>  AccountDeletePage(),
  "/account-shipping-details": (context) => AccountShippingDetailsPage(),*/
};

