import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparc_sports_app/src/store/bloc/cart_bloc.dart';
import 'package:sparc_sports_app/src/store/bloc/product_bloc.dart';
import 'package:sparc_sports_app/src/store/classes/app_config.dart';
import 'package:sparc_sports_app/src/store/classes/sparc_widgets.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:sparc_sports_app/src/store/enum/toasts_enums.dart';
import 'package:sparc_sports_app/src/store/enum/wishlist_action_enums.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/models/cart_line_item.dart';
import 'package:sparc_sports_app/src/store/services/product_service.dart';
import 'package:sparc_sports_app/src/store/utils/toasts/toast_notification.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/utils/wooSignal.dart';
import 'package:sparc_sports_app/src/store/widgets/widgets.dart' hide wsModalBottom;
import 'package:woosignal/models/response/product.dart';
import 'package:woosignal/models/response/product_variation.dart'
    as wsproduct_variation;
import 'package:woosignal/models/response/woosignal_app.dart';
import 'package:woosignal/models/response/product_variation.dart'
    as ws_product_variation;

import '../controllers/controllers.dart';

class ProductDetailsScreen extends SparcStatefulWidget {
  static String path = "/product-detail";
  ProductDetailsScreen({Key? key}) : super(path, key: key);
  @override
  final ProductDetailController controller = ProductDetailController();

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends SparcState<ProductDetailsScreen> {
  final WooSignalApp? _wooSignalApp = AppHelper.instance.appConfig;
  final productService = locator<ProductService>();
  final Map<int, dynamic> _selectedAttributes = {};
  late Product _product;
  List<wsproduct_variation.ProductVariation> _productVariations = [];
  int quantity = 1;
  bool _show3DApp = false;
  bool _variationsLoaded = false;
  final appTranslations = locator<AppTranslations>();

  @override
  initState(){
    _loadProduct();
    super.initState();
  }

  void _loadProduct(){
    final state = context.read<ProductBloc>().state;
    print('Product Detail Page');
    print(state);
    if (state is ProductLoaded) {
      _product = state.currentProduct!;
    }
  }

  _fetchProductVariations() async {
    List<ws_product_variation.ProductVariation> tmpVariations = [];
    int currentPage = 1;

    bool isFetching = true;
    while (isFetching) {
      List<ws_product_variation.ProductVariation> tmp = await (appWooSignal(
        (api) => api.getProductVariations(_product.id!,
            perPage: 100, page: currentPage),
      ));
      if (tmp.isNotEmpty) {
        tmpVariations.addAll(tmp);
      }

      if (tmp.length >= 100) {
        currentPage += 1;
      } else {
        isFetching = false;
      }
    }
    _productVariations = tmpVariations;
  }

  void _showAttributeOptionsBottomSheet(int attributeIndex, Product product) {
    wsModalBottom(
      context,
      title:
          "Select a ${product.attributes[attributeIndex].name}", // Adjust translation if needed
      bodyWidget: ListView.separated(
        itemCount: product.attributes[attributeIndex].options!.length,
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(color: Colors.black12),
        itemBuilder: (BuildContext context, int index) {
          final option = product.attributes[attributeIndex].options![index];
          return ListTile(
            title: Text(
              option,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: (_selectedAttributes.isNotEmpty &&
                    _selectedAttributes.containsKey(attributeIndex) &&
                    _selectedAttributes[attributeIndex]!["value"] == option)
                ? const Icon(Icons.check, color: Colors.blueAccent)
                : null,
            onTap: () {
              _selectedAttributes[attributeIndex] = {
                "name": product.attributes[attributeIndex].name,
                "value": option,
              };
              Navigator.pop(context); // Close the options bottom sheet
              _showAttributesBottomSheet(); // Reopen the attributes bottom sheet
            },
          );
        },
      ),
    );
  }

  void _showAttributesBottomSheet() {
    if (_variationsLoaded) {
      ws_product_variation.ProductVariation? productVariation =
          productService.findProductVariation(
              tmpAttributeObj: _selectedAttributes,
              productVariations:
                  _productVariations); // Assuming you have a list of variations in the Product model
      wsModalBottom(
        context,
        title: "Options", // Adjust translation if needed
        bodyWidget: ListView.separated(
          itemCount: _product.attributes.length,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(color: Colors.black12),
          itemBuilder: (BuildContext context, int index) {
            final attribute = _product.attributes[index];
            return ListTile(
              title: Text(attribute.name!,
                  style: Theme.of(context).textTheme.titleMedium),
              subtitle: (_selectedAttributes.isNotEmpty &&
                      _selectedAttributes.containsKey(index))
                  ? Text(_selectedAttributes[index]!["value"]!,
                      style: Theme.of(context).textTheme.bodyLarge)
                  : Text(
                      "Select a ${attribute.name}"), // Adjust translation if needed
              trailing: (_selectedAttributes.isNotEmpty &&
                      _selectedAttributes.containsKey(index))
                  ? const Icon(Icons.check, color: Colors.blueAccent)
                  : null,
              onTap: () => _showAttributeOptionsBottomSheet(index, _product),
            );
          },
        ),
        extraWidget: Container(
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black12, width: 1))),
          padding: const EdgeInsets.only(top: 10),
          margin: const EdgeInsets.only(bottom: 10),
          child: Column(
            children: <Widget>[
              Text(
                (productVariation != null
                    ? "${appTranslations.trans(context, "Price")}: ${formatStringCurrency(total: productVariation.price)}"
                    : (((_product.attributes.length ==
                                _selectedAttributes.values.length) &&
                            productVariation == null)
                        ? appTranslations.trans(context, "This variation is unavailable")
                        : appTranslations.trans(context, "Choose your options"))),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                (productVariation != null
                    ? productVariation.stockStatus != "instock"
                        ? appTranslations.trans(context, "Out of stock")
                        : ""
                    : ""),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              PrimaryButton(
                  title: appTranslations.trans(context, "Add to cart"),
                  action: () async {
                    if (_product.attributes.length !=
                        _selectedAttributes.values.length) {
                      ToastHelper().showToastNotification(context,
                          title: appTranslations.trans(context, "Oops"),
                          description: appTranslations.trans(context, "Please select valid options first"),
                          style: ToastNotificationStyleType.WARNING);
                      return;
                    }

                    if (productVariation == null) {
                      ToastHelper().showToastNotification(context,
                          title: appTranslations.trans(context, "Oops"),
                          description: appTranslations.trans(context,
                               "Product variation does not exist"),
                          style: ToastNotificationStyleType.WARNING);
                      return;
                    }

                    if (productVariation.stockStatus != "instock") {
                      ToastHelper().showToastNotification(context,
                          title: appTranslations.trans(context, "Sorry"),
                          description: appTranslations.trans(context, "This item is not in stock"),
                          style: ToastNotificationStyleType.WARNING);
                      return;
                    }

                    List<String> options = [];
                    _selectedAttributes.forEach((k, v) {
                      options.add("${v["name"]}: ${v["value"]}");
                    });

                    CartLineItem cartLineItem =
                        CartLineItem.fromProductVariation(
                      quantityAmount: quantity,
                      options: options,
                      product: _product,
                      productVariation: productVariation,
                    );

                    // Add to cart using CartBloc
                    context.read<CartBloc>().add(AddToCart(cartLineItem, context));

                    // await _itemAddToCart(
                    //   cartLineItem: cartLineItem,
                    // );
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  }),
            ],
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Loading Variations'),
          content: const Text('Please wait while the variations are loaded.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductLoaded ) {
          print('Product Loaded');
          setState(() {
            _productVariations = state.variations.cast<ws_product_variation.ProductVariation>();
            _variationsLoaded = true;
          });
        }
      },
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoaded) {
            _product = state.currentProduct!;
            return Scaffold(
              appBar: AppBar(
                title: Text(
                    _product.name!
                ),
              ),
              body: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: ProductDetailBodyWidget(
                          wooSignalApp: _wooSignalApp,
                          product: _product,
                        ),
                      ),
                      ProductDetailFooterActionsWidget(
                        onAddToCart: _addItemToCart,
                        onViewExternalProduct: _viewExternalProduct,
                        onAddQuantity: () => _incrementQuantity(),
                        onRemoveQuantity: () => _decrementQuantity(),
                        product: _product,
                        quantity: state.quantity,
                      )
                    ],
                  ),
                  if (_show3DApp)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      top: 0,
                      bottom: 0,
                      left:
                      _show3DApp ? 0 : MediaQuery.of(context).size.width,
                      right: 0,
                      child: Container(
                          color: Colors.grey[200],
                          child: const Center(child: Text('3D App'))),
                    ),
                ],
              ),
            );
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }

  // List<dynamic> _getSelectedVariationOptions() {
  //   List<String> options = [];
  //   _selectedAttributes.forEach((k, v) {
  //     options.add("${v["name"]}: ${v["value"]}");
  //   });
  //   return options;
  // }

  // String _getSelectedVariationPrice(
  //     List<wsproduct_variation.ProductVariation> variations) {
  //   final selectedVariation = _findSelectedVariation(variations);
  //   if (selectedVariation != null) {
  //     return '\$${selectedVariation.price}';
  //   } else {
  //     return 'Select options';
  //   }
  // }

  // String _getSelectedVariationAvailability(
  //     List<wsproduct_variation.ProductVariation> variations) {
  //   final selectedVariation = _findSelectedVariation(variations);
  //   if (selectedVariation != null) {
  //     return selectedVariation.inStock ? 'In stock' : 'Out of stock';
  //   } else {
  //     return '';
  //   }
  // }
  void printSharedPreferencesValues() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (String key in keys) {
      final value = prefs.get(key);
      print('$key: $value');
    }
  }

  _addItemToCart() async {
    final state = context.read<ProductBloc>().state;
    if (_product.type != "simple") {
      _showAttributesBottomSheet();
      return;
    }
    if (_product.stockStatus != "instock") {
      ToastHelper().showToastNotification(
          context,
          title: appTranslations.trans(context,"Sorry"),
          description: appTranslations.trans(context,"This item is out of stock"),
          style: ToastNotificationStyleType.WARNING,
          icon: Icons.local_shipping);
      return;
    }

    await widget.controller.itemAddToCart(
      context,
      cartLineItem: CartLineItem.fromProduct(
          quantityAmount: widget.controller.quantity, product: _product),
    );
  }

  toggleWishList(
      {required Function onSuccess,
      required WishlistAction wishlistAction}) async {
    String subtitleMsg;
    if (wishlistAction == WishlistAction.remove) {
      await removeWishlistProduct(product: _product);
      if (mounted) {
        subtitleMsg = appTranslations.trans(context, "This product has been removed from your wishlist");
      }
    } else {
      await saveWishlistProduct(product: _product);
      if (mounted) {
        subtitleMsg = appTranslations.trans(context, "This product has been added to your wishlist");
      }
    }
    if (mounted) {
      showStatusAlert(
        context,
        title: appTranslations.trans(context, "Success"),
        icon: Icons.favorite,
        duration: 1, subtitle: '',
      );
    }

    onSuccess();
  }

  void _incrementQuantity() {
    context.read<ProductBloc>().add(IncrementQuantity());
  }

  void _decrementQuantity() {
    context.read<ProductBloc>().add(DecrementQuantity());
  }

  _viewExternalProduct() {
    if (_product.externalUrl != null && _product.externalUrl!.isNotEmpty) {
      openBrowserTab(url: _product.externalUrl!);
    }
  }
}
