import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:figma_string_extension/figma_string_extension.dart';

void main() {
  test('figmaColorResolver', () {
    final rst = [
      figmaColorResolver.color('#112233'),
      figmaColorResolver.color('#11223300'),
    ];
    expect(rst[0], const Color(0xFF112233));
    expect(rst[1], const Color(0x00112233));
  });
}
