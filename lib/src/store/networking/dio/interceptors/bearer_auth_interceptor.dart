

import 'package:dio/dio.dart';
import 'package:sparc_sports_app/src/store/classes/sparc_classes.dart';

class BearerAuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String? userToken = SparcStorage().getString('user_token');
    if (userToken != null) {
      options.headers.addAll({"Authorization": "Bearer $userToken"});
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
