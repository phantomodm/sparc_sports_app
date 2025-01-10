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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparc_sports_app/src/store/bloc/product_bloc.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sparc_sports_app/src/store/classes/sparc_widgets.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/controllers/product_loader_controller.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/widgets/cached_image_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/home_drawer_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/no_results_for_products_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/safearea_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/woosignal_ui.dart';
import 'package:woosignal/models/response/woosignal_app.dart';
import 'package:woosignal/models/response/product_category.dart' as ws_category;
import 'package:woosignal/models/response/product.dart' as ws_product;

class NoticHomeWidget extends StatefulWidget {
  const NoticHomeWidget({super.key, required this.wooSignalApp});

  final WooSignalApp? wooSignalApp;


  @override
  _NoticHomeWidgetState createState() => _NoticHomeWidgetState();
}

class _NoticHomeWidgetState extends SparcState<NoticHomeWidget> {
  Widget? activeWidget;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ProductLoaderController _productLoaderController =
      ProductLoaderController();
  List<ws_category.ProductCategory> _categories = [];
  final appTranslations = locator<AppTranslations>();

  bool _shouldStopRequests = false;

  @override
  initState() async {
    super.initState();
    await _home();
  }

  _home() async {
    await fetchProducts();
    await _fetchCategories();
  }

  _fetchCategories() async {
    _categories =
        await (appWooSignal((api) => api.getProductCategories(perPage: 100)));
  }

  _modalBottomSheetMenu() {
    wsModalBottom(
      context,
      title: appTranslations.trans(context, "Categories"),
      bodyWidget: ListView.separated(
        itemCount: _categories.length,
        separatorBuilder: (cxt, i) => const Divider(),
        itemBuilder: (BuildContext context, int index) => ListTile(
          title: Text(parseHtmlString(_categories[index].name)),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, "/browse-category",
                    arguments: _categories[index])
                .then((value) => setState(() {}));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //List<ws_product.Product> products = _productLoaderController.getResults();
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if(state is ProductLoaded) {
          final products = state.products;
          print(products);
          return Scaffold(
          drawer: HomeDrawerWidget(wooSignalApp: widget.wooSignalApp),
          appBar: AppBar(
              title: const StoreLogo(height: 55),
              centerTitle: true,
              actions: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: _modalBottomSheetMenu,
                      child: Text(
                        appTranslations.trans(context, "Categories"),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
              ]),
          body: SafeAreaWidget(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Expanded(
                  flex: 1,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        height: MediaQuery.of(context).size.height / 2.5,
                        child: Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return CachedImageWidget(
                              image: widget.wooSignalApp!.bannerImages![index],
                              fit: BoxFit.cover,
                            );
                          },
                          itemCount: widget.wooSignalApp!.bannerImages!.length,
                          viewportFraction: 0.8,
                          scale: 0.9,
                        ),
                      ),
                      SizedBox(
                        height: 75,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(appTranslations.trans(context, "Must have")),
                            Flexible(
                              child: Text(
                                appTranslations.trans(
                                    context, "Our selection of new items"),
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 380,
                        child: products!.isNotEmpty ? SmartRefresher(
                          enablePullDown: true,
                          enablePullUp: true,
                          footer: CustomFooter(
                            builder: (BuildContext context, LoadStatus? mode) {
                              Widget body;
                              if (mode == LoadStatus.idle) {
                                body = Text(AppTranslations()
                                    .trans(context, "pull up load"));
                              } else if (mode == LoadStatus.loading) {
                                body = const CupertinoActivityIndicator();
                              } else if (mode == LoadStatus.failed) {
                                body = Text(appTranslations.trans(
                                    context, "Load Failed! Click retry!"));
                              } else if (mode == LoadStatus.canLoading) {
                                body = Text(AppTranslations()
                                    .trans(context, "release to load more"));
                              } else {
                                return const SizedBox.shrink();
                              }
                              return SizedBox(
                                height: 55.0,
                                child: Center(
                                    child: mode != null ? body : const SizedBox.shrink()
                                ),
                              );
                            },
                          ),
                          controller: _refreshController,
                          onRefresh: _onRefresh,
                          onLoading: _onLoading,
                          child: (products.isNotEmpty
                              ? ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: false,
                                  itemBuilder: (cxt, i) {
                                    final product = products[i];
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      child: ProductItemContainer(
                                          product: product,
                                          onTap: _showProduct),
                                    );
                                  },
                                  itemCount: products.length,
                                )
                              : NoResultsForProductsWidget()),
                        ) : NoResultsForProductsWidget()) ,

                    ],
                  ),
                )
              ])));
        } else {
          if(state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if(state is ProductLoaded && state.products!.isEmpty) {
            return NoResultsForProductsWidget();
          } else if(state is ProductError) {            
            return const SizedBox.shrink();
          } else {
            return NoResultsForProductsWidget();
          }          
        }      
      }
    );
  }

  _onRefresh() async {
    _productLoaderController.clear();
    await fetchProducts();

    setState(() {
      _shouldStopRequests = false;
      _refreshController.refreshCompleted(resetFooterState: true);
    });
  }

  _onLoading() async {
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

  Future fetchProducts() async {
    await _productLoaderController.loadProducts(
        hasResults: (result) {
          if (result == false) {
            setState(() {
              _shouldStopRequests = true;
            });
            return false;
          }
          return true;
        },
        didFinish: () => setState(() {}));
  }

  _showProduct(ws_product.Product product) {
    final productBloc = BlocProvider.of<ProductBloc>(context);
    productBloc.add(UpdateSelectedProduct(product));
    Navigator.pushNamed(context, "/product-detail", arguments: product);
  }
}
