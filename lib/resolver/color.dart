import 'dart:ui';

class ColorResolverPart {
  final String? debugLabel;
  final Color? Function(String) color;

  ColorResolverPart(this.color,{this.debugLabel});

  @override
  String toString() => 'ColorResolverPart{$debugLabel $hashCode}';
}

final figmaColorResolver = ColorResolverPart(
  (p) {
    if (p.startsWith('#')) {
      if (p.length == 7) {
        return Color(int.parse('FF${p.substring(1)}', radix: 16));
      } else if (p.length == 9) {
        return Color(
          int.parse(p.substring(7) + p.substring(1, 7), radix: 16),
        );
      } else {
        throw 'The color string must start with # and be 7 characters long or 9 characters long (with Opacity).';
      }
    }
    return null;
  },
  debugLabel: 'FigmaHexColorResolver'
);
