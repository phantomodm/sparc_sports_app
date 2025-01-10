import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/classes/sparc_classes.dart';
import 'package:sparc_sports_app/src/store/helpers/shared_pref/shared_key.dart';
import 'package:sparc_sports_app/src/store/models/cart_models.dart';
import 'dart:convert';

part 'cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {

  CartBloc() : super(CartItemLoaded(cartItems: [])) {
    on<AddToCart>(_onAddToCart);
    on<CartProductChange>(_cartProductChange);
    on<UpdateCartItemQuantity>(_updateCartItemQuantity);
    on<ClearCart>(_clearCart);
    on<LoadCart>(_onLoadCart);
    on<RemoveFromCart>(_removeFromCart);
  }

  int _calculateItemCount(List<CartLineItem> cartItems) {
    int count = 0;
    for (var item in cartItems) {
      count += item.quantity;
    }
    return count;
  }

  double _calculateTotalPrice(List<CartLineItem> cartItems) {
    double total = 0;
    for (var item in cartItems) {
      //total += double.parse(item.total!); // Assuming item.total is a String
      if (item.total != null) { // Add null check
        total += double.parse(item.total!);
      }
    }
    return total;
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit ) async{
    // Check if the current state is CartItemLoaded
    if (state is CartItemLoaded) {
      try {
        final loadedState = state as CartItemLoaded; // Now this cast is safe
        print(loadedState.cartItems);
        final List<CartLineItem> updatedCartItems = List.from(loadedState.cartItems)
          ..add(event.cartLineItem);
        emit(
          CartItemLoaded(
            cartItems: updatedCartItems,
            itemCount: _calculateItemCount(updatedCartItems),
            totalPrice: _calculateTotalPrice(updatedCartItems),
          ),
        );
      } on TypeError catch (e) {
        emit(CartError(error: 'Failed to add to cart: $e'));
      } catch (e) {
        emit(CartError(error: 'Failed to add to cart: $e')); // No need for casting here
      }
    } else {
      // Handle cases where the state is not CartItemLoaded
      // For example, you might emit CartError or log an error
      emit(const CartError(error: 'Cart not loaded'));
    }
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit ) async {
    emit(CartLoading());
    try {
      final List<dynamic> cartItems =
      SparcStorage().read(SharedKey.cart) as List;
      if (isNotNullOrEmpty(cartItems)) {
        final cartLineItems = cartItems
            .map((item) => CartLineItem.fromJson(json.decode(item as String)))
            .toList();
        emit(CartItemLoaded(
          cartItems: cartLineItems,
          itemCount: _calculateItemCount(cartLineItems),
          totalPrice: _calculateTotalPrice(cartLineItems),
        ));
      } else {
        emit(CartEmpty());
      }
    } catch (e) {
      emit(CartError(error:'Failed to load cart: $e') as CartState);
    }

  }

  Future<void> _cartProductChange(CartProductChange event, Emitter<CartState> emit ) async {
    emit(CartLoading());
    try {
      if (state is CartItemLoaded) {
        final state = this.state as CartItemLoaded;
        final itemIndex = state.cartItems.indexOf(event.cartLineItem);
        final updatedCartItems = List<CartLineItem>.from(state.cartItems)
          ..[itemIndex] = event.cartLineItem.copyWith(
            quantity: event.cartLineItem.quantity + event.quantityChange,
          );
        emit(
          CartItemLoaded(
            cartItems: updatedCartItems,
            itemCount: _calculateItemCount(updatedCartItems),
            totalPrice: _calculateTotalPrice(updatedCartItems),
          ),
        );
      }
    } catch (e) {
      emit(CartError(error: 'Failed to update item quantity: $e') as CartState);
    }
  }

  Future<void> _clearCart(ClearCart event, Emitter<CartState> emit ) async {
    emit(CartLoading());
    try {
      if (state is CartItemLoaded) {
        final loadedState = state as CartItemLoaded;
        // Emit new state with empty cartItems and updated counts
        emit(loadedState.copyWith(
          cartItems: [],
          calculateItemCount: _calculateItemCount, // Pass the function
          calculateTotalPrice: _calculateTotalPrice, // Pass the function
        ));
      }
      await SparcStorage().delete(SharedKey.cart);
      emit(CartEmpty());
    } catch (e) {
      emit(CartError(error: 'Failed to clear cart: $e') as CartState);
    }
  }

  Future<void> _removeFromCart(RemoveFromCart event, Emitter<CartState> emit ) async {
    try {
      if (state is CartItemLoaded) {
        final state = this.state as CartItemLoaded;
        final updatedCartItems = List.from(state.cartItems)
          ..removeAt(event.index); // Remove item at index
        emit(
          CartItemLoaded(
            cartItems: updatedCartItems.cast<CartLineItem>(),
            itemCount:
            _calculateItemCount(updatedCartItems.cast<CartLineItem>()),
            totalPrice:
            _calculateTotalPrice(updatedCartItems.cast<CartLineItem>()),
          ),
        );
      }
    } catch (e) {
      emit(CartError(error: 'Failed to remove item from cart: $e') as CartState);
    }
  }

  Future<void> _updateCartItemQuantity(UpdateCartItemQuantity event, Emitter<CartState> emit ) async {
    if (state is CartItemLoaded) {
      final loadedState = state as CartItemLoaded;

      // Find the index of the item with the matching productId
      final itemIndex = loadedState.cartItems.indexWhere((item) => item.productId == event.productId);

      if (itemIndex != -1) { // Check if the item exists in the cart
        final updatedItem = loadedState.cartItems[itemIndex].copyWith(
          quantity: loadedState.cartItems[itemIndex].quantity + event.quantityChange,
        );

        // Create a new list with the updated item
        final updatedCartItems = List<CartLineItem>.from(loadedState.cartItems)
          ..[itemIndex] = updatedItem;

        emit(CartItemLoaded(
          cartItems: updatedCartItems,
          itemCount: _calculateItemCount(updatedCartItems),
          totalPrice: _calculateTotalPrice(updatedCartItems),
        ));
      }
    }
  }

}
