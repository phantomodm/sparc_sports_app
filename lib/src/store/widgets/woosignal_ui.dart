//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/store/classes/app_config.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/widgets/cached_image_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/no_results_for_products_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/top_nav_widget.dart';
import 'package:sparc_sports_app/src/store/models/cart_models.dart';
import 'package:woosignal/models/response/product.dart';
import 'package:woosignal/models/response/tax_rate.dart';



class RefreshableScrollContainer extends StatelessWidget {
  RefreshableScrollContainer(
      {super.key,
        this.controller,
        this.onRefresh,
        this.onLoading,
        this.products,
        this.onTap,
        this.bannerHeight,
        this.bannerImages,
        this.modalBottomSheetMenu});

  final RefreshController? controller;
  final Function? onRefresh;
  final Function? onLoading;
  final List<Product>? products;
  final Function? onTap;
  final double? bannerHeight;
  final List<String>? bannerImages;
  final Function? modalBottomSheetMenu;
  final appTranslations = locator<AppTranslations>();

  @override
  Widget build(BuildContext context) => SmartRefresher(
    enablePullDown: true,
    enablePullUp: true,
    footer: CustomFooter(
      builder: (BuildContext context, LoadStatus? mode) {
        isNotNullOrEmpty(mode);
        Widget body;
        if (mode == LoadStatus.idle) {
          body = Text(appTranslations.trans(context,"pull up load"));
        } else if (mode == LoadStatus.loading) {
          body = const CupertinoActivityIndicator();
        } else if (mode == LoadStatus.failed) {
          body = Text(appTranslations.trans(context,"Load Failed! Click retry!"));
        } else if (mode == LoadStatus.canLoading) {
          body = Text(appTranslations.trans(context,"release to load more"));
        } else {
          body = Text(appTranslations.trans(context,"No more products"));
        }
        return SizedBox(
          height: 55.0,
          child: Center(child: body),
        );
      },
    ),
    controller: controller!,
    onRefresh: onRefresh as void Function()?,
    onLoading: onLoading as void Function()?,
    child: (isNotNullOrEmpty(products)
        ? StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 1.0,
      crossAxisSpacing: 1.0,
      children: [
        if (bannerImages != null && bannerImages!.isNotEmpty)
          StaggeredGridTile.fit(
              crossAxisCellCount: 2,
              child: SizedBox(
                height: bannerHeight,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return CachedImageWidget(
                      image: bannerImages![index],
                      fit: BoxFit.contain,
                    );
                  },
                  itemCount: bannerImages!.length,
                  viewportFraction: 0.8,
                  scale: 0.9,
                ),
              )),
        StaggeredGridTile.fit(
            crossAxisCellCount: 2,
            child: TopNavWidget(
                onPressBrowseCategories:
                modalBottomSheetMenu as dynamic Function()?)),
        if (products != null)
          ...products!
              .map((product) => StaggeredGridTile.fit(
              crossAxisCellCount: 1,
              child: SizedBox(
                height: 300,
                child: ProductItemContainer(
                  product: product,
                  onTap: onTap,
                ),
              )))
              .toList()
      ],
    )
        : NoResultsForProductsWidget()),
  );
}

class CheckoutRowLine extends StatelessWidget {
  const CheckoutRowLine(
      {super.key,
        required this.heading,
        required this.leadImage,
        required this.leadTitle,
        required this.action,
        this.showBorderBottom = true});

  final String heading;
  final String? leadTitle;
  final Widget leadImage;
  final Function() action;
  final bool showBorderBottom;

