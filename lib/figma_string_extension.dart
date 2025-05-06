library figma_string_extension;

import 'package:collection/collection.dart';
import 'package:flutter/painting.dart';

class FigmaStringConfig {
  static Color? Function(String)? _colorResolver;
  static TextStyle? Function(String)? _textStyleResolver;

  ///
  static void setResolver({
    Color? Function(String)? colorRes,
    TextStyle? Function(String)? textRes,
  }) {
    if (colorRes != null) _colorResolver = colorRes;
    if (textRes != null) _textStyleResolver = textRes;
  }
}

extension FigmaStringX on String {
  /// figma Radius
  /// 12px
  BorderRadiusGeometry get asBorderRadiusAll {
    assert(endsWith('px'));
    final radius = double.parse(substring(0, length - 2));
    return BorderRadius.all(Radius.circular(radius));
  }

  /// figma box-shadow 注意,包含 ‘;’
  /// box-shadow: 0px 3px 3px 0px #0000001F;
  List<BoxShadow> get asBoxShadows =>
      split(';').whereNot((_) => _ == '').map((e) => e.asBoxShadow).toList();

  /// figma box-shadow
  /// box-shadow: 0px 3px 3px 0px #0000001F
  BoxShadow get asBoxShadow {
    final p = split(' ');
    assert(p[0] == 'box-shadow:', '请输入figma box-shadow: 包含开头');
    assert(p.length == 6, '请输入figma box-shadow: 完整参数');
    final color = p[5].asColor;
    final pixels = p
        .slice(1, 5)
        .map((_) => double.parse(_.substring(0, _.length - 2)))
        .toList();
    // print('color$color, pixels$pixels');
    return BoxShadow(
      color: color,
      offset: Offset(pixels[0], pixels[1]),
      blurRadius: pixels[2],
      spreadRadius: pixels[3],
      // blurStyle: BlurStyle.outer, // 不起作用
    );
  }

  /// figma color
  /// #035F9E #D8F0FE33
  Color get asColor {
    if (startsWith('#')) {
      if (length == 7) {
        return Color(int.parse('FF${substring(1)}', radix: 16));
      } else if (length == 9) {
        return Color(int.parse(substring(7) + substring(1, 7), radix: 16));
      } else {
        throw 'The color string must start with # and be 7 characters long or 9 characters long (with Opacity).';
      }
    } else {
      return FigmaStringConfig._colorResolver?.call(this) ??
          (throw "Please config `FigmaString.setColorResolver` [$this]");
    }
  }

  TextStyle get asTextStyle {
    return FigmaStringConfig._textStyleResolver?.call(this) ??
        (throw "Please config `FigmaString.setTextStyleResolver` [$this]");
  }
}

extension FigmaTextStyleX on TextStyle {
  TextStyle withColor(String color) => copyWith(color: color.asColor);

  TextStyle withBlackOr([String color = '#000000']) =>
      copyWith(color: color.asColor);

  @Deprecated('withBlackOr')
  TextStyle withColorBlackOr([String color = '#000000']) => withBlackOr(color);
}
