import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/store/classes/app_config.dart';
import 'package:sparc_sports_app/src/store/enum/toasts_enums.dart';
import 'package:sparc_sports_app/src/store/utils/validation/rules.dart';

class SparcValidators {
  static check(
      {required Map<String, String> rules,
      required Map<String, dynamic> data,
      Map<String, dynamic> messages = const {},
      bool showAlert = true,
      Duration? alertDuration,
      ToastNotificationStyleType alertStyle =
          ToastNotificationStyleType.WARNING,
      BuildContext? context}) {
    Map<String, Map<String, dynamic>> map = data.map((key, value) {
      if (!rules.containsKey(key)) {
        throw Exception('Missing rule: $key');
      }
      Map<String, dynamic> tmp = {"data": value, "rule": rules[key]};
      if (messages.containsKey(key)) {
        tmp.addAll({"message": messages[key]});
      }
      return MapEntry(key, tmp);
    });

    //Datastore.instance.nylo();

    Map<String, dynamic> allValidationRules = {};
    allValidationRules.addAll(AppHelper.instance.getValidationRules());
    allValidationRules.addAll(nyDefaultValidations);

    for (int i = 0; i < map.length; i++) {
      String attribute = map.keys.toList()[i];
      Map<String, dynamic> info = map[attribute]!;

      dynamic data = info['data'];

      String rule = info['rule'];
      List<String> rules = rule.split("|").toList();

      if (rule.contains("nullable") && (data == null || data == "")) {
        continue;
      }

      for (rule in rules) {
        String ruleQuery = rule;
        if (ruleQuery.contains(":")) {
          String firstSection = ruleQuery.split(":").first;
          ruleQuery = firstSection;
        }

        MapEntry<String, dynamic>? validationRuleMapEntry =
            allValidationRules.entries.firstWhereOrNull(
                (nyDefaultValidation) => nyDefaultValidation.key == ruleQuery);
        if (validationRuleMapEntry == null) continue;

        ValidationRule? validationRule =
            validationRuleMapEntry.value(attribute);
        if (validationRule == null) continue;

        bool didNotFail = validationRule.handle(info);

        if (didNotFail == true) continue;

        if (showAlert == true && context != null) {
          validationRule.alert(
            context,
            style: alertStyle,
            duration: alertDuration,
          );
        }
        throw ValidationException(attribute, validationRule);
      }
    }
  }
}

/// Default implementation of [ValidationException] which carries a [attribute] and [validationRule].
class ValidationException implements Exception {
  /// Creates a new `ValidationException` using a [attribute] and [validationRule].
  ValidationException(this.attribute, this.validationRule);

  /// Attribute that the validation failed on.
  final String attribute;

  /// ValidationRule that the [attribute] failed on.
  final ValidationRule validationRule;

  /// Returns a description of the exception.
  @override
  String toString() =>
      'ValidationException: The "$attribute" attribute has failed validation on "${validationRule.signature}"';

  /// TextField error message.
  String toTextFieldMessage() =>
      (validationRule.textFieldMessage ?? validationRule.description);
}


final Map<String, dynamic> nyDefaultValidations = {
  "email": (attribute) => EmailRule(attribute),
  "boolean": (attribute) => BooleanRule(attribute),
  "contains": (attribute) => ContainsRule(attribute),
  "url": (attribute) => URLRule(attribute),
  "string": (attribute) => StringRule(attribute),
  "max": (attribute) => MaxRule(attribute),
  "min": (attribute) => MinRule(attribute),
  "not_empty": (attribute) => NotEmptyRule(attribute),
  "capitalized": (attribute) => CapitalizedRule(attribute),
  "lowercase": (attribute) => LowerCaseRule(attribute),
  "uppercase": (attribute) => UpperCaseRule(attribute),
  "regex": (attribute) => RegexRule(attribute),
  "date": (attribute) => DateRule(attribute),
  "numeric": (attribute) => NumericRule(attribute),
  "phone_number_us": (attribute) => PhoneNumberUsaRule(attribute),
  "phone_number_uk": (attribute) => PhoneNumberUkRule(attribute),
  "zipcode_us": (attribute) => ZipCodeUsRule(attribute),
  "postcode_uk": (attribute) => PostCodeUkRule(attribute),
};

