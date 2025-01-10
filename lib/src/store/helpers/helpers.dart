import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:sparc_sports_app/src/store/classes/app_config.dart';
import 'package:sparc_sports_app/src/store/classes/sparc_classes.dart';
import 'package:sparc_sports_app/src/store/config/currency.dart';
import 'package:sparc_sports_app/src/store/config/decoders.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/enum/symbol_position_enums.dart';
import 'package:sparc_sports_app/src/store/gateways/payment_gateways.dart';
import 'package:sparc_sports_app/src/store/models/cart_models.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:html/parser.dart';
//import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:math_expressions/math_expressions.dart' as math;
import 'package:money_formatter/money_formatter.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sparc_sports_app/src/store/services/api_service.dart';
import 'package:sparc_sports_app/src/store/utils/extensions.dart';
import 'package:sparc_sports_app/src/store/utils/wooSignal.dart';
import 'package:sparc_sports_app/src/store/widgets/no_results_for_products_widget.dart';
import 'package:status_alert/status_alert.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:woosignal/models/response/product.dart';
import 'package:woosignal/models/response/tax_rate.dart';
import 'package:woosignal/woosignal.dart';
import 'package:wp_json_api/models/responses/wp_user_info_response.dart';
import 'package:status_alert/status_alert.dart' as ic;


// Returns User from the SharedPreferences
Future<User?> getUser() async =>
    (await (SparcStorage().getString(SharedKey.authUser)));

Future appWooSignal(Function(WooSignal api) api) async {
  return await api(WooSignal.instance);
}

dynamic getEnv(String key, {dynamic defaultValue}) {
  if (!dotenv.env.containsKey(key) && defaultValue != null) {
    return defaultValue;
  }

  String? value = dotenv.env[key];

  if (value == 'null' || value == null) {
    return null;
  }

  if (value.toLowerCase() == 'true') {
    return true;
  }

  if (value.toLowerCase() == 'false') {
    return false;
  }

  return value.toString();
}

Future<List<PaymentType?>> getPaymentTypes() async {
  List<PaymentType?> paymentTypes = [];
  for (var appPaymentGateway in appPaymentGateways) {
    if (paymentTypes.firstWhere(
            (paymentType) => paymentType!.name != appPaymentGateway,
            orElse: () => null) ==
        null) {
      paymentTypes.add(paymentTypeList.firstWhereOrNull(
          (paymentTypeList) => paymentTypeList.name == appPaymentGateway));
    }
  }

  if (!appPaymentGateways.contains('Stripe') &&
      AppHelper.instance.appConfig!.stripeEnabled == true) {
    paymentTypes.add(paymentTypeList
        .firstWhereOrNull((element) => element.name == "Stripe"));
  }
  if (!appPaymentGateways.contains('PayPal') &&
      AppHelper.instance.appConfig!.paypalEnabled == true) {
    paymentTypes.add(paymentTypeList
        .firstWhereOrNull((element) => element.name == "PayPal"));
  }
  if (!appPaymentGateways.contains('CashOnDelivery') &&
      AppHelper.instance.appConfig!.codEnabled == true) {
    paymentTypes.add(paymentTypeList
        .firstWhereOrNull((element) => element.name == "CashOnDelivery"));
  }

  return paymentTypes.where((v) => v != null).toList();
}

dynamic envVal(String envVal, {dynamic defaultValue}) =>
    (getEnv(envVal) ?? defaultValue);

PaymentType addPayment(
        {required int id,
        required String name,
        required String description,
        required String assetImage,
        required Function pay}) =>
    PaymentType(
      id: id,
      name: name,
      desc: description,
      assetImage: assetImage,
      pay: pay,
    );

showStatusAlert(context,
    {required String title,
    required String? subtitle,
    IconData? icon,
    int? duration}) {
  StatusAlert.show(
    context,
    duration: Duration(seconds: duration ?? 2),
    title: title,
    subtitle: subtitle,
    configuration: ic.IconConfiguration(icon: icon ?? Icons.done, size: 50),
  );
}

String parseHtmlString(String? htmlString) {
  var document = parse(htmlString);
  return parse(document.body!.text).documentElement!.text;
}

String moneyFormatter(double amount) {
  MoneyFormatter fmf = MoneyFormatter(
    amount: amount,
    settings: MoneyFormatterSettings(
        symbol: AppHelper.instance.appConfig?.currencyMeta?.symbolNative,
        symbolAndNumberSeparator: ""),
  );
  if (appCurrencySymbolPosition == SymbolPositionType.left) {
    return fmf.output.symbolOnLeft;
  } else if (appCurrencySymbolPosition == SymbolPositionType.right) {
    return fmf.output.symbolOnRight;
  }
  return fmf.output.symbolOnLeft;
}

