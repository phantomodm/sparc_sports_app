// File: product_event.dart
part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {}

class ApplyFilters extends ProductEvent {
  final FilterCriteria filterCriteria;
  const ApplyFilters(this.filterCriteria);

  @override
  List<Object> get props => [filterCriteria];
}

class AddUpSellProducts extends ProductEvent {
  final dynamic productIds;
  const AddUpSellProducts(this.productIds);
  @override
  List<Object> get props => [productIds];
}

class SelectProduct extends ProductEvent {
  final String productId;
  const SelectProduct(this.productId);

  @override
  List<Object> get props => [productId];
}

class FetchProductVariations extends ProductEvent {
  final String productId; // Change the type to String
  const FetchProductVariations(this.productId);

  @override
  List<Object> get props => [productId];
}

class LoadCategories extends ProductEvent {
  final List<ProductCategory> categories;
  const LoadCategories(this.categories);
  @override
  List<Object> get props => [categories];
}

class UpdateSelectedProduct extends ProductEvent {
  final Product selectedProduct;
  const UpdateSelectedProduct(this.selectedProduct);
  @override
  List<Object> get props => [selectedProduct];
}

class DecrementQuantity extends ProductEvent {}

class IncrementQuantity extends ProductEvent {}

class ResetQuantity extends ProductEvent {}

class ProductExceptionError extends ProductEvent {

  final String message;
  final String title;
  final BuildContext context;
  final IconData? icon;
  final ToastNotificationStyleType style;

  const ProductExceptionError({
    required this.context,
    required this.title,
    required this.message,
    required this.style,
    this.icon
  });

  @override
  List<Object> get props => [context, title, message, style, icon ?? Object()];
}

// Define a separate event for updating the cart
class UpdateCartQuantity extends ProductEvent {
  final int productId;
  final int quantityChange;
  const UpdateCartQuantity({required this.productId, required this.quantityChange});
}

class UpdateProducts extends ProductEvent {
  final List<Product> products;
  const UpdateProducts(this.products);

  @override
  List<Object> get props => [products];
}
