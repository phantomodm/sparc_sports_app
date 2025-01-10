//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/utils/wooSignal.dart';
import 'package:sparc_sports_app/src/store/widgets/app_loader_widget.dart';
import 'package:sparc_sports_app/src/store/controllers/woosignal_api_loader_controller.dart';
import 'package:woosignal/models/response/woosignal_app.dart';

import '../bloc/state_management.dart';

class ProductDetailUpsellWidget extends StatefulWidget {
  const ProductDetailUpsellWidget(
      {super.key, required this.productIds, required this.wooSignalApp});

  final List<int>? productIds;
  final WooSignalApp? wooSignalApp;


  @override
  _ProductDetailUpsellWidgetState createState() =>
      _ProductDetailUpsellWidgetState();
}

class _ProductDetailUpsellWidgetState extends State<ProductDetailUpsellWidget> {
  final appTranslations = locator<AppTranslations>();

  bool _isLoading = true;
  late dynamic wooSignalApiLoader = WooSignalApiLoaderController();

  @override
  void initState() {
    super.initState();
    //fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const AppLoaderWidget();
          } else if (state is ProductLoaded) {
            if (widget.productIds!.isEmpty ||
                state.upSells.isEmpty) {
              return const SizedBox.shrink();
            } else {
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          appTranslations.trans(
                              context, "${appTranslations.trans(context,
                              'You may also like')}…"),
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 18),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: state.upSells
                          .map(
                            (e) =>
                            SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 2.2,
                              child: ProductItemContainer(product: e),
                            ),
                      ).toList(),
                    )
                  ),
                ],
              );
            }
          }
          return const SizedBox.shrink();
        }
    );

  }

  Future<void> _loadProducts(
      {required bool Function(bool hasProducts) hasResults,
        required void Function() didFinish,
        List<int>? productIds = const []}) async {
    await wooSignalApiLoader.load(
        hasResults: hasResults,
        didFinish: didFinish,
        apiQuery: (api) =>
            api.getProducts(
              perPage: 50,
              page: wooSignalApiLoader.page,
              include: productIds,
              status: "publish",
              stockStatus: "instock",
            ));
  }

  Future fetchProducts() async {
    /*await _loadProducts(
        hasResults: (result) {
          if (result == false) {
            return false;
          }
          return true;
        },
        didFinish: () {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        },
        productIds: widget.productIds);
  }*/
  }
}
