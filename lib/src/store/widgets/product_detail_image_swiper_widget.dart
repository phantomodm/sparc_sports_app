//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:woosignal/models/response/product.dart';

class ProductDetailImageSwiperWidget extends StatelessWidget {
  const ProductDetailImageSwiperWidget(
      {super.key, required this.product, required this.onTapImage});

  final Product? product;
  final void Function(int i) onTapImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.40,
      child: SizedBox(
        child: CarouselSlider(
          options: CarouselOptions(
          height: 300,
          viewportFraction: 1.0,
          enlargeCenterPage: true,
          autoPlay: true,
        ),
        items: product!.images.isNotEmpty ?
        product!.images.map((dynamic image) {
          return Builder(
            builder: (BuildContext context) {
              return Image.network(
                image.src,
                fit: BoxFit.cover,
              );
            },
          );
        }).toList() : [
          Image.network(
            getEnv("PRODUCT_PLACEHOLDER_IMAGE"),
            fit: BoxFit.cover,
          ),        
        ],
        )
        // Swiper(
        //   itemBuilder: (BuildContext context, int index) => CachedImageWidget(
        //     image: product!.images.isNotEmpty
        //         ? product!.images[index].src
        //         : getEnv("PRODUCT_PLACEHOLDER_IMAGE"),
        //   ),
        //   itemCount: product!.images.isEmpty ? 1 : product!.images.length,
        //   viewportFraction: 0.85,
        //   scale: 0.9,
        //   onTap: onTapImage,
        // )
        ,
      ),
    );
  }
}
