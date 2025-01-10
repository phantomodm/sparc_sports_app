
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/gateways/stripe_pay.dart';
import 'package:sparc_sports_app/src/store/models/payment_type.dart';

const appPaymentGateways = [];
// Available: "Stripe", "CashOnDelivery", "PayPal", "RazorPay"
// e.g. app_payment_gateways = ["Stripe", "CashOnDelivery"]; will only use Stripe and Cash on Delivery.

List<PaymentType> paymentTypeList = [
  addPayment(
    id: 1,
    name: "Stripe",
    description: "Debit or Credit Card",
    assetImage: "dark_powered_by_stripe.png",
    pay: stripePay,
  )

  // addPayment(
  //   id: 4,
  //   name: "PayPal",
  //   description: appTranslations.trans(context, "Debit or Credit Card"),
  //   assetImage: "paypal_logo.png",
  //   pay: payPalPay,
  // ),

  // e.g. add more here

  // addPayment(
  //   id: 6,
  //   name: "MyNewPaymentMethod",
  //   description: "Debit or Credit Card",
  //   assetImage: "add icon image to public/assets/images/myimage.png",
  //   pay: "myCustomPaymentFunction",
  // ),
];
