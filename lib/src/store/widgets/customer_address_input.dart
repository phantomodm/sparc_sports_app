import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/widgets/store_widgets.dart';

import '../models/cart_models.dart';

class CustomerAddressInput extends StatelessWidget {
  CustomerAddressInput(
      {Key? key,
        required this.txtControllerFirstName,
        required this.txtControllerLastName,
        required this.txtControllerAddressLine,
        required this.txtControllerCity,
        required this.txtControllerPostalCode,
        this.txtControllerEmailAddress,
        this.txtControllerPhoneNumber,
        required this.customerCountry,
        required this.onTapCountry})
      : super(key: key);

  final TextEditingController? txtControllerFirstName,
      txtControllerLastName,
      txtControllerAddressLine,
      txtControllerCity,
      txtControllerPostalCode,
      txtControllerEmailAddress,
      txtControllerPhoneNumber;

  final CustomerCountry? customerCountry;
  final Function() onTapCountry;
  final appTranslations = locator<AppTranslations>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Row(
          children: <Widget>[
            Flexible(
              child: TextEditingRow(
                heading: appTranslations.trans(context,"First Name"),
                controller: txtControllerFirstName,
                shouldAutoFocus: true,
              ),
            ),
            Flexible(
              child: TextEditingRow(
                heading: appTranslations.trans(context,"Last Name"),
                controller: txtControllerLastName,
              ),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
        Row(
          children: <Widget>[
            Flexible(
              child: TextEditingRow(
                heading: appTranslations.trans(context,"Address Line"),
                controller: txtControllerAddressLine,
              ),
            ),
            Flexible(
              child: TextEditingRow(
                heading: appTranslations.trans(context,"City"),
                controller: txtControllerCity,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Flexible(
              child: TextEditingRow(
                heading: appTranslations.trans(context,"Postal code"),
                controller: txtControllerPostalCode,
              ),
            ),
            if (txtControllerEmailAddress != null)
              Flexible(
                child: TextEditingRow(
                    heading: appTranslations.trans(context,"Email address"),
                    keyboardType: TextInputType.emailAddress,
                    controller: txtControllerEmailAddress),
              ),
          ],
        ),
        if (txtControllerPhoneNumber != null)
          Row(
            children: <Widget>[
              Flexible(
                child: TextEditingRow(
                  heading: appTranslations.trans(context,"Phone Number"),
                  controller: txtControllerPhoneNumber,
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: <Widget>[
              if (customerCountry?.hasState() ?? false)
                Flexible(
                  child: Column(
                    children: [
                      Container(
                        height: 23,
                        child: Text(
                          appTranslations.trans(context,"State"),
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.left,
                        ),
                        width: double.infinity,
                      ),
                      Padding(
                        child: SecondaryButton(
                          title: (customerCountry!.state != null
                              ? (customerCountry?.state?.name ?? "")
                              : appTranslations.trans(context,"Select state")),
                          action: onTapCountry,
                        ),
                        padding: EdgeInsets.all(8),
                      ),
                    ],
                  ),
                ),
              Flexible(
                child: Column(
                  children: [
                    Container(
                      height: 23,
                      child: Text(
                        appTranslations.trans(context,"Country"),
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.left,
                      ),
                      width: double.infinity,
                    ),
                    Padding(
                      child: SecondaryButton(
                        title: (customerCountry != null &&
                            (customerCountry?.name ?? "").isNotEmpty
                            ? customerCountry!.name
                            : appTranslations.trans(context,"Select country")),
                        action: onTapCountry,
                      ),
                      padding: EdgeInsets.all(8),
                    ),
                  ],
                ),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ),
      ],
    );
  }
}
