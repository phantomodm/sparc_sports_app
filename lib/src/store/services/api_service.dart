import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/store/classes/sparc_classes.dart';
import 'package:sparc_sports_app/src/store/enum/toasts_enums.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/networking/dio_service.dart';
import 'package:sparc_sports_app/src/store/networking/pretty_dio.dart';
import 'package:sparc_sports_app/src/store/utils/toasts/toasts.dart';

class ApiService extends NyApiService {
  ApiService({BuildContext? buildContext}) : super(buildContext);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  @override
  final interceptors = {LoggingInterceptor: LoggingInterceptor()};

  Future<dynamic> fetchTestData() async {
    return await network(
      request: (request) => request.get("/endpoint-path"),
    );
  }

  /// API helper
  Future<dynamic> sparcApi<T>(
      {required dynamic Function(T) request,
      Map<Type, dynamic> apiDecoders = const {},
      BuildContext? context,
      Map<String, dynamic> headers = const {},
      String? bearerToken,
      String? baseUrl,
      int? page,
      int? perPage,
      String queryParamPage = "page",
      String? queryParamPerPage,
      List<Type> events = const []}) async {
    assert(apiDecoders.containsKey(T),
        'Your config/decoders.dart is missing this class ${T.toString()} in apiDecoders.');

    dynamic apiService = apiDecoders[T];

    if (context != null) {
      apiService.setContext(context);
    }

    // add headers
    if (headers.isNotEmpty) {
      apiService.setHeaders(headers);
    }

    // add bearer token
    if (bearerToken != null) {
      apiService.setBearerToken(bearerToken);
    }

    // add baseUrl
    if (baseUrl != null) {
      apiService.setBaseUrl(baseUrl);
    }

    /// [queryParamPage] by default is 'page'
    /// [queryParamPerPage] by default is 'per_page'
    if (page != null) {
      apiService.setPagination(page,
          paramPage: queryParamPage,
          paramPerPage: queryParamPerPage,
          perPage: perPage);
    }

    dynamic result = await request(apiService);
    // if (events.isNotEmpty) {
    //   Nylo nylo = Datastore.instance.nylo();
    //   for (var event in events) {
    //     NyEvent? nyEvent = nylo.getEvent(event);
    //     if (nyEvent == null) {
    //       continue;
    //     }
    //     Map<dynamic, NyListener> listeners = nyEvent.listeners;

    //     if (listeners.isEmpty) {
    //       return;
    //     }
    //     for (NyListener listener in listeners.values.toList()) {
    //       listener.setEvent(nyEvent);

    //       dynamic eventResult = await listener.handle({'data': result});
    //       if (eventResult != null && eventResult == false) {
    //         break;
    //       }
    //     }
    //   }
    // }
    return result;
  }
}

class NyApiService extends DioApiService {
  NyApiService(super.context, {this.decoders = const {}});

  /// Map decoders to modelDecoders
  @override
  final Map<Type, dynamic> decoders;

  /// Default interceptors
  @override
  final interceptors = {
    if (getEnv('APP_DEBUG', defaultValue: false) == true)
      PrettyDioLogger: PrettyDioLogger()
  };

  /// Make a GET request
  Future<T?> get<T>(
    String url, {
    Object? data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (T.toString() == 'dynamic') {
      return await network(
        request: (request) => request.getUri(Uri.parse(url),
            data: data,
            options: options,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress),
      );
    }
    return await network<T>(
      request: (request) => request.getUri(Uri.parse(url),
          data: data,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress),
    );
  }

  /// Make a POST request
  Future<T?> post<T>(
    String url, {
    Object? data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (T.toString() == 'dynamic') {
      return await network(
        request: (request) => request.postUri(Uri.parse(url),
            data: data,
            options: options,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress),
      );
    }
    return await network<T>(
      request: (request) => request.postUri(Uri.parse(url),
          data: data,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress),
    );
  }

  /// Make a PUT request
  Future<T?> put<T>(
    String url, {
    Object? data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (T.toString() == 'dynamic') {
      return await network(
        request: (request) => request.postUri(Uri.parse(url),
            data: data,
            options: options,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress),
      );
    }
    return await network<T>(
      request: (request) => request.putUri(Uri.parse(url),
          data: data,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress),
    );
  }

  /// Make a DELETE request
  Future<T?> delete<T>(String url, Object? data, Options? options,
      CancelToken? cancelToken) async {
    if (T.toString() == 'dynamic') {
      return await network(
        request: (request) => request.deleteUri(Uri.parse(url),
            data: data, options: options, cancelToken: cancelToken),
      );
    }
    return await network<T>(
      request: (request) => request.deleteUri(Uri.parse(url),
          data: data, options: options, cancelToken: cancelToken),
    );
  }

  @override
  displayError(DioException dioException, BuildContext context) {
    SparcLogger().error(dioException.message ?? "");
    ToastHelper().showToastNotification(context,
        title: "Oops!",
        description: "Something went wrong",
        style: ToastNotificationStyleType.WARNING);
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    print('DATA: ${response.requestOptions.path}');
    //log(response.data.toString());
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    handler.next(err);
  }
}
