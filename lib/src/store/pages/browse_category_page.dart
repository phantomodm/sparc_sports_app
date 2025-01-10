//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/store/classes/sparc_widgets.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/controllers/browse_category_controller.dart';
import 'package:sparc_sports_app/src/store/controllers/product_category_search_loader_controller.dart';
import 'package:sparc_sports_app/src/store/enum/sort_enums.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/utils/wooSignal.dart';
import 'package:sparc_sports_app/src/store/widgets/app_loader_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/buttons.dart';
import 'package:sparc_sports_app/src/store/widgets/safearea_widget.dart';
import 'package:woosignal/models/response/product_category.dart';
import 'package:woosignal/models/response/product.dart' as ws_product;

class BrowseCategoryPage extends SparcStatefulWidget {
  static String path = "/product-search";

  @override
  final BrowseCategoryController controller = BrowseCategoryController();

  BrowseCategoryPage({Key? key})
      : super(path, key: key, child: _BrowseCategoryPageState());
}

class _BrowseCategoryPageState extends SparcState<BrowseCategoryPage> {
  ProductCategory? productCategory;
  _BrowseCategoryPageState();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ProductCategorySearchLoaderController
      _productCategorySearchLoaderController =
      ProductCategorySearchLoaderController();
  final appTranslations = locator<AppTranslations>();

  bool _shouldStopRequests = false;
  bool _isLoading = true;

  @override
  initState() async {
    super.initState();
    productCategory = data();
    await fetchProducts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(appTranslations.trans(context, "Browse"),
                style: Theme.of(context).textTheme.titleMedium),
            productCategory != null
                ? Text(parseHtmlString(productCategory!.name))
                : const CupertinoActivityIndicator(),
          ],
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _modalSheetTune,
          )
        ],
      ),
      body: SafeAreaWidget(
        child: _isLoading
            ? const Center(
                child: AppLoaderWidget(),
              )
            : refreshableScroll(
                context,
                refreshController: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                products: _productCategorySearchLoaderController.getResults(),
                onTap: _showProduct,
              ),
      ),
    );
  }

  void _onRefresh() async {
    _productCategorySearchLoaderController.clear();
    await fetchProducts();

    setState(() {
      _shouldStopRequests = false;
      _refreshController.refreshCompleted(resetFooterState: true);
    });
  }

  void _onLoading() async {
    await fetchProducts();

    if (mounted) {
      setState(() {});
      if (_shouldStopRequests) {
        _refreshController.loadNoData();
      } else {
        _refreshController.loadComplete();
      }
    }
  }

  _sortProducts({required SortByType by}) {
    List<ws_product.Product> products =
        _productCategorySearchLoaderController.getResults();
    switch (by) {
      case SortByType.lowToHigh:
        products.sort(
          (product1, product2) => (parseWcPrice(product1.price))
              .compareTo((parseWcPrice(product2.price))),
        );
        break;
      case SortByType.highToLow:
        products.sort(
          (product1, product2) => (parseWcPrice(product2.price))
              .compareTo((parseWcPrice(product1.price))),
        );
        break;
      case SortByType.nameAZ:
        products.sort(
          (product1, product2) => product1.name!.compareTo(product2.name!),
        );
        break;
      case SortByType.nameZA:
        products.sort(
          (product1, product2) => product2.name!.compareTo(product1.name!),
        );
        break;
    }
    setState(() {
      Navigator.pop(context);
    });
  }

  _modalSheetTune() {
    wsModalBottom(
      context,
      title: appTranslations.trans(context, "Sort results"),
      bodyWidget: ListView(
        children: <Widget>[
          LinkButton(
            title: appTranslations.trans(context, "Sort: Low to high"),
            action: () => _sortProducts(by: SortByType.lowToHigh),
          ),
          const Divider(
            height: 0,
          ),
          LinkButton(
            title: appTranslations.trans(context, "Sort: High to low"),
            action: () => _sortProducts(by: SortByType.highToLow),
          ),
          const Divider(
            height: 0,
          ),
          LinkButton(
            title: appTranslations.trans(context, "Sort: Name A-Z"),
            action: () => _sortProducts(by: SortByType.nameAZ),
          ),
          const Divider(
            height: 0,
          ),
          LinkButton(
            title: appTranslations.trans(context, "Sort: Name Z-A"),
            action: () => _sortProducts(by: SortByType.nameZA),
          ),
          const Divider(
            height: 0,
          ),
          LinkButton(title: appTranslations.trans(context, "Cancel"), action: _dismissModal)
        ],
      ),
    );
  }

  Future fetchProducts() async {
    await _productCategorySearchLoaderController.loadProducts(
      hasResults: (result) {
        if (result == false) {
          setState(() {
            _isLoading = false;
            _shouldStopRequests = true;
          });
          return false;
        }
        return true;
      },
      didFinish: () => setState(() {
        _isLoading = false;
      }),
      productCategory: productCategory,
    );
  }

  _dismissModal() => Navigator.pop(context);

  _showProduct(ws_product.Product product) {
    Navigator.pushNamed(context, "/product-detail", arguments: product);
  }
}
