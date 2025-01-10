import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:woosignal/woosignal.dart';

class ApiClient {
  final _wooSignal = WooSignal.instance;

  Future<void> initWooSignal() async {
    await _wooSignal.init(
      appKey: dotenv.env['WOOSIGNAL_APP_KEY'],

    );
  }
}