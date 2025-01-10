//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparc_sports_app/src/store/bloc/product_bloc.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/widgets/app_loader_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/buttons.dart';
import 'package:sparc_sports_app/src/store/widgets/cached_image_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/home_drawer_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/woosignal_ui.dart';
import 'package:woosignal/models/response/product_category.dart';
import 'package:woosignal/models/response/woosignal_app.dart';
import 'package:woosignal/models/response/product.dart';

class CompoHomeWidget extends StatefulWidget {
  const CompoHomeWidget({super.key, required this.wooSignalApp});

  final WooSignalApp? wooSignalApp;

  @override
  _CompoHomeWidgetState createState() => _CompoHomeWidgetState();
}

class _CompoHomeWidgetState extends State<CompoHomeWidget> {
  @override
  void initState() {
    super.initState();
    _loadHome();
  }

  _loadHome() async {
    final productBloc = BlocProvider.of<ProductBloc>(context);

    categories = await (appWooSignal((api) =>
        api.getProductCategories(parent: 0, perPage: 50, hideEmpty: true)));
    categories.sort((category1, category2) =>
        category1.menuOrder!.compareTo(category2.menuOrder!));
    productBloc.add(LoadCategories(categories));
    for (var category in categories) {
      List<Product> products = await (appWooSignal(
        (api) => api.getProducts(
          perPage: 10,
          category: category.id.toString(),
          status: "publish",
          stockStatus: "instock",
        ),
      ));
      if (products.isNotEmpty) {
        categoryAndProducts.addAll({category: products});
        setState(() {});
      }
    }
  }

  List<ProductCategory> categories = [];
  Map<ProductCategory, List<Product>> categoryAndProducts = {};

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<String>? bannerImages = widget.wooSignalApp!.bannerImages;
    return Scaffold(
      drawer: HomeDrawerWidget(wooSignalApp: widget.wooSignalApp),
      appBar: AppBar(
        centerTitle: true,
        title: const StoreLogo(),
        elevation: 0,
      ),
      body: SafeArea(
        child: categoryAndProducts.isEmpty
            ? const AppLoaderWidget()
            : ListView(
                shrinkWrap: true,
                children: [
                  if (bannerImages!.isNotEmpty)
                    SizedBox(
                      height: size.height / 2.5,
                      child: Swiper(
                        itemBuilder: (BuildContext context, int index) {
                          return CachedImageWidget(
                            image: bannerImages[index],
                            fit: BoxFit.cover,
                          );
                        },
                        itemCount: bannerImages.length,
                        viewportFraction: 0.8,
                        scale: 0.9,
                      ),
                    ),
                  ...categoryAndProducts.entries.map((catProds) {
                    double containerHeight = size.height / 1.1;
                    bool hasImage = catProds.key.image != null;
                    if (hasImage == false) {
                      containerHeight = (containerHeight / 2);
                    }
                    return Container(
                      height: containerHeight,
                      width: size.width,
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          if (hasImage)
                            InkWell(
                              child: CachedImageWidget(
                                image: catProds.key.image!.src,
                                height: containerHeight / 2,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                              onTap: () => _showCategory(catProds.key),
                            ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minHeight: 50,
                              minWidth: double.infinity,
                              maxHeight: 80.0,
                              maxWidth: double.infinity,
                            ),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: AutoSizeText(
                                      parseHtmlString(catProds.key.name!),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22),
                                      maxLines: 1,
                                    ),
                                  ),
                                  Flexible(
                                    child: SizedBox(
                                      width: size.width / 4,
                                      child: LinkButton(
                                        title: AppTranslations()
                                            .trans(context, "View All"),
                                        action: () =>
                                            _showCategory(catProds.key),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: hasImage
                                ? (containerHeight / 2) / 1.2
                                : containerHeight / 1.2,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: false,
                              itemBuilder: (cxt, i) {
                                Product product = catProds.value[i];
                                return SizedBox(
                                  height: MediaQuery.of(cxt).size.height,
                                  width: size.width / 2.5,
                                  child: ProductItemContainer(
                                      product: product, onTap: _showProduct),
                                );
                              },
                              itemCount: catProds.value.length,
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                ],
              ),
      ),
    );
  }

  _showCategory(ProductCategory productCategory) =>
      Navigator.pushNamed(context, "/browse-category",
          arguments: productCategory);

  _showProduct(Product product) {
    final productBloc = BlocProvider.of<ProductBloc>(context);
    productBloc.add(UpdateSelectedProduct(product));
    Navigator.pushNamed(context, "/product-detail", arguments: product);
  }
}
