library figma_string_extension;

export 'package:figma_string_extension/resolver/color.dart';
export 'package:figma_string_extension/resolver/text_style.dart';

import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:figma_string_extension/resolver/color.dart';
import 'package:figma_string_extension/resolver/text_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:get_it/get_it.dart';

class FigmaStringConfig {
  Set<ColorResolverPart> colorResolvers = {};
  Set<TextStyleResolverPart> textStyleResolvers = {};

  /// will auto set [figmaColorResolver]
  FigmaStringConfig.of({
    Iterable<ColorResolverPart>? colorResolvers,
    Iterable<TextStyleResolverPart>? textStyleResolvers,
  })  : textStyleResolvers = {...?textStyleResolvers},
        colorResolvers = {...?colorResolvers, figmaColorResolver};

  // null: by kDebugModel; true: enable; false disable
  static bool enableLog = kDebugMode;
  static String logName = 'FigmaStringConfig';

  static FigmaStringConfig get I {
    // auto reg
    if (!GetIt.I.isRegistered<FigmaStringConfig>()) {
      List<ColorResolverPart>? colors;
      List<TextStyleResolverPart>? styles;
      try {
        colors = GetIt.I.getAll<ColorResolverPart>().toList();
      } catch (e) {
        if (enableLog) {
          log('DEV TIPS: You are not register any `ColorResolverPart`',
              name: logName);
        }
      }
      try {
        styles = GetIt.I.getAll<TextStyleResolverPart>().toList();
      } catch (e) {
        if (enableLog) {
          log('DEV TIPS: You are not register any `ColorResolverPart`',
              name: logName);
        }
      }
      final cfg = FigmaStringConfig.of(
        colorResolvers: colors,
        textStyleResolvers: styles,
      );
      GetIt.I.registerSingleton(cfg);
      if (enableLog) {
        log('Auto Reg[$FigmaStringConfig]:\n\t$cfg', name: logName);
      }
    }
    return GetIt.I<FigmaStringConfig>();
  }

  /// insert new resolver
  static void insertResolver({
    Iterable<ColorResolverPart>? colorResolvers,
    Iterable<TextStyleResolverPart>? textStyleResolvers,
  }) {
    final cfg = FigmaStringConfig.I;
    cfg.colorResolvers = {...?colorResolvers, ...cfg.colorResolvers};
    cfg.textStyleResolvers = {
      ...?textStyleResolvers,
      ...cfg.textStyleResolvers
    };
  }

  /// replace resolver
  static void setResolver({
    Iterable<ColorResolverPart>? colorResolvers,
    Iterable<TextStyleResolverPart>? textStyleResolvers,
  }) {
    final c = FigmaStringConfig.I;
    if (colorResolvers != null) c.colorResolvers = colorResolvers.toSet();
    if (textStyleResolvers != null) {
      c.textStyleResolvers = textStyleResolvers.toSet();
    }
  }

  @override
  String toString() => ''
      'color: $colorResolvers\n'
      'textStyle: $textStyleResolvers\n';

  ///

  /// #035F9E #D8F0FE33
  Color asColor(String s) {
    for (final res in colorResolvers) {
      final r = res.color.call(s);
      if (r != null) return r;
    }
    throw "Not match Color[$s]; \nPlease config `$FigmaStringConfig.addResolver`";
  }

  TextStyle asTextStyle(String s) {
    for (final res in textStyleResolvers) {
      final r = res.textStyle.call(s);
      if (r != null) return r;
    }
    throw "Not match TextStyle[$s]; \nPlease config `$FigmaStringConfig.addResolver`";
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
  List<BoxShadow> get asBoxShadows => split(';')
      .whereNot((e) => e == '')
      .map((e) => e.trim().asBoxShadow)
      .toList();

  /// figma box-shadow
  /// box-shadow: 0px 3px 3px 0px #0000001F
  BoxShadow get asBoxShadow {
    final p = split(' ');
    assert(p[0] == 'box-shadow:',
        'please input full figma box-shadow param (include `box-shadow`)');
    assert(p.length == 6, 'please input full figma box-shadow param');
    var colorRaw = p[5];
    if (colorRaw.endsWith(';')) {
      colorRaw = colorRaw.substring(0, colorRaw.length - 1);
    }
    final color = figmaColorResolver.color(p[5])!;
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

  @Deprecated('use "FigmaStringConfig.of" instead')
  @visibleForTesting
  static get init => FigmaStringConfig.of;
}

extension FigmaTextStyleX on TextStyle {
  TextStyle withColor(String color) => copyWith(color: color.asColor);

  TextStyle withBlackOr([String color = '#000000']) =>
      copyWith(color: color.asColor);

  @Deprecated('withBlackOr')
  TextStyle withColorBlackOr([String color = '#000000']) => withBlackOr(color);
}
