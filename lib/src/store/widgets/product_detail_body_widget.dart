
// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparc_sports_app/src/store/widgets/product_detail_description_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/product_detail_header_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/product_detail_image_swiper_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/product_detail_related_products_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/product_detail_reviews_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/product_detail_upsell_widget.dart';
import 'package:sparc_sports_app/src/store/bloc/product_bloc.dart';
import 'package:woosignal/models/response/product.dart';
import 'package:woosignal/models/response/woosignal_app.dart';

class ProductDetailBodyWidget extends StatelessWidget {
  const ProductDetailBodyWidget(
      {super.key, required this.product, required this.wooSignalApp});

  final Product? product;
  final WooSignalApp? wooSignalApp;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProductBloc>().state;
    final Product product = state is ProductLoaded ? state.currentProduct! : this.product!;
    
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        ProductDetailImageSwiperWidget(
            product: product,
            onTapImage: (i) => _viewProductImages(context, i)),
        // </Image Swiper>

        ProductDetailHeaderWidget(product: product),
        // </Header title + price>

        ProductDetailDescriptionWidget(product: product),
        // </Description body>

        ProductDetailReviewsWidget(
            product: product, wooSignalApp: wooSignalApp),
        // </Product reviews>

        if (product != null)
          ProductDetailUpsellWidget(
              productIds: product.upsellIds, wooSignalApp: wooSignalApp),
        // </You may also like>

        ProductDetailRelatedProductsWidget(
            product: product, wooSignalApp: wooSignalApp)
        // </Related products>
      ],
    );
  }

  _viewProductImages(BuildContext context, int i) =>
      Navigator.pushNamed(context, "/product-images", arguments: {
        "index": i,
        "images": product!.images.map((f) => f.src).toList()
      });
}