String formatDoubleCurrency({required double total}) {
  return moneyFormatter(total);
}

String getImageAsset(String imageName) =>
    "${getEnv("ASSET_PATH_IMAGES")}/$imageName";

/// Extensions for String
extension StringExtension on String {
  String capitalize() => "${this[0].toUpperCase()}${this.substring(1)}";
}

String formatStringCurrency({required String? total}) {
  double tmpVal = 0;
  if (total != null && total != "") {
    tmpVal = parseWcPrice(total);
  }
  return moneyFormatter(tmpVal);
}

String workoutSaleDiscount(
    {required String? salePrice, required String? priceBefore}) {
  double dSalePrice = parseWcPrice(salePrice);
  double dPriceBefore = parseWcPrice(priceBefore);
  return ((dPriceBefore - dSalePrice) * (100 / dPriceBefore))
      .toStringAsFixed(0);
}

Future<void> openBrowserTab({required String url}) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(
      url
    );
  } else {
    throw 'Could not launch $url';
  }
}


/*openBrowserTab({required String url}) async {
  await FlutterWebBrowser.openWebPage(
    url: url,
    customTabsOptions: const CustomTabsOptions(
      defaultColorSchemeParams:
          CustomTabsColorSchemeParams(toolbarColor: Colors.white70),
    ),
  );
}*/

bool isNumeric(String? str) {
  if (str == null) {
    return false;
  }
  return double.tryParse(str) != null;
}

checkout(
    TaxRate? taxRate,
    Function(String total, BillingDetails? billingDetails, Cart cart)
        completeCheckout) async {
  String cartTotal = await CheckoutSession.getInstance
      .total(withFormat: false, taxRate: taxRate);
  BillingDetails? billingDetails = CheckoutSession.getInstance.billingDetails;
  Cart cart = Cart.getInstance;
  return await completeCheckout(cartTotal, billingDetails, cart);
}

double? strCal({required String sum}) {
  if (sum == "") {
    return 0;
  }
  math.Parser p = math.Parser();
  math.Expression exp = p.parse(sum);
  math.ContextModel cm = math.ContextModel();
  return exp.evaluate(math.EvaluationType.REAL, cm);
}

Future<double?> workoutShippingCostWC({required String? sum}) async {
  if (sum == null || sum == "") {
    return 0;
  }
  List<CartLineItem> cartLineItem = await Cart.getInstance.getCart();
  sum = sum.replaceAllMapped(defaultRegex(r'\[qty\]', strict: true), (replace) {
    return cartLineItem
        .map((f) => f.quantity)
        .toList()
        .reduce((i, d) => i + d)
        .toString();
  });

  String orderTotal = await Cart.getInstance.getSubtotal();

  sum = sum.replaceAllMapped(defaultRegex(r'\[fee(.*)]'), (replace) {
    if (replace.groupCount < 1) {
      return "()";
    }
    String newSum = replace.group(1)!;

    // PERCENT
    String percentVal = newSum.replaceAllMapped(
        defaultRegex(r'percent="([0-9\.]+)"'), (replacePercent) {
      if (replacePercent.groupCount >= 1) {
        String strPercentage =
            "( ($orderTotal * ${replacePercent.group(1)}) / 100 )";
        double? calPercentage = strCal(sum: strPercentage);

        // MIN
        String strRegexMinFee = r'min_fee="([0-9\.]+)"';
        if (defaultRegex(strRegexMinFee).hasMatch(newSum)) {
          String strMinFee =
              defaultRegex(strRegexMinFee).firstMatch(newSum)!.group(1) ?? "0";
          double doubleMinFee = double.parse(strMinFee);

          if (calPercentage! < doubleMinFee) {
            return "($doubleMinFee)";
          }
          newSum = newSum.replaceAll(defaultRegex(strRegexMinFee), "");
        }

        // MAX
        String strRegexMaxFee = r'max_fee="([0-9\.]+)"';
        if (defaultRegex(strRegexMaxFee).hasMatch(newSum)) {
          String strMaxFee =
              defaultRegex(strRegexMaxFee).firstMatch(newSum)!.group(1) ?? "0";
          double doubleMaxFee = double.parse(strMaxFee);

          if (calPercentage! > doubleMaxFee) {
            return "($doubleMaxFee)";
          }
          newSum = newSum.replaceAll(defaultRegex(strRegexMaxFee), "");
        }
        return "($calPercentage)";
      }
      return "";
    });

    percentVal = percentVal
        .replaceAll(
            defaultRegex(r'(min_fee=\"([0-9\.]+)\"|max_fee=\"([0-9\.]+)\")'),
            "")
        .trim();
    return percentVal;
  });

  return strCal(sum: sum);
}

