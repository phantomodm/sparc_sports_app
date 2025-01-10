// product_state.dart
part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState({this.isLoading = false});

  final bool isLoading;

  @override
  List<Object> get props => [];
}

class ProductLoading extends ProductState {
  const ProductLoading() : super(isLoading: true);
}

class ProductLoaded extends ProductState {
  final List<Product>? products;
  final List<ProductVariation> variations;
  final String? selectedProductId;
  final Product? currentProduct;
  final List<ProductCategory> categories;
  final List<Product> upSells;
  final int quantity;

  const ProductLoaded(
    this.products, {
    this.selectedProductId,
    this.currentProduct,
    this.categories = const [],
    this.quantity = 1,
    this.variations = const [],
    this.upSells = const [],
  }) : super(isLoading: false);

  @override
  List<Object> get props => [
        products ?? [],
        categories,
        selectedProductId ?? '',
        currentProduct ?? '',
        quantity,
        variations,
        upSells,
      ];

  ProductLoaded copyWith({
    List<Product>? products,
    String? selectedProductId,
    Product? currentProduct,
    List<ProductCategory>? categories,
    int? quantity,
    List<ProductVariation>? variations,
    List<Product>? upSells,
  }) {
    return ProductLoaded(
      products ?? this.products,
      categories: categories ?? this.categories,
      selectedProductId: selectedProductId ?? this.selectedProductId,
      currentProduct: currentProduct ?? this.currentProduct,
      quantity: quantity ?? this.quantity,
      variations: variations ?? this.variations,
      upSells: upSells ?? this.upSells,
    );
  }
}

class ProductError extends ProductState {
  final String error;

  const ProductError(this.error) : super();

  @override
  List<Object> get props => [error];
}
