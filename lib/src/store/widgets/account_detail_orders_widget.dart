//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/widgets/app_loader_widget.dart';
import 'package:sparc_sports_app/src/store/helpers/shared_pref/sp_auth.dart';
import 'package:sparc_sports_app/src/store/controllers/customer_orders_loader_controller.dart';
import 'package:sparc_sports_app/src/store/controllers/woosignal_api_loader_controller.dart';
import 'package:woosignal/models/response/order.dart';

class AccountDetailOrdersWidget extends StatefulWidget {
  @override
  _AccountDetailOrdersWidgetState createState() =>
      _AccountDetailOrdersWidgetState();
}

class _AccountDetailOrdersWidgetState extends State<AccountDetailOrdersWidget> {
  bool _isLoadingOrders = true, _shouldStopRequests = false;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final CustomerOrdersLoaderController _customerOrdersLoaderController =
      CustomerOrdersLoaderController();
  final appTranslations = locator<AppTranslations>();

  // List<dynamic> _results = [];
  int page = 1;
  // bool _waitForNextRequest = false;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> _loadOrders(
      {required bool Function(bool hasProducts) hasResults,
      required void Function() didFinish,
      required String userId}) async {
    await WooSignalApiLoaderController().load(
        hasResults: hasResults,
        didFinish: didFinish,
        apiQuery: (api) => api.getOrders(
            customer: int.parse(userId), page: page, perPage: 50));
  }

  @override
  Widget build(BuildContext context) {
    List<Order> orders = CustomerOrdersLoaderController().getResults();

    if (_isLoadingOrders == true) {
      return const AppLoaderWidget();
    }

    if (orders.isEmpty) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.shopping_cart,
              color: Colors.black54,
              size: 40,
            ),
            Text(
              appTranslations.trans(context, "No orders found"),
            ),
          ],
        ),
      );
    }

    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text(appTranslations.trans(context, "pull up load"));
          } else if (mode == LoadStatus.loading) {
            body = const CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text(appTranslations.trans(context, "Load Failed! Click retry!"));
          } else if (mode == LoadStatus.canLoading) {
            body = Text(appTranslations.trans(context, "release to load more"));
          } else {
            body = Text(appTranslations.trans(context, "No more orders"));
          }
          return SizedBox(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.builder(
        itemBuilder: (context, i) {
          Order order = orders[i];
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.only(
                top: 5,
                bottom: 5,
                left: 8,
                right: 6,
              ),
              title: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFFFCFCFC),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "#${order.id.toString()}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      order.status!.capitalize(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          formatStringCurrency(total: order.total),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "${order.lineItems!.length} ${appTranslations.trans(context, "items")}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    Text(
                      "${dateFormatted(
                            date: order.dateCreated!,
                            formatType: formatForDateTime(FormatType.date),
                          )}\n${dateFormatted(
                            date: order.dateCreated!,
                            formatType: formatForDateTime(FormatType.time),
                          )}",
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ],
                ),
              ),
              trailing: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.chevron_right),
                ],
              ),
              onTap: () => _viewOrderDetail(i, order.id),
            ),
          );
        },
        itemCount: orders.length,
      ),
    );
  }

  void _onRefresh() async {
    _customerOrdersLoaderController.clear();
    await fetchOrders();

    setState(() {
      _shouldStopRequests = false;
      _refreshController.refreshCompleted(resetFooterState: true);
    });
  }

  void _onLoading() async {
    await fetchOrders();

    if (mounted) {
      setState(() {});
      if (_shouldStopRequests) {
        _refreshController.loadNoData();
      } else {
        _refreshController.loadComplete();
      }
    }
  }

  fetchOrders() async {
    String? userId = await readUserId();
    if (userId == null) {
      setState(() {
        _isLoadingOrders = false;
      });
      return;
    }
    await _loadOrders(
        hasResults: (result) {
          if (result == false) {
            setState(() {
              _isLoadingOrders = false;
              _shouldStopRequests = true;
            });
            return false;
          }
          return true;
        },
        didFinish: () => setState(() {
              _isLoadingOrders = false;
            }),
        userId: userId);
  }

  _viewOrderDetail(int i, int? orderId) => Navigator.pushNamed(
        context,
        "/account-order-detail",
        arguments: orderId,
      );
}
