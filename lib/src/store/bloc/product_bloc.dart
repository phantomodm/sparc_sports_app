import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparc_sports_app/src/store/bloc/cart_bloc.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/controllers/controllers.dart';
import 'package:sparc_sports_app/src/store/enum/toasts_enums.dart';
import 'package:sparc_sports_app/src/store/services/product_service.dart';
import 'package:woosignal/models/response/product.dart';
import 'package:woosignal/models/response/product_category.dart';
import 'package:woosignal/models/response/product_variation.dart';
import 'package:woosignal/woosignal.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductService productService;

  /*final void Function(bool) updateShouldStopRequests;*/
  @override
  void onTransition(Transition<ProductEvent, ProductState> transition) {
    super.onTransition(transition);
    print(transition); // Print the transition details
  }
  Future<dynamic> loadProducts() async {
    return await ProductLoaderController().loadProducts(
        hasResults: (bool hasProducts) {
          if (hasProducts == false) {
            return false;
          }
          return true;
        },
        didFinish: () {});
  }

  ProductBloc({required this.productService}) : super(const ProductLoading()) {

    on<ApplyFilters>((event, emit) async {
      emit(const ProductLoading());
      try {
        final currentState = state; // Get the current state of the bloc
        final products =
            currentState is ProductLoaded && currentState.products!.isNotEmpty
                ? currentState.products // Use products from the state
                : await loadProducts().then((results) {
                    final productList = results as List<dynamic>;
                    emit(ProductLoaded(productList as List<Product>));
                    return productList;
                  });
        final filteredProducts = _applyFilters(products as List<dynamic>, event.filterCriteria);
        emit(ProductLoaded(filteredProducts as List<Product>));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
    on<DecrementQuantity>((event, emit) {
      if (state is ProductLoaded) {
        final loadedState = state as ProductLoaded;
        emit(ProductLoaded(
          loadedState.products, // Pass the products list here
          selectedProductId: loadedState.selectedProductId,
          currentProduct: loadedState.currentProduct,
          quantity: loadedState.quantity - 1,
        ));
        // Dispatch an event to CartBloc
        final cartBloc = locator<CartBloc>();
        if(cartBloc.state is CartItemLoaded){
          cartBloc.add(UpdateCartItemQuantity(
            productId: loadedState.currentProduct!.id!, // Assuming you have the product ID
            quantityChange: -1,
          ));
        }
      }
    });
    on<FetchProductVariations>((event, emit) async {
      if (state is ProductLoaded) {
        final loadedState = state as ProductLoaded;
        try {
          final variations =
          await productService.fetchProductVariations(event.productId);
          emit(loadedState.copyWith(variations: variations));
        } catch (e) {
          // TODO: Handle error
        }
      }
    });
    on<IncrementQuantity>((event, emit) {
      if (state is ProductLoaded) {
        final loadedState = state as ProductLoaded;
        emit(ProductLoaded(
          loadedState.products, // Pass the products list here
          selectedProductId: loadedState.selectedProductId,
          currentProduct: loadedState.currentProduct,
          quantity: loadedState.quantity + 1,
        ));
        // Dispatch an event to CartBloc
        final cartBloc = locator<CartBloc>();
        if(cartBloc.state is CartItemLoaded){
          cartBloc.add(UpdateCartItemQuantity(
            productId: loadedState.currentProduct!.id!, // Assuming you have the product ID
            quantityChange: 1,
          ));
        }
      }
    });
    on<LoadCategories>((event, emit) async {
      if (state is ProductLoaded) {
        final loadedState = state as ProductLoaded;
        if (loadedState.categories.isNotEmpty) {
          emit(state);
          return;
        }
      }

      try {
        final loadedState = state as ProductLoaded; // No need to check for ProductLoaded again
        final results = await WooSignal.instance.getProductCategories();
        emit(ProductLoaded(
          loadedState.products,
          categories: results,
          currentProduct: loadedState.currentProduct,
          quantity: loadedState.quantity,
          variations: loadedState.variations,
          selectedProductId: loadedState.selectedProductId,
        ));
      } catch (e) {
        if (e is SocketException || e is TimeoutException) {
          emit(ProductError(e.toString()));
        } else {
          emit(ProductError(e.toString()));
        }
      }
    });

    on<LoadProducts>((event, emit) async {
      if (state is ProductLoaded ) {
        // Products are already loaded, no need to fetch again
        emit(state);
        return;
      }
      emit(const ProductLoading()); // Emit loading state
      try {
        List<Product> results =  await WooSignal.instance.getProducts();
        emit(ProductLoaded(results));
      } catch (e) {
        if (e is SocketException || e is TimeoutException) {
          emit(ProductError(e.toString())); // Emit ProductError on network error
        } else {
          emit(
              ProductError(e.toString())); // Or still emit ProductError as a general case
        }
      }
    });
    on<ProductExceptionError>((event, emit) async {
      showDialog(
        context: event.context,
        builder: (context) => AlertDialog(
          title: Text(event.title),
          content: Text(event.message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
    on<ResetQuantity>((event, emit) {
      if (state is ProductLoaded) {
        final loadedState = state as ProductLoaded;
        emit(ProductLoaded(
          loadedState.products, // Pass the products list here
          selectedProductId: null,
          currentProduct: null,
          quantity: 1, // Reset quantity to 1
        ));
      }
    });
    on<UpdateCartQuantity>((event, emit) {
      final CartBloc _cartBloc = locator<CartBloc>();
      if(_cartBloc.state is CartItemLoaded){
        final cartState = _cartBloc.state as CartItemLoaded;
        if (cartState.cartItems.any((item) => item.productId == event.productId)) {
          //_cartBloc.updateCartQuantity(event.productId, event.quantityChange);
          _cartBloc.add(UpdateCartItemQuantity(productId: event.productId, quantityChange: event.quantityChange));
        }
      }
    });
    on<UpdateProducts>((event, emit) {
      print(event.products);
      if (state is ProductLoaded) {
        final loadedState = state as ProductLoaded;
        emit(loadedState.copyWith(products: event.products));
      }
    });
    on<UpdateSelectedProduct>((event, emit) {
      if (state is ProductLoaded) {
        print('Updating Selected Product');
        final loadedState = state as ProductLoaded;
        final product = event.selectedProduct;
        emit(ProductLoaded(
          loadedState.products,
          selectedProductId: event.selectedProduct.id?.toString(),
          currentProduct: event.selectedProduct,
        ));
        if(event.selectedProduct.type == 'variable'){
          add(FetchProductVariations(event.selectedProduct.id.toString()));
        }
        print('Updated Selected Product');

      }
    });
    on<AddUpSellProducts>((event, emit) {
      final controller = ProductLoaderController();
      controller.loadProducts(
          hasResults: (result) {
            if (result == false) {
              return false;
            }
            return true;
          },
          didFinish: () { },
          productIds: event.productIds
      );
      final results = controller.getResults();
      if(state is ProductLoaded){
        final loadedState = state as ProductLoaded;
        emit(loadedState.copyWith(
            products: loadedState.products,
            selectedProductId: loadedState.selectedProductId,
            currentProduct: loadedState.currentProduct,
            upSells: results)
        );
      }
    });
  }

  /// Replace 'dynamic' with the actual type of your products
  List<dynamic> _applyFilters(List<dynamic> products, FilterCriteria criteria) {
    // Implement your filtering logic here based on the criteria
    // Example:
    return products.where((product) {
      if (criteria.category != null &&
          criteria.category != 'all' &&
          product.category != criteria.category) {
        return false;
      }
      if (criteria.minPrice != null && product.price < criteria.minPrice!) {
        return false;
      }
      if (criteria.maxPrice != null && product.price > criteria.maxPrice!) {
        return false;
      }
      return true;
    }).toList();
  }
}

class FilterCriteria {
  String? category;
  double? minPrice;
  double? maxPrice;
  // Add other filter criteria as needed

  FilterCriteria({this.category, this.minPrice, this.maxPrice});
}
