import 'package:flutter/material.dart';
import 'package:fuelsapp/utils/ColorUtil.dart';

// ignore: avoid_classes_with_only_static_members
class ThemeUtil {
  static const Color primaryColor = Color(0xFFEE3124);

  ColorUtil colorUtil = ColorUtil();

  String primaryFontFamily = 'Product Sans';
  static TextStyle get title1 => const TextStyle(
        color: Color(0xFF000000),
        fontWeight: FontWeight.w700,
        fontSize: 24,
      );
  static TextStyle get title2 => const TextStyle(
        color: Color(0xFF000000),
        fontWeight: FontWeight.w700,
        fontSize: 20,
      );
  static TextStyle get title1White => const TextStyle(
        color: Color(0xFFffffff),
        fontWeight: FontWeight.bold,
        fontSize: 28,
      );

  // auth pages
  static TextStyle get authTitle1 => const TextStyle(
        color: Color(0xFF000000),
        fontWeight: FontWeight.w500,
        fontSize: 26,
      );
  static TextStyle get authTitle2 => const TextStyle(
        color: Color(0xFF000000),
        fontWeight: FontWeight.w400,
        fontSize: 26,
      );
  static TextStyle get authSubTitle1 => const TextStyle(
        color: Color(0xFF555555),
        fontWeight: FontWeight.w400,
        fontSize: 16,
      );
  static TextStyle get authHintText => const TextStyle(
        color: Color(0xFF888888),
        fontWeight: FontWeight.w400,
        fontSize: 15,
      );
  static TextStyle get title1Balance => const TextStyle(
        color: Color(0xFF000000),
        fontWeight: FontWeight.w700,
        fontSize: 26,
      );
  static TextStyle get subtitle1Balance => const TextStyle(
        color: Color(0xFF888888),
        fontWeight: FontWeight.normal,
        fontSize: 14,
      );
  // static TextStyle get title3 => GoogleFonts.getFont(
  //       'Product Sans',
  //       color: Color(0xFF303030),
  //       fontWeight: FontWeight.w500,
  //       fontSize: 20,
  //     );
  static TextStyle get subtitle1 => const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        fontFamily: "Product Sans",
      );
  static TextStyle get subtitle1Red => TextStyle(
        color: ColorUtil().primaryRed,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        fontFamily: "Product Sans",
      );
  static TextStyle get subtitle2Grey => TextStyle(
        color: Colors.white.withOpacity(0.5),
        fontWeight: FontWeight.w400,
        fontSize: 16,
        fontFamily: "Product Sans",
      );
  static TextStyle get cardNumber => const TextStyle(
        color: Color.fromARGB(255, 245, 238, 238),
        fontWeight: FontWeight.w400,
        fontSize: 23,
        fontFamily: "Product Sans",
      );
  static TextStyle get bodyText1 => const TextStyle(
        color: Color(0xFFffffff),
        fontWeight: FontWeight.w400,
        fontSize: 15,
      );
  static TextStyle get moreStyle => const TextStyle(
        color: Color(0xFF555555),
        fontWeight: FontWeight.w500,
        fontSize: 16,
      );
  // static TextStyle get subtitle2 => GoogleFonts.getFont(
  //       'Product Sans',
  //       color: Color(0xFF616161),
  //       fontWeight: FontWeight.normal,
  //       fontSize: 16,
  //     );
  // static TextStyle get bodyText2 => GoogleFonts.getFont(
  //       'Product Sans',
  //       color: Color(0xFF424242),
  //       fontWeight: FontWeight.normal,
  //       fontSize: 14,
  //     );
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    required String fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
  }) =>
      copyWith(
        fontFamily: fontFamily,
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
      );
}
