library figma_string_extension;

import 'package:collection/collection.dart';
import 'package:flutter/painting.dart';
import 'package:get_it/get_it.dart';

class FigmaStringConfig {
  Color? Function(String)? color;
  bool? autoParseHexColor; // null, will use old; if old == null, use 'false'.
  TextStyle? Function(String)? textStyle;

  FigmaStringConfig({
    this.color,
    this.autoParseHexColor = true,
    this.textStyle,
  });

  ///
  /// if use [FigmaStringConfig].[setResolver]
  static FigmaStringConfig? _;
  static const singletonName = 'I';

  static FigmaStringConfig get I {
    if (GetIt.I.isRegistered<FigmaStringConfig>(instanceName: singletonName)) {
      return GetIt.I.get<FigmaStringConfig>(instanceName: singletonName);
    }
    return _ ??= FigmaStringConfig();
  }

  /// old add [extend]
  FigmaStringConfig merge(FigmaStringConfig extend) => FigmaStringConfig(
        color: (p) => color?.call(p) ?? extend.color?.call(p),
        autoParseHexColor: autoParseHexColor ?? extend.autoParseHexColor,
        textStyle: textStyle ?? extend.textStyle,
      );

  /// [setResolver] can help you quick start work
  /// (if you not use get_it register<FigmaStringConfig>)
  static void setResolver({
    Color? Function(String)? color,
    bool autoParseHexColor = true,
    TextStyle? Function(String)? textStyle,
    //
    @Deprecated('colorRes') Color? Function(String)? colorRes,
    @Deprecated('textStyle') TextStyle? Function(String)? textRes,
  }) {
    final c = FigmaStringConfig.I;
    if (colorRes != null) c.color = colorRes;
    if (textRes != null) c.textStyle = textRes;
  }

  ///

  /// #035F9E #D8F0FE33
  Color asColor(String s) {
    if (autoParseHexColor ?? false) {
      if (s.startsWith('#')) {
        if (s.length == 7) {
          return Color(int.parse('FF${s.substring(1)}', radix: 16));
        } else if (s.length == 9) {
          return Color(
            int.parse(s.substring(7) + s.substring(1, 7), radix: 16),
          );
        } else {
          throw 'The color string must start with # and be 7 characters long or 9 characters long (with Opacity).';
        }
      }
    }
    return color?.call(s) ??
        (throw "Not match [$s]; Please config `$FigmaStringConfig.setResolver(color)`");
  }

  TextStyle asTextStyle(String s) {
    return textStyle?.call(s) ??
        (throw "Not match [$s]; Please config `$FigmaStringConfig.setResolver(textStyle)`");
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
  Color get asColor => FigmaStringConfig.I.asColor(this);

  TextStyle get asTextStyle => FigmaStringConfig.I.asTextStyle(this);
}

extension FigmaTextStyleX on TextStyle {
  TextStyle withColor(String color) => copyWith(color: color.asColor);

  TextStyle withBlackOr([String color = '#000000']) =>
      copyWith(color: color.asColor);

  @Deprecated('withBlackOr')
  TextStyle withColorBlackOr([String color = '#000000']) => withBlackOr(color);
}
