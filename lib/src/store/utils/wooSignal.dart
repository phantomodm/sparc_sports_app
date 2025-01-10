// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/widgets/store_widgets.dart';
import 'package:woosignal/models/response/product.dart';

class ProductItemContainer extends StatelessWidget {
  ProductItemContainer({
    Key? key,
    this.product,
    this.onTap,
  }) : super(key: key);

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
                      image: (product!.images.isNotEmpty
                          ? product!.images.first.src
                          : getEnv("PRODUCT_PLACEHOLDER_IMAGE")),
                      fit: BoxFit.contain,
                      height: height,
                      width: double.infinity,
                    ),
                    if (isProductNew(product))
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.black),
                        child: const Text(
                          "New",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    if (product!.onSale! && product!.type != "variable")
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
                                      "${workoutSaleDiscount(salePrice: product!.salePrice, priceBefore: product!.regularPrice)}% ${appTranslations.trans(context, "off")}",
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
                          text: '${appTranslations.trans(context, "Was")}: ',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 11,
                                  ),
                        ),
                        TextSpan(
                          text: formatStringCurrency(
                            total: product!.regularPrice,
                          ),
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
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
          : Navigator.pushNamed(context, "/product-detail", arguments: product),
    );
  }
}

void wsModalBottom(BuildContext context,
    {String? title, Widget? bodyWidget, Widget? extraWidget}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allow the sheet to expand to its full height
    backgroundColor: Colors.transparent,
    transitionAnimationController: AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: Navigator.of(context).overlay!,
    ),
    builder: (builder) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300, // Customize color as needed
                  blurRadius: 5,
                  offset: const Offset(3, 3),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  if (title != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        title,
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                  Flexible(
                    child: bodyWidget ?? Container(),
                  ),
                  if (extraWidget != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: extraWidget,
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

/*List<BoxShadow> wsBoxShadow({double? blurRadius}) => [
      BoxShadow(
        color: const Color(0xFFE8E8E8),
        blurRadius: blurRadius ?? 15.0,
        spreadRadius: 0,
        offset: const Offset(0, 0),
      )
    ];*/
