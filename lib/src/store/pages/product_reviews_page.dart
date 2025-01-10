//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/store/classes/sparc_widgets.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/controllers/product_reviews_controller.dart';
import 'package:sparc_sports_app/src/store/controllers/product_reviews_loader_controller.dart';
import 'package:sparc_sports_app/src/store/widgets/app_loader_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/no_results_for_products_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/product_review_item_container_widget.dart';
import 'package:woosignal/models/response/product_review.dart';
import 'package:woosignal/models/response/product.dart';

class ProductReviewsPage extends SparcStatefulWidget {
  static String path = "/product-images";

  @override
  final ProductReviewsController controller = ProductReviewsController();

  ProductReviewsPage({Key? key})
      : super(path, key: key, child: _ProductReviewsPageState());
}

class _ProductReviewsPageState extends SparcState<ProductReviewsPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Product? _product;
  bool _shouldStopRequests = false, _isLoading = true;
  final appTranslations = locator<AppTranslations>();

  final ProductReviewsLoaderController _productReviewsLoaderController =
      ProductReviewsLoaderController();

  @override
  initState() async {
    super.initState();
    _product = data() as Product?;
    await fetchProductReviews();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<ProductReview> productReviews =
        _productReviewsLoaderController.getResults();
    return Scaffold(
      appBar: AppBar(
        title: Text(appTranslations.trans(context,'Reviews')),
        centerTitle: true,
      ),
      body: _isLoading
          ? const AppLoaderWidget()
          : SafeArea(
              child: Column(
                // shrinkWrap: true,
                children: [
                  Container(
                    height: mediaQuery.size.height / 5,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.black12))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _product!.name!,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "${_product!.ratingCount} Reviews",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: Text(
                                "${_product!.averageRating!} Stars",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            RatingBarIndicator(
                              rating: double.parse(_product!.averageRating!),
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 20.0,
                              direction: Axis.horizontal,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      footer: CustomFooter(
                        builder: (BuildContext context, LoadStatus? mode) {
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
                            return const SizedBox.shrink();
                          }
                          return SizedBox(
                            height: 55.0,
                            child: Center(child: body),
                          );
                        },
                      ),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      child: (productReviews.isNotEmpty
                          ? StaggeredGrid.count(
                              crossAxisCount: 2,
                              axisDirection: AxisDirection.down,
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                              children:
                                  productReviews.mapIndexed((index, value) {
                                ProductReview productReview =
                                    productReviews[index];

                                return StaggeredGridTile.fit(
                                    crossAxisCellCount: 2,
                                    // mainAxisCellCount: 2,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      margin: const EdgeInsets.only(bottom: 8),
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.black12))),
                                      child: ProductReviewItemContainerWidget(
                                          productReview: productReview),
                                    ));
                              }).toList(),
                            )
                          : NoResultsForProductsWidget()),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  _onRefresh() async {
    _productReviewsLoaderController.clear();
    await fetchProductReviews();

    setState(() {
      _shouldStopRequests = false;
      _refreshController.refreshCompleted(resetFooterState: true);
    });
  }

  _onLoading() async {
    await fetchProductReviews();

    if (mounted) {
      setState(() {});
      if (_shouldStopRequests) {
        _refreshController.loadNoData();
      } else {
        _refreshController.loadComplete();
      }
    }
  }

  Future fetchProductReviews() async {
    await _productReviewsLoaderController.loadProductReviews(
        product: _product,
        hasResults: (result) {
          if (result == false) {
            setState(() {
              _shouldStopRequests = true;
            });
            return false;
          }
          return true;
        },
        didFinish: () => setState(() {
              _isLoading = false;
            }));
  }
}
