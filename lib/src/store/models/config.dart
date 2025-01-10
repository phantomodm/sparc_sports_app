// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env{
Future<void> loadEnv(path) async {
  await dotenv.load(fileName: path);
}

String get app_key{
  return dotenv.env['APP_KEY'] ?? 'APP_KEY';
}

bool get app_debug{
  return dotenv.env['APP_DEBUG']?.toLowerCase() == 'true' || false;
}
String get app_name{
  return dotenv.env['APP_NAME'] ?? 'Sparc';
}
String get product_placeholder_image{
  return dotenv.env['PRODUCT_PLACEHOLDER_IMAGE'] ?? 'https://via.placeholder.com/150';
}
bool get stripe_live{
  return dotenv.env['STRIPE_LIVE_MODE']?.toLowerCase() == 'true' || false;
}
String get stripe_account{
  return dotenv.env['STRIPE_ACCOUNT'] ?? 'STRIPE_ACCOUNT';
}
String get api_base_url{
  return dotenv.env['API_BASE_URL'] ?? 'API_BASE_URL';  
}
String get encrypt_key{
  return dotenv.env['ENCRYPT_KEY'] ?? 'NULL';
}
String get encrypt_secret{
  return dotenv.env['ENCRYPT_SECRET'] ?? 'NULL';
}
String get default_locale{
  return dotenv.env['DEFAULT_LOCALE'] ?? 'en';
}
}