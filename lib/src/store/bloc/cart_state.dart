
part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartUpdating extends CartState{
  const CartUpdating();
}
class CartItemLoaded extends CartState {
  final List<CartLineItem> cartItems;
  final int itemCount; // Add itemCount
  final double totalPrice; // Add totalPrice
  final String? couponCode;
  
  const CartItemLoaded({
    this.cartItems = const <CartLineItem>[],
    this.itemCount = 0, // Initialize itemCount
    this.totalPrice = 0.0, // Initialize totalPrice
    this.couponCode,
  });

  @override
  List<Object> get props => [cartItems, itemCount, totalPrice];
  
  // copyWith method moved inside CartLoaded
  CartItemLoaded copyWith({
    List<CartLineItem>? cartItems,
    int Function(List<CartLineItem>)? calculateItemCount, // Add function type as parameter
    double Function(List<CartLineItem>)? calculateTotalPrice, // Add function type as parameter
    String? couponCode
  }) {
    return CartItemLoaded(
      cartItems: cartItems ?? this.cartItems,
      itemCount: calculateItemCount != null ? calculateItemCount(cartItems ?? this.cartItems) : itemCount,
      totalPrice: calculateTotalPrice != null ? calculateTotalPrice(cartItems ?? this.cartItems) : totalPrice,
      couponCode: couponCode ?? this.couponCode
    );
  }

}
class CartEmpty extends CartState {}
class CartError extends CartState {
  final String error;
  const CartError({
    required this.error,
  });
  @override
  List<Object> get props => [error];
}


