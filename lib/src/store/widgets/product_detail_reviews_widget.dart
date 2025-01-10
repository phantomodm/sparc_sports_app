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
import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/widgets/product_detail_review_tile_widget.dart';
import 'package:woosignal/models/response/product_review.dart';
import 'package:woosignal/models/response/product.dart';
import 'package:woosignal/models/response/woosignal_app.dart';

class ProductDetailReviewsWidget extends StatefulWidget {
  const ProductDetailReviewsWidget(
      {super.key, required this.product, required this.wooSignalApp});
  final Product? product;
  final WooSignalApp? wooSignalApp;

  @override
  _ProductDetailReviewsWidgetState createState() =>
      _ProductDetailReviewsWidgetState();
}

class _ProductDetailReviewsWidgetState
    extends State<ProductDetailReviewsWidget> {
  bool _ratingExpanded = false;
  final appTranslations = locator<AppTranslations>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.product!.reviewsAllowed == false ||
        widget.wooSignalApp!.showProductReviews == false) {
      return const SizedBox.shrink();
    }

    return Row(
      children: <Widget>[
        Expanded(
            child: ExpansionTile(
          textColor: Theme.of(context).colorScheme.secondary,
          iconColor: Theme.of(context).colorScheme.secondary,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.all(0),
          title: AutoSizeText(
            "${appTranslations.trans(context,  "Reviews")} (${widget.product!.ratingCount})",
            maxLines: 1,
          ),
          onExpansionChanged: (value) {
            setState(() {
              _ratingExpanded = value;
            });
          },
          trailing: SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RatingBarIndicator(
                  rating: double.parse(widget.product!.averageRating!),
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 25.0,
                  direction: Axis.horizontal,
                ),
                Icon(
                    _ratingExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    size: 30)
              ],
            ),
          ),
          initiallyExpanded: false,
          children: [
            if (_ratingExpanded == true)
              FutureBuilder<List<ProductReview>>(
                future: fetchReviews(),
                builder: (context, reviews) {
                  if (reviews.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (reviews.hasError) {
                    return Text('Error: ${reviews.error}');
                  } else if (reviews.hasData) {
                    int reviewsCount = reviews.data!.length;
                    List<Widget> childrenWidgets = reviews.data!
                        .map((review) => ProductDetailReviewTileWidget(
                            productReview: review))
                        .toList();

                    if (reviewsCount >= 5) {
                      childrenWidgets.add(
                        ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          title: Text(appTranslations.trans(context,  'See More Reviews')),
                          onTap: () => Navigator.pushNamed(
                            context,
                            "/product-reviews",
                            arguments: widget.product,
                          ),
                        ),
                      );
                    }

                    return ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(0),
                      children: reviews.data!.isEmpty
                          ? [
                              ListTile(
                                title: Text(appTranslations.trans(context, 'There are no reviews yet.')),
                              )
                            ]
                          : childrenWidgets,
                    );
                  } else {
                    return ListTile(
                      title: Text(
                          appTranslations.trans(context,  'There are no reviews yet.')),
                    );
                  }
                }, 
              ),
          ],
        )),
      ],
    );
  }

  Future<List<ProductReview>> fetchReviews() async {
    return await appWooSignal(
      (api) => api.getProductReviews(
          perPage: 5, product: [widget.product!.id!], status: "approved"),
    );
  }
}
