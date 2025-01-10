//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:sparc_sports_app/src/store/classes/sparc_widgets.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/enum/toasts_enums.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/utils/toasts/toast_notification.dart';
import 'package:sparc_sports_app/src/store/widgets/cached_image_widget.dart';

import 'package:woosignal/models/response/product.dart';

class WishListPageWidget extends StatefulWidget {
  @override
  _WishListPageWidgetState createState() => _WishListPageWidgetState();
}

class _WishListPageWidgetState extends SparcState<WishListPageWidget> {
  List<Product> _products = [];
  final appTranslations = locator<AppTranslations>();

  @override
  initState() async {
    super.initState();
    await loadProducts();
  }

  loadProducts() async {
    List<dynamic> favouriteProducts = await getWishlistProducts();
    List<int> productIds =
        favouriteProducts.map((e) => e['id']).cast<int>().toList();
    if (productIds.isEmpty) {
      return;
    }
    _products = await (appWooSignal((api) => api.getProducts(
          include: productIds,
          perPage: 100,
          status: "publish",
          stockStatus: "instock",
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(appTranslations.trans(context, "Wishlist")),
      ),
      body: SafeArea(
        child: _products.isEmpty
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.favorite,
                      size: 40,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    Text(appTranslations.trans(context, "No items found"),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ))
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.only(top: 10),
                itemBuilder: (BuildContext context, int index) {
                  Product product = _products[index];
                  return InkWell(
                    onTap: () => Navigator.pushNamed(context, "/product-detail",
                        arguments: product),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          width: MediaQuery.of(context).size.width / 4,
                          child: CachedImageWidget(
                            image: (product.images.isNotEmpty
                                ? product.images.first.src
                                : getEnv("PRODUCT_PLACEHOLDER_IMAGE")),
                            fit: BoxFit.contain,
                            width: double.infinity,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                product.name!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                formatStringCurrency(total: product.price),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 5,
                          alignment: Alignment.center,
                          child: IconButton(
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            onPressed: () => _removeFromWishlist(product),
                          ),
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
                itemCount: _products.length),
      ),
    );
  }

  _removeFromWishlist(Product product) async {
    await removeWishlistProduct(product: product);
    if (mounted) {
      ToastHelper().showToastNotification(
        context,
        title: appTranslations.trans(context, 'Success'),
        icon: Icons.shopping_cart,
        description: appTranslations.trans(context, 'Item removed'),
        style: ToastNotificationStyleType.SUCCESS,
      );
    }
    _products.remove(product);
    setState(() {});
  }
}
