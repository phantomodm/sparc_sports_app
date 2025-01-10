import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/networking/api_client.dart';
import 'package:sparc_sports_app/src/store/networking/socket_service.dart';
import 'package:woosignal/models/response/product_variation.dart'
    as ws_product_variation;

class ProductService {
  final SocketService socketService;
  final ApiClient apiClient;

  ProductService({required this.socketService, required this.apiClient});

  // Future<List<ProductVariation>> getProductVariations(String productId) async {
  //   List<ProductVariation> tmpVariations = [];
  //   int currentPage = 1;
  //   bool isFetching = true;

  //   while (isFetching) {
  //     final tmp = await wooSignal.getProductVariations(
  //       productId,
  //       perPage: 100,
  //       page: currentPage,
  //     );
  //     if (tmp.isNotEmpty) {
  //       tmpVariations.addAll(tmp);
  //     }

  //     if (tmp.length >= 100) {
  //       currentPage += 1;
  //     } else {
  //       isFetching = false;
  //     }
  //   }
  //   return tmpVariations;
  // }

  ws_product_variation.ProductVariation? findProductVariation(
      {required Map<int, dynamic> tmpAttributeObj,
      required List<ws_product_variation.ProductVariation> productVariations}) {
    ws_product_variation.ProductVariation? tmpProductVariation;

    Map<String?, dynamic> tmpSelectedObj = {};
    for (var attributeObj in tmpAttributeObj.values) {
      tmpSelectedObj[attributeObj["name"]] = attributeObj["value"];
    }

    for (var productVariation in productVariations) {
      Map<String?, dynamic> tmpVariations = {};

      for (var attr in productVariation.attributes) {
        tmpVariations[attr.name] = attr.option;
      }

      if (tmpVariations.toString() == tmpSelectedObj.toString()) {
        tmpProductVariation = productVariation;
      }
    }

    return tmpProductVariation;
  }

  Future<List<ws_product_variation.ProductVariation>> fetchProductVariations(
    String productId,
  ) async {
    List<ws_product_variation.ProductVariation> tmpVariations = [];
    int currentPage = 1;
    // Check if productId is not null
    bool isFetching = true;
    while (isFetching) {
      List<ws_product_variation.ProductVariation> tmp = await (appWooSignal(
        (api) => api.getProductVariations(int.parse(productId),
            perPage: 100, page: currentPage),
      ));
      if (tmp.isNotEmpty) {
        tmpVariations.addAll(tmp);
      }

      if (tmp.length >= 100) {
        currentPage += 1;
      } else {
        isFetching = false;
      }
    }
    return tmpVariations;
  }

// _fetchProductVariations() async {
//   List<ws_product_variation.ProductVariation> tmpVariations = [];
//   int currentPage = 1;

//   bool isFetching = true;
//   while (isFetching) {
//     List<ws_product_variation.ProductVariation> tmp = await (appWooSignal(
//       (api) => api.getProductVariations(_product.id!,
//           perPage: 100, page: currentPage),
//     ));
//     if (tmp.isNotEmpty) {
//       tmpVariations.addAll(tmp);
//     }

//     if (tmp.length >= 100) {
//       currentPage += 1;
//     } else {
//       isFetching = false;
//     }
//   }
//   _productVariations = tmpVariations;
// }
}
