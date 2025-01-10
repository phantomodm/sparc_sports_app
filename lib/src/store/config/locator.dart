import 'dart:io';
import 'dart:ui';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:sparc_sports_app/src/store/networking/api_client.dart';
import 'package:sparc_sports_app/src/store/classes/sparc_classes.dart';
import 'package:sparc_sports_app/src/store/networking/socket_service.dart';
import 'package:sparc_sports_app/src/store/services/product_service.dart';

import '../bloc/state_management.dart';


final productBloc = ProductBloc(
  productService: ProductService(
    socketService: SocketService(),
    apiClient: ApiClient(),
  ),
);
final cartBloc = CartBloc();
final checkoutBloc = CheckoutBloc();
final dataStoreBloc = DatastoreBloc();
final locator = GetIt.I;

void setupLocator() async {
  final dataStoreBloc = DatastoreBloc();
  final appTranslations = AppTranslations();

  await appTranslations.load(Locale(Platform.localeName.split('_')[0]));
  locator.registerSingleton<FlutterSecureStorage>(FlutterSecureStorage());
  locator.registerSingleton<DatastoreBloc>(dataStoreBloc);
  locator.registerSingleton<AppTranslations>(appTranslations);
  locator.registerSingleton<SparcStorage>(SparcStorage());
  locator.registerSingleton<ApiClient>(ApiClient());
  locator.registerSingleton<SocketService>(SocketService());
  locator.registerSingleton<ProductService>(ProductService(
    socketService: locator<SocketService>(),
    apiClient: locator<ApiClient>(),
  ));

  locator.registerSingleton<ProductBloc>(productBloc);
  locator.registerSingleton<CartBloc>(cartBloc);
  locator.registerSingleton<CheckoutBloc>(checkoutBloc);
}