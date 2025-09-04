import 'package:figma_string_extension/figma_string_extension.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  // reg use get_it
  GetIt.I.registerSingleton<ColorResolverPart>(
      ColorResolverPart((p) => switch (p) {
            'Card Color' => const Color(0xffFFF0FE),
            'Card Title Container Color' => const Color(0xffFFF2FE),
            _ => throw 'unknown color [$p]',
          }),
      instanceName: 'CustomName(Optional)');
  GetIt.I.registerSingleton<TextStyleResolverPart>(
    TextStyleResolverPart(
      (p) => switch (p) {
        'Card Text' => const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        'Card Title' => const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w500,
          ),
        _ => throw 'unknown textStyle [$p]'
      },
    ),
    instanceName:
        'CustomName2, multiple color resolver must set different name',
  );

  runApp(MaterialApp(
    home: Scaffold(
      body: Center(
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: '#D8F0FEF1'.asColor,
            boxShadow: 'box-shadow: 0px 3px 3px 0px #0000001F;'.asBoxShadows,
          ),
          child: const Text("hello"),
        ),
      ),
    ),
  ));
}