  @override
  Widget build(BuildContext context) => Container(
    height: 125,
    padding: const EdgeInsets.all(8),
    decoration: showBorderBottom == true
        ? const BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.black12, width: 1),
      ),
    )
        : const BoxDecoration(),
    child: InkWell(
      onTap: action,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              heading,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      leadImage,
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 15),
                          margin: const EdgeInsets.only(right: 10),
                          child: Text(
                            leadTitle!,
                            style:
                            Theme.of(context).textTheme.titleMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

class TextEditingRow extends StatelessWidget {
  const TextEditingRow({
    super.key,
    this.heading,
    this.controller,
    this.shouldAutoFocus,
    this.keyboardType,
    this.obscureText,
  });

  final String? heading;
  final TextEditingController? controller;
  final bool? shouldAutoFocus;
  final TextInputType? keyboardType;
  final bool? obscureText;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(2),
    height: heading == null ? 50 : 78,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (heading != null)
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: AutoSizeText(
                heading!,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
          ),
        Flexible(
          child: TextField(
            controller: controller,
            style: Theme.of(context).textTheme.titleMedium,
            keyboardType: keyboardType ?? TextInputType.text,
            autocorrect: false,
            autofocus: shouldAutoFocus ?? false,
            obscureText: obscureText ?? false,
            textCapitalization: TextCapitalization.sentences,
          ),
        )
      ],
    ),
  );
}

class CheckoutMetaLine extends StatelessWidget {
  const CheckoutMetaLine({super.key, this.title, this.amount});

  final String? title, amount;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 3,
          child: AutoSizeText(title!,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
        ),
        Flexible(
          flex: 3,
          child: Text(amount!, style: Theme.of(context).textTheme.bodyLarge),
        )
      ],
    ),
  );
}

List<BoxShadow> wsBoxShadow({double? blurRadius}) => [
  BoxShadow(
    color: const Color(0xFFE8E8E8),
    blurRadius: blurRadius ?? 15.0,
    spreadRadius: 0,
    offset: const Offset(
      0,
      0,
    ),
  )
];

class ProductItemContainer extends StatelessWidget {
  ProductItemContainer({
    super.key,
    this.product,
    this.onTap,
  });

  final Product? product;
  final Function? onTap;
  final appTranslations = locator<AppTranslations>();

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return const SizedBox.shrink();
    }

    double height = 280;
    return InkWell(
      child: Container(
        margin: const EdgeInsets.all(4),
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            SizedBox(
              height: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3.0),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.grey[100],
                      height: double.infinity,
                      width: double.infinity,
                    ),
                    CachedImageWidget(
                      image: (isNotNullOrEmpty(product!.images)
                          ? product!.images.first.src
                          : getEnv("PRODUCT_PLACEHOLDER_IMAGE")),
                      fit: BoxFit.contain,
                      height: height,
                      width: double.infinity,
                    ),
                    if (isProductNew(product))
                      Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.black), child: const Text("New", style: TextStyle(color: Colors.white),),),
                    if (isNotNullOrEmpty(product, key: 'onSale') &&
                        isNotNullOrEmpty(product, key: 'type', expectedValue: 'variation'))
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.white70,
                          ),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: '',
                              style: Theme.of(context).textTheme.bodyLarge,
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                  "${workoutSaleDiscount(salePrice: product!.salePrice, priceBefore: product!.regularPrice)}% ${appTranslations.trans(context,"off")}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 2, bottom: 2),
              child: Text(
                product!.name!,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AutoSizeText(
                    "${formatStringCurrency(total: product!.price)} ",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w800),
                    textAlign: TextAlign.left,
                  ),
                  if (product!.onSale! && product!.type != "variable")
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: '${appTranslations.trans(context,"Was")}: ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                            fontSize: 11,
                          ),
                        ),
                        TextSpan(
                          text: formatStringCurrency(
                            total: product!.regularPrice,
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ]),
                    ),
                ].toList(),
              ),
            ),
          ],
        ),
      ),
      onTap: () => onTap != null
          ? onTap!(product)
          : Navigator.pushNamed(context, "/product-detail",
          arguments: product),
    );
  }
}

wsModalBottom(BuildContext context,
    {String? title, Widget? bodyWidget, Widget? extraWidget}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (builder) {
      return SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    title!,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow:
                      (Theme.of(context).brightness == Brightness.light)
                          ? wsBoxShadow()
                          : null,
                      color: Theme.of(context).colorScheme.onSurface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: bodyWidget,
                  ),
                ),
                if (extraWidget != null) extraWidget
              ],
            ),
          ),
        ),
      );
    },
  );
}

class CheckoutTotal extends StatelessWidget {
  const CheckoutTotal({super.key, this.title, this.taxRate});

  final String? title;
  final TaxRate? taxRate;

