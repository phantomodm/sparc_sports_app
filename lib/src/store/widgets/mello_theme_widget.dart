import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/bloc/state_management.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/controllers/product_loader_controller.dart';
import 'package:sparc_sports_app/src/store/services/product_service.dart';
import 'package:sparc_sports_app/src/store/widgets/cart_icon_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/home_drawer_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/safearea_widget.dart';
import 'package:sparc_sports_app/src/store/widgets/woosignal_ui.dart';
import 'package:woosignal/models/response/woosignal_app.dart';
import 'package:woosignal/models/response/product_category.dart' as ws_category;
import 'package:woosignal/models/response/product.dart' as ws_product;


class MelloThemeWidget extends StatefulWidget {
  const MelloThemeWidget(
      {Key? key, required this.globalKey, required this.wooSignalApp})
      : super(key: key);

  final GlobalKey globalKey;
  final WooSignalApp? wooSignalApp;

  @override
  _MelloThemeWidgetState createState() => _MelloThemeWidgetState();
}

class _MelloThemeWidgetState extends State<MelloThemeWidget> {
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  final ProductLoaderController _productLoaderController =
  ProductLoaderController();
  List<ws_category.ProductCategory> _categories = [];
  bool _shouldStopRequests = false;

  ProductService productService = locator<ProductService>();
  final appTranslations = locator<AppTranslations>();

  @override
  void initState() {
    // TODO: implement initState
    _home();
    super.initState();
    print(_productLoaderController
        .getResults()
        .length);
  }

  _home() async {
    //await fetchProducts();
    print('Add initialData');
    context.read<ProductBloc>().add(LoadProducts());
    await _fetchCategories();
  }

  _fetchCategories() async {
    _categories =
    await (appWooSignal((api) => api.getProductCategories(perPage: 100)));
    final categories = context.read<ProductBloc>();
    categories.add(LoadCategories(_categories));
  }

  _modalBottomSheetMenu() {
    widget.globalKey.currentState!.setState(() {});
    wsModalBottom(
      context,
      title: appTranslations.trans(context, "Categories"),
      bodyWidget: ListView.separated(
        itemCount: _categories.length,
        separatorBuilder: (cxt, i) => const Divider(),
        itemBuilder: (BuildContext context, int index) =>
            ListTile(
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
    List<String>? bannerImages =
    isNotNullOrEmpty(widget.wooSignalApp?.bannerImages)
        ? widget.wooSignalApp?.bannerImages
        : widget.wooSignalApp?.bannerImages;
    return Scaffold(
        drawer: HomeDrawerWidget(wooSignalApp: widget.wooSignalApp),
        appBar: AppBar(
          title: const StoreLogo(height: 55),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              alignment: Alignment.centerLeft,
              icon: const Icon(
                Icons.search,
                size: 35,
              ),
              onPressed: () =>
                  Navigator.pushNamed(context, "/home-search")
                      .then((value) =>
                      widget.globalKey.currentState!.setState(() {})),
            ),
            CartIconWidget(key: widget.globalKey),
          ],
        ),
        body: SafeAreaWidget(
          child: BlocBuilder<ProductBloc, ProductState>(
            // Add BlocBuilder
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(
                    child:
                    CircularProgressIndicator()); // Show loading indicator
              } else if (state is ProductLoaded) {
                return RefreshableScrollContainer(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  products: state.products,
                  // Access products from the bloc's state
                  onTap: _showProduct,
                  bannerHeight: MediaQuery
                      .of(context)
                      .size
                      .height / 3.5,
                  bannerImages: bannerImages,
                  modalBottomSheetMenu: _modalBottomSheetMenu,
                );
              } else if (state is ProductError) {
                return Center(
                    child:
                    Text('Error: ${state.error}')); // Display error message
              } else {
                return const SizedBox.shrink(); // Or any other default widget
              }
            },
            /*child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: RefreshableScrollContainer(
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                products: _productLoaderController.getResults(),
                onTap: _showProduct,
                bannerHeight: MediaQuery.of(context).size.height / 3.5,
                bannerImages: bannerImages,
                modalBottomSheetMenu: _modalBottomSheetMenu,
              ),
            ),
          ],
        ),*/
          ),
        ));
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
    final productBloc = context.read<ProductBloc>();
    final state = productBloc.state;
    if (state is ProductLoaded) {
      isNotNullOrEmpty(state.products) ? setState(() {
        _shouldStopRequests = true;
      }) : productBloc.add(LoadProducts());
      return false;
    }
    /*await _productLoaderController.loadProducts(
        hasResults: (result) {
          if (result == false) {
            setState(() {
              _shouldStopRequests = true;
            });
            return false;
          }
          return true;
        },
        didFinish: () => setState(() {}));*/
  }

  _showProduct(ws_product.Product product) {
    final productBloc = context.read<ProductBloc>();
    print(product);
    productBloc.add(UpdateSelectedProduct(product));
    print('Dispatched');

    Navigator.pushNamed(context, "/product-detail", arguments: product)
        .then((value) => widget.globalKey.currentState!.setState(() {}));
  }
}