Future<double?> workoutShippingClassCostWC(
    {required String? sum, List<CartLineItem>? cartLineItem}) async {
  if (sum == null || sum == "") {
    return 0;
  }
  sum = sum.replaceAllMapped(defaultRegex(r'\[qty\]', strict: true), (replace) {
    return cartLineItem!
        .map((f) => f.quantity)
        .toList()
        .reduce((i, d) => i + d)
        .toString();
  });

  String orderTotal = await Cart.getInstance.getSubtotal();

  sum = sum.replaceAllMapped(defaultRegex(r'\[fee(.*)]'), (replace) {
    if (replace.groupCount < 1) {
      return "()";
    }
    String newSum = replace.group(1)!;

    // PERCENT
    String percentVal = newSum.replaceAllMapped(
        defaultRegex(r'percent="([0-9\.]+)"'), (replacePercent) {
      if (replacePercent.groupCount >= 1) {
        String strPercentage =
            "( ($orderTotal * ${replacePercent.group(1)}) / 100 )";
        double? calPercentage = strCal(sum: strPercentage);

        // MIN
        String strRegexMinFee = r'min_fee="([0-9\.]+)"';
        if (defaultRegex(strRegexMinFee).hasMatch(newSum)) {
          String strMinFee =
              defaultRegex(strRegexMinFee).firstMatch(newSum)!.group(1) ?? "0";
          double doubleMinFee = double.parse(strMinFee);

          if (calPercentage! < doubleMinFee) {
            return "($doubleMinFee)";
          }
          newSum = newSum.replaceAll(defaultRegex(strRegexMinFee), "");
        }

        // MAX
        String strRegexMaxFee = r'max_fee="([0-9\.]+)"';
        if (defaultRegex(strRegexMaxFee).hasMatch(newSum)) {
          String strMaxFee =
              defaultRegex(strRegexMaxFee).firstMatch(newSum)!.group(1) ?? "0";
          double doubleMaxFee = double.parse(strMaxFee);

          if (calPercentage! > doubleMaxFee) {
            return "($doubleMaxFee)";
          }
          newSum = newSum.replaceAll(defaultRegex(strRegexMaxFee), "");
        }
        return "($calPercentage)";
      }
      return "";
    });

    percentVal = percentVal
        .replaceAll(
            defaultRegex(r'(min_fee=\"([0-9\.]+)\"|max_fee=\"([0-9\.]+)\")'),
            "")
        .trim();
    return percentVal;
  });

  return strCal(sum: sum);
}

RegExp defaultRegex(
  String pattern, {
  bool? strict,
}) {
  return RegExp(
    pattern,
    caseSensitive: strict ?? false,
    multiLine: false,
  );
}

bool isEmail(String em) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(p);
  return regExp.hasMatch(em);
}

navigatorPush(BuildContext context,
    {required String routeName,
    Object? arguments,
    bool forgetAll = false,
    int? forgetLast}) {
  if (forgetAll) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        routeName, (Route<dynamic> route) => false,
        arguments: arguments);
  }
  if (forgetLast != null) {
    int count = 0;
    Navigator.of(context).popUntil((route) {
      return count++ == forgetLast;
    });
  }
  Navigator.of(context).pushNamed(routeName, arguments: arguments);
}

DateTime parseDateTime(String strDate) => DateTime.parse(strDate);

DateFormat formatDateTime(String format) => DateFormat(format);

String dateFormatted({required String date, required String formatType}) =>
    formatDateTime(formatType).format(parseDateTime(date));

enum FormatType {
  dateTime,
  date,
  time,
}

String formatForDateTime(FormatType formatType) {
  switch (formatType) {
    case FormatType.date:
      {
        return "yyyy-MM-dd";
      }
    case FormatType.dateTime:
      {
        return "dd-MM-yyyy hh:mm a";
      }
    case FormatType.time:
      {
        return "hh:mm a";
      }
    // ignore: unreachable_switch_default
    default:
      {
        return "";
      }
  }
}

