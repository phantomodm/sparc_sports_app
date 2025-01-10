
part of 'cart_bloc.dart';


abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddToCart extends CartEvent {

  final CartLineItem cartLineItem;
  final BuildContext context;
  const AddToCart(this.cartLineItem, this.context);

  @override
  List<Object> get props => [cartLineItem,context];
}

class LoadCart extends CartEvent {
  final CartLineItem cartLineItem;
  const LoadCart(this.cartLineItem);
  @override 
  List<Object> get props => [];
}

class ProceedToCheckout extends CartEvent {
  @override 
  List<Object> get props => [];
}

// In cart_event.dart
class UpdateCartItemQuantity extends CartEvent {
  final int productId;
  final int quantityChange;
  const UpdateCartItemQuantity({required this.productId, required this.quantityChange});

  @override
  List<Object> get props => [productId, quantityChange];
}

class ClearCart extends CartEvent {} 

class RemoveFromCart extends CartEvent {
  //final CartLineItem cartLineItem;
  final int index;
  const RemoveFromCart(this.index);

  @override
  List<Object> get props => [index];
}

class CartProductChange extends CartEvent {
  final CartLineItem cartLineItem;
  final int quantityChange;
  const CartProductChange({
    required this.cartLineItem,
    required this.quantityChange,
  });
  @override
  List<Object> get props => [cartLineItem, quantityChange];
}

