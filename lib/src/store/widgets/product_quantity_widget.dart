import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparc_sports_app/src/store/bloc/product_bloc.dart';

class ProductQuantity extends StatefulWidget {
  
  const ProductQuantity({super.key, required this.productId});

  final int productId;

  static String state = "product_quantity";

  @override
  _ProductQuantityState createState() => _ProductQuantityState();
}

class _ProductQuantityState extends State<ProductQuantity> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoaded) {
          final product = state.currentProduct;
          if (product != null) {
            return Text(
              state.quantity.toString(),
              style: Theme.of(context).textTheme.bodyLarge,
            );
          }
        }
        return const SizedBox.shrink();
      }
    );
  }
}
