import 'package:flutter/painting.dart';

/// Flutter TextStyle, not dart
class TextStyleResolverPart {
  final String? debugLabel;
  final TextStyle? Function(String) textStyle;

  TextStyleResolverPart(this.textStyle, {this.debugLabel});

  @override
  String toString() => 'TextStyleResolverPart{$debugLabel $hashCode}';
}