double parseWcPrice(String? price) => (double.tryParse(price ?? "0") ?? 0);

Widget refreshableScroll(context,
    {required refreshController,
    required VoidCallback onRefresh,
    required VoidCallback onLoading,
    required List<Product> products,
    required onTap,
    key}) {
  return SmartRefresher(
    enablePullDown: true,
    enablePullUp: true,
    footer: CustomFooter(
      builder: (BuildContext context, LoadStatus? mode) {
        Widget body;
        final appTranslations = locator<AppTranslations>();
        if (mode == LoadStatus.idle) {
          body = Text(appTranslations.trans(context, "pull up load"));
        } else if (mode == LoadStatus.loading) {
          body = const CupertinoActivityIndicator();
        } else if (mode == LoadStatus.failed) {
          body = Text(
              appTranslations.trans(context, "Load Failed! Click retry!"));
        } else if (mode == LoadStatus.canLoading) {
          body = Text(appTranslations.trans(context, "release to load more"));
        } else {
          body = Text(appTranslations.trans(context, "No more products"));
        }
        return SizedBox(
          height: 55.0,
          child: Center(child: body),
        );
      },
    ),
    controller: refreshController,
    onRefresh: onRefresh,
    onLoading: onLoading,
    child: products.isEmpty
        ? NoResultsForProductsWidget()
        : StaggeredGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            children: products.map((product) {
              return StaggeredGridTile.fit(
                crossAxisCellCount: 1,
                child: SizedBox(
                  height: 350,
                  child: ProductItemContainer(
                    product: product,
                    onTap: onTap,
                  ),
                ),
              );
            }).toList()),
  );
}

class UserAuth {
  UserAuth._privateConstructor();
  static final UserAuth instance = UserAuth._privateConstructor();

  String redirect = "/home";
}

Future<List<DefaultShipping>> getDefaultShipping() async {
  String data =
      await rootBundle.loadString('public/assets/json/default_shipping.json');
  dynamic dataJson = json.decode(data);
  List<DefaultShipping> shipping = [];

  dataJson.forEach((key, value) {
    DefaultShipping defaultShipping =
        DefaultShipping(code: key, country: value['country'], states: []);
    if (value['states'] != null) {
      value['states'].forEach((key1, value2) {
        defaultShipping.states
            .add(DefaultShippingState(code: key1, name: value2));
      });
    }
    shipping.add(defaultShipping);
  });
  return shipping;
}

Future<DefaultShipping?> findCountryMetaForShipping(String countryCode) async {
  List<DefaultShipping> defaultShipping = await getDefaultShipping();
  List<DefaultShipping> shippingByCountryCode =
      defaultShipping.where((element) => element.code == countryCode).toList();
  if (shippingByCountryCode.isNotEmpty) {
    return shippingByCountryCode.first;
  }
  return null;
}

DefaultShippingState? findDefaultShippingStateByCode(
    DefaultShipping defaultShipping, String code) {
  List<DefaultShippingState> defaultShippingStates =
      defaultShipping.states.where((state) => state.code == code).toList();
  if (defaultShippingStates.isEmpty) {
    return null;
  }
  DefaultShippingState defaultShippingState = defaultShippingStates.first;
  return DefaultShippingState(
      code: defaultShippingState.code, name: defaultShippingState.name);
}

bool hasKeyInMeta(WPUserInfoResponse wpUserInfoResponse, String key) {
  return (wpUserInfoResponse.data!.metaData ?? [])
      .where((meta) => meta.key == key)
      .toList()
      .isNotEmpty;
}

String fetchValueInMeta(WPUserInfoResponse wpUserInfoResponse, String key) {
  String value = "";
  List<dynamic>? metaDataValue = (wpUserInfoResponse.data!.metaData ?? [])
      .where((meta) => meta.key == key)
      .first
      .value;
  if (metaDataValue != null && metaDataValue.isNotEmpty) {
    return metaDataValue.first ?? "";
  }
  return value;
}

String truncateString(String data, int length) {
  return (data.length >= length) ? '${data.substring(0, length)}...' : data;
}

Future<List<dynamic>> getWishlistProducts() async {
  List<dynamic> favouriteProducts = [];
  String? currentProductsJSON =
    await (SparcStorage().read(SharedKey.wishlistProducts));
  if (currentProductsJSON != null) {
    favouriteProducts = (jsonDecode(currentProductsJSON)).toList();
  }
  return favouriteProducts;
}

