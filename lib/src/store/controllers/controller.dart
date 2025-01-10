//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';

/// Base Controller for the Nylo
/// See more on controllers here - https://nylo.dev/docs/2.x/controllers

abstract class SparcController {
  BuildContext? context;
  dynamic controller;
  SparcController({this.context});
  @mustCallSuper
  construct(BuildContext context) async {
    this.context = context;
  }
}

class Controller extends SparcController {
  Controller();
}

