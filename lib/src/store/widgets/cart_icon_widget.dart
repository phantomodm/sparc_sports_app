//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
//import 'package:sparc_sports_app/src/store/widgets/cart_quantity_widget.dart';

class CartIconWidget extends StatefulWidget {
  const CartIconWidget({super.key});

  @override
  _CartIconWidgetState createState() => _CartIconWidgetState();
}

class _CartIconWidgetState extends State<CartIconWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: IconButton(
        icon: const Stack(
          children: <Widget>[
            Positioned.fill(
              bottom: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Icon(Icons.shopping_cart, size: 20),
              ),
            ),
            Positioned.fill(
              top: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Cart",
                    )
                //child: CartQuantity(),
              ),
            )
          ],
        ),
        onPressed: () => Navigator.pushNamed(context, "/cart")
            .then((value) => setState(() {})),
      ),
    );
  }
}