hasAddedWishlistProduct(int? productId) async {
  List<dynamic> favouriteProducts = await getWishlistProducts();
  List<int> productIds =
      favouriteProducts.map((e) => e['id']).cast<int>().toList();
  if (productIds.isEmpty) {
    return false;
  }
  return productIds.contains(productId);
}

saveWishlistProduct({required Product? product}) async {
  List<dynamic> products = await getWishlistProducts();
  if (products.any((wishListProduct) => wishListProduct['id'] == product!.id) ==
      false) {
    products.add({"id": product!.id});
  }
  String json = jsonEncode(products.map((i) => {"id": i['id']}).toList());
  await SparcStorage().setString(SharedKey.wishlistProducts, json);
}

removeWishlistProduct({required Product? product}) async {
  List<dynamic> products = await getWishlistProducts();
  products.removeWhere((element) => element['id'] == product!.id);

  String json = jsonEncode(products.map((i) => {"id": i['id']}).toList());
  await SparcStorage().setString(SharedKey.wishlistProducts, json);
}

Future<BillingDetails> billingDetailsFromWpUserInfoResponse(
    wpUserInfoResponse) async {
  List<String> metaDataAddress = [
    'billing_first_name',
    'billing_last_name',
    'billing_company',
    'billing_address_1',
    'billing_address_2',
    'billing_city',
    'billing_postcode',
    'billing_country',
    'billing_state',
    'billing_phone',
    'billing_email',
    'shipping_first_name',
    'shipping_last_name',
    'shipping_company',
    'shipping_address_1',
    'shipping_address_2',
    'shipping_city',
    'shipping_postcode',
    'shipping_country',
    'shipping_state',
    'shipping_phone',
  ];

  Map<String, String> metaData = {};

  for (var dataKey in metaDataAddress) {
    if (hasKeyInMeta(wpUserInfoResponse, dataKey)) {
      String value = fetchValueInMeta(wpUserInfoResponse, dataKey);
      metaData.addAll({dataKey: value});
    }
  }

  BillingDetails billingDetails = BillingDetails();
  await billingDetails.fromWpMeta(metaData);
  return billingDetails;
}

/// API helper
api<T>(dynamic Function(T request) request,
        {BuildContext? context,
        Map<String, dynamic> headers = const {},
        String? bearerToken,
        String? baseUrl,
        int? page,
        String? queryNamePage,
        String? queryNamePerPage,
        int? perPage,
        List<Type> events = const []}) async =>
    await ApiService().sparcApi<T>(
        request: request,
        apiDecoders: apiDecoders,
        context: context,
        headers: headers,
        bearerToken: bearerToken,
        baseUrl: baseUrl,
        events: events,
        page: page,
        perPage: perPage,
        queryParamPage: queryNamePage ?? "page",
        queryParamPerPage: queryNamePerPage);

/// Event helper
///  event<T>({Map? data}) async => nyEvent<T>(params: data, events: events);

/// Check if the [Product] is new.
bool isProductNew(Product? product) {
  if (product?.dateCreatedGMT == null) false;
  try {
    DateTime dateTime = DateTime.parse(product!.dateCreatedGMT!);
    return dateTime.isBetween(
            DateTime.now().subtract(const Duration(days: 2)), DateTime.now()) ??
        false;
  } on Exception catch (e) {
    SparcLogger().error(e.toString());
  }
  return false;
}

bool shouldEncrypt() {
  String? encryptKey = getEnv('ENCRYPT_KEY', defaultValue: "");
  if (encryptKey == null || encryptKey == "") {
    return false;
  }
  String? encryptSecret = getEnv('ENCRYPT_KEY', defaultValue: "");
  if (encryptSecret == null || encryptSecret == "") {
    return false;
  }
  return true;
}

bool isNotNullOrEmpty(dynamic value, {String? key, dynamic expectedValue}) {
  if (value == null) {
    return false;
  }

  if (value is AsyncSnapshot) {
    return value.hasData && value.data != null;
  }

  if (value is List) {
    return value.isNotEmpty;
  }

  if (value is Map) {
    return value.isNotEmpty;
  }

  if (value is String) {
    return value.isNotEmpty;
  }

  if (value is Product) {
    if (key == 'onSale') {
      return value.onSale != null && value.onSale!;
    }
    if (key == 'type') {
      return value.type != null && value.type != expectedValue;
    }
  }

  // Add more checks for other data types if needed

  return true;
}