  @override
  Widget build(BuildContext context) => FutureBuilder<String>(
    future: CheckoutSession.getInstance.total(withFormat: true, taxRate: taxRate),
    builder: (BuildContext context, data) => Padding(
      padding: const EdgeInsets.only(bottom: 0, top: 15),
      child: CheckoutMetaLine(title: title, amount: data.data),
    ),
  );
}

class CheckoutTaxTotal extends StatelessWidget {
  CheckoutTaxTotal({super.key, this.taxRate});
  final appTranslations = locator<AppTranslations>();

  final TaxRate? taxRate;

  @override
  Widget build(BuildContext context) => FutureBuilder<String>(
    future: Cart.getInstance.taxAmount(taxRate),
    builder: (BuildContext context, data) => (data == "0"
        ? Container()
        : Padding(
      padding: const EdgeInsets.only(bottom: 0, top: 0),
      child: CheckoutMetaLine(
        title: appTranslations.trans(context,"Tax"),
        amount: formatStringCurrency(total: data.data),
      ),
    )),
  );
}

class CheckoutSubtotal extends StatelessWidget {
  const CheckoutSubtotal({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) => FutureBuilder<String>(
    future: Cart.getInstance.getSubtotal(withFormat: true),
    builder: (BuildContext context, data) => Padding(
      padding: const EdgeInsets.only(bottom: 0, top: 0),
      child: CheckoutMetaLine(
        title: title,
        amount: data.data,
      ),
    ),
  );
}

class CartItemContainer extends StatelessWidget {
  CartItemContainer({
    super.key,
    required this.cartLineItem,
    required this.actionIncrementQuantity,
    required this.actionDecrementQuantity,
    required this.actionRemoveItem,
  });

  final CartLineItem cartLineItem;
  final void Function() actionIncrementQuantity;
  final void Function() actionDecrementQuantity;
  final void Function() actionRemoveItem;
  final appTranslations = locator<AppTranslations>();

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 7),
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.black12,
          width: 1,
        ),
      ),
    ),
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    child: Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 2,
              child: CachedImageWidget(
                image: (cartLineItem.imageSrc == ""
                    ? getEnv("PRODUCT_PLACEHOLDER_IMAGE")
                    : cartLineItem.imageSrc),
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            Flexible(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    isNotNullOrEmpty(cartLineItem.name) ?
                    Text(
                      cartLineItem.name!,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ) :
                    const Text('Product Name'),
                    (cartLineItem.variationOptions != null
                        ? Text(cartLineItem.variationOptions!,
                        style: Theme.of(context).textTheme.bodyLarge)
                        : Container()),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          (cartLineItem.stockStatus == "outofstock"
                              ? appTranslations.trans(context,"Out of stock")
                              : appTranslations.trans(context,"In Stock")),
                          style: (cartLineItem.stockStatus == "outofstock"
                              ? Theme.of(context).textTheme.bodySmall
                              : Theme.of(context).textTheme.bodyMedium),
                        ),
                        Text(
                          formatDoubleCurrency(
                            total: parseWcPrice(cartLineItem.total),
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: actionDecrementQuantity,
                  highlightColor: Colors.transparent,
                ),
                Text(cartLineItem.quantity.toString(),
                    style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: actionIncrementQuantity,
                  highlightColor: Colors.transparent,
                ),
              ],
            ),
            IconButton(
              alignment: Alignment.centerRight,
              icon: const Icon(Icons.delete_outline,
                  color: Colors.deepOrangeAccent, size: 20),
              onPressed: actionRemoveItem,
              highlightColor: Colors.transparent,
            ),
          ],
        )
      ],
    ),
  );
}

class StoreLogo extends StatelessWidget {
  const StoreLogo(
      {super.key,
        this.height = 100,
        this.width = 100,
        this.placeholder = const CircularProgressIndicator(),
        this.fit = BoxFit.contain,
        this.showBgWhite = true});

  final bool showBgWhite;
  final double height;
  final double width;
  final Widget placeholder;
  final BoxFit fit;


  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
        color: showBgWhite ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(5)),
    child: CachedImageWidget(
      image: AppHelper.instance.appConfig?.appLogo,
      height: height,
      placeholder: SizedBox(height: height, width: width),
    ),
  );
}
