library figma_string_extension;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

extension FigmaStringX on String {
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
    assert(
        startsWith('#') && (length == 7 || length == 9), '颜色字符串必须以#开头，长度为7或9');
    if (length == 7) {
      return Color(int.parse('FF${substring(1)}', radix: 16));
    } else {
      return Color(int.parse(substring(7) + substring(1, 7), radix: 16));
    }
  }
}
