
import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/store/widgets/woosignal_ui.dart';


class CheckoutStoreHeadingWidget extends StatelessWidget {
  const CheckoutStoreHeadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.only(top: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: const StoreLogo(height: 65),
      ),
    );
  }
}
