// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
// import 'package:sparc_sports_app/src/store/utils/toasts/toast_notification.dart';


extension SparcText on Text {
  /// Sets the color from your [ColorStyles] or [Color].
  Text setColor(
      BuildContext context, Color Function(dynamic color) newColor,
      {String? themeId}) {
    return copyWith(
        style: TextStyle(
            color: Theme.of(context).iconTheme.color));
  }

  /// Helper to apply changes.
  Text copyWith(
      {Key? key,
      StrutStyle? strutStyle,
      TextAlign? textAlign,
      TextDirection? textDirection = TextDirection.ltr,
      Locale? locale,
      bool? softWrap,
      TextOverflow? overflow,
      TextScaler? textScaler,
      int? maxLines,
      String? semanticsLabel,
      TextWidthBasis? textWidthBasis,
      TextStyle? style}) {
    return Text(this.data ?? "",
        key: key ?? this.key,
        strutStyle: strutStyle ?? this.strutStyle,
        textAlign: textAlign ?? this.textAlign,
        textDirection: textDirection ?? this.textDirection,
        locale: locale ?? this.locale,
        softWrap: softWrap ?? this.softWrap,
        overflow: overflow ?? this.overflow,
        textScaler: textScaler ?? this.textScaler,
        maxLines: maxLines ?? this.maxLines,
        semanticsLabel: semanticsLabel ?? this.semanticsLabel,
        textWidthBasis: textWidthBasis ?? this.textWidthBasis,
        style: style != null ? this.style?.merge(style) ?? style : this.style);
  }

  /// Set the Style to use [displayLarge].
  Text displayLarge(BuildContext context) {
    if (style == null) {
      return copyWith(style: Theme.of(context).textTheme.displayLarge);
    }
    return this.setStyle(Theme.of(context).textTheme.displayLarge);
  }

  /// Set the Style to use [displayMedium].
  Text displayMedium(BuildContext context) {
    if (style == null) {
      return copyWith(style: Theme.of(context).textTheme.displayMedium);
    }
    return this.setStyle(Theme.of(context).textTheme.displayMedium);
  }

  /// Set the Style to use [displaySmall].
  Text displaySmall(BuildContext context) {
    if (style == null) {
      return copyWith(style: Theme.of(context).textTheme.displaySmall);
    }
    return this.setStyle(Theme.of(context).textTheme.displaySmall);
  }

  /// Set the Style to use [headlineLarge].
  Text headingLarge(BuildContext context) {
    if (style == null) {
      return copyWith(style: Theme.of(context).textTheme.headlineLarge);
    }
    return this.setStyle(Theme.of(context).textTheme.headlineLarge);
  }

  /// Set the Style to use [headlineMedium].
  Text headingMedium(BuildContext context) {
    if (style == null) {
      return copyWith(style: Theme.of(context).textTheme.headlineMedium);
    }
    return this.setStyle(Theme.of(context).textTheme.headlineMedium);
  }

  /// Set the Style to use [headlineSmall].
  Text headingSmall(BuildContext context) {
    if (style == null) {
      return copyWith(style: Theme.of(context).textTheme.headlineSmall);
    }
    return this.setStyle(Theme.of(context).textTheme.headlineSmall);
  }

  /// Set the Style to use [titleLarge].
  Text titleLarge(BuildContext context) {
    if (style == null) {
      return copyWith(style: Theme.of(context).textTheme.titleLarge);
    }
    return this.setStyle(Theme.of(context).textTheme.titleLarge);
  }

  /// Set the Style to use [titleMedium].
  Text titleMedium(BuildContext context) {
    if (style == null) {
      return copyWith(style: Theme.of(context).textTheme.titleMedium);
    }
    return this.setStyle(Theme.of(context).textTheme.titleMedium);
  }

  /// Set the Style to use [titleSmall].
  Text titleSmall(BuildContext context) {
    if (style == null) {
      return copyWith(style: Theme.of(context).textTheme.titleSmall);
    }
    return this.setStyle(Theme.of(context).textTheme.titleSmall);
  }

  /// Set the Style to use [bodyLarge].
  Text bodyLarge(BuildContext context) {
    if (style == null) {
      return copyWith(style: Theme.of(context).textTheme.bodyLarge);
    }
    return this.setStyle(Theme.of(context).textTheme.bodyLarge);
  }

  /// Set the Style to use [bodyMedium].
  Text bodyMedium(BuildContext context) {
    if (style == null) {
      return copyWith(style: Theme.of(context).textTheme.bodyMedium);
    }
    return this.setStyle(Theme.of(context).textTheme.bodyMedium);
  }

  /// Set the Style to use [bodySmall].
  Text bodySmall(BuildContext context) {
    if (style == null) {
      return copyWith(style: Theme.of(context).textTheme.bodySmall);
    }
    return this.setStyle(Theme.of(context).textTheme.bodySmall);
  }

  /// Make the font bold.
  Text fontWeightBold() {
    return copyWith(style: const TextStyle(fontWeight: FontWeight.bold));
  }

  /// Make the font light.
  Text fontWeightLight() {
    return copyWith(style: const TextStyle(fontWeight: FontWeight.w300));
  }

  /// Change the [style].
  Text setStyle(TextStyle? style) => copyWith(style: style);

  /// Aligns text to the left.
  Text alignLeft() {
    return copyWith(textAlign: TextAlign.left);
  }

  /// Aligns text to the right.
  Text alignRight() {
    return copyWith(textAlign: TextAlign.right);
  }

  /// Aligns text to the center.
  Text alignCenter() {
    return copyWith(textAlign: TextAlign.center);
  }

  /// Aligns text to the center.
  Text setMaxLines(int maxLines) {
    return copyWith(maxLines: maxLines);
  }

  /// Add padding to the text.
  Padding paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) {
    return Padding(
      padding:
          EdgeInsets.only(top: top, left: left, right: right, bottom: bottom),
      child: this,
    );
  }

  /// Change the [fontFamily].
  Text setFontFamily(String fontFamily) =>
      copyWith(style: TextStyle(fontFamily: fontFamily));

  /// Change the [fontSize].
  Text setFontSize(double fontSize) {
    if (style == null) {
      return copyWith(style: TextStyle(fontSize: fontSize));
    }
    return this.setStyle(TextStyle(fontSize: fontSize));
  }

}

/// Check if the [Product] is new.
extension DateTimeExtension on DateTime? {
  bool? isAfterOrEqualTo(DateTime dateTime) {
    final date = this;
    if (date != null) {
      final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
      return isAtSameMomentAs | date.isAfter(dateTime);
    }
    return null;
  }

  bool? isBeforeOrEqualTo(DateTime dateTime) {
    final date = this;
    if (date != null) {
      final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
      return isAtSameMomentAs | date.isBefore(dateTime);
    }
    return null;
  }

  bool? isBetween(
      DateTime fromDateTime,
      DateTime toDateTime,
      ) {
    final date = this;
    if (date != null) {
      final isAfter = date.isAfterOrEqualTo(fromDateTime) ?? false;
      final isBefore = date.isBeforeOrEqualTo(toDateTime) ?? false;
      return isAfter && isBefore;
    }
    return null;
  }
}