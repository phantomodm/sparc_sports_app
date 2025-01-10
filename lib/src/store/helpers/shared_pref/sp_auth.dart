//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/models/cart.dart';


Future<bool> authCheck() async => ((await getUser()) != null);

Future<String?> readAuthToken() async{
  final data = await getUser();
  final decodedData = jsonDecode(data! as String);
  return decodedData['token'];
}

Future<String?> readUserId() async {
  final data = await getUser();
  final decodedData = jsonDecode(data! as String);
  return decodedData['user_id'];
}

authLogout(BuildContext context) async {
  //await NyStorage.delete(SharedKey.authUser);
  Cart.getInstance.clear();
  navigatorPush(context, routeName: "/home", forgetAll: true);
}
