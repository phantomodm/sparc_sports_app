import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/gateways/stripe_pay.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/models/payment_type.dart';


/*
|--------------------------------------------------------------------------
| PAYMENT GATEWAYS
|
| Configure which payment gateways you want to use.
| Docs here: https://woosignal.com/docs/app/label-storemax
|--------------------------------------------------------------------------
*/

const appPaymentGateways = [];
// Available: "Stripe", "CashOnDelivery", "PayPal", "RazorPay"
// e.g. app_payment_gateways = ["Stripe", "CashOnDelivery"]; will only use Stripe and Cash on Delivery.
final appTranslations = locator<AppTranslations>();
List<PaymentType> paymentTypeList = [
  addPayment(
    id: 1,
    name: "Stripe",
    description: appTranslations.translate("Debit or Credit Card"),
    assetImage: "dark_powered_by_stripe.png",
    pay: stripePay,
  ),
  addPayment(
    id: 4,
    name: "PayPal",
    description: appTranslations.translate("Debit or Credit Card"),
    assetImage: "paypal_logo.png",
    pay: stripePay,/* payPalPay,*/
  ),

];
