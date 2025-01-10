//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/store/classes/sparc_widgets.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:sparc_sports_app/src/store/controllers/product_image_viewer_controller.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/widgets/cached_image_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/safearea_widget.dart';


class ProductImageViewerPage extends SparcStatefulWidget {
  static String path = "/product-images";

  final ProductImageViewerController controller = ProductImageViewerController();

  ProductImageViewerPage({Key? key})
      : super(path, key: key, child: _ProductImageViewerPageState());
}

class _ProductImageViewerPageState extends SparcState<ProductImageViewerPage> {
  int? _initialIndex;
  List<String?> _arrImageSrc = [];

  @override
  void initState() {
    Map<String, dynamic> imageData = data();
    _initialIndex = imageData['index'];
    _arrImageSrc = imageData['images'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeAreaWidget(
        child: Column(
          children: [
            Expanded(
              child: Swiper(
                index: _initialIndex!,
                itemBuilder: (BuildContext context, int index) =>
                    CachedImageWidget(
                  image: (_arrImageSrc.isEmpty
                      ? getEnv("PRODUCT_PLACEHOLDER_IMAGE")
                      : _arrImageSrc[index]),
                ),
                itemCount: _arrImageSrc.isEmpty ? 1 : _arrImageSrc.length,
                viewportFraction: 0.9,
                scale: 0.95,
              ),
            ),
            Container(
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            )
          ],
        ),
      ),
    );
  }
}
