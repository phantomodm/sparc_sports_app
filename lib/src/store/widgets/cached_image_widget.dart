//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';

class CachedImageWidget extends StatelessWidget {
  const CachedImageWidget({
    super.key,
    this.image,
    this.height = 70,
    this.width = 70,
    this.placeholder = const Center(
      child: CircularProgressIndicator(
          strokeWidth: 2,
          backgroundColor: Colors.black12,
          color: Colors.black54),
    ),
    this.fit = BoxFit.contain,
  });

  final String? image;
  final double height;
  final double width;
  final Widget placeholder;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
        imageUrl: isNotNullOrEmpty(image) ? image! : 'https://placehold.it/200x200.png' ,
        placeholder: (context, url) => placeholder,
        errorWidget: (context, url, error) => const Icon(Icons.error),
        height: height,
        width: width,
        alignment: Alignment.center,
        fit: fit,
      );
}
