import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparc_sports_app/src/store/pages/product_details_screen.dart';
import 'package:sparc_sports_app/src/store/widgets/promotional_banner.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

//import '../../data/models/product.dart';
import '../bloc/product_bloc.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  Map<int, Map<String, String>> _selectedAttributes = {};

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProducts());
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: const Text('Categories'),
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: PromotionalBanner(), // Add the banner here
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchBar(
                onChanged: (text) {
                  // TODO: Handle search query (e.g., filter products)
                  print('Search query: $text');
                },
                hintText: 'products',
              ),
            ),
            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductLoaded) {
                    if (state.products!.isEmpty) {
                      // Check if the product list is empty
                      return const Center(
                        child: Text('No products found.'),
                      );
                    } else {
                      return ScrollablePositionedList.builder(
                        itemScrollController: itemScrollController,
                        itemPositionsListener: itemPositionsListener,
                        itemCount: state.products!.length,
                        itemBuilder: (context, index) {
                          /// Replace 'dynamic' with the actual type of your products
                          final dynamic product = state.products?[index];

                          return GestureDetector(
                            onTap: () {
                              context.read<ProductBloc>().add(SelectProduct(product.id));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsScreen(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(12),),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 140,
                                    width: double.infinity,
                                    child: Image.network(
                                      product.images.first.src,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    '\${product.price}',
                                    style: TextStyle(
                                      color: Color(0xFFBB0021),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  } else if (state is ProductError) {
                    return const Center(child: Text('Error loading products'));
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
    );
  }

}
