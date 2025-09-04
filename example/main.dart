import 'package:figma_string_extension/figma_string_extension.dart';
import 'package:flutter/material.dart';

main() {
  FigmaStringConfig.insertResolver(
      // if you have custom color
      colorResolvers: [
        ColorResolverPart((p) => switch (p) {
              'Card Color' => const Color(0xffFFF0FE),
              _ => throw 'unknown color [$p]',
            })
      ],
      // if you have custom textStyle
      textStyleResolvers: [
        TextStyleResolverPart(
          (p) => switch (p) {
            'Card Text' => const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            _ => throw 'unknown textStyle [$p]'
          },
        )
      ]);

  runApp(MaterialApp(
    home: Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              width: 100,
              height: 50,

              /// custom color
              color: 'Card Color'.asColor,
            ),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                /// figma hex color
                color: '#D8F0FEF1'.asColor,

                /// figma box-shadow
                boxShadow:
                    'box-shadow: 0px 3px 3px 0px #0000001F;'.asBoxShadows,
              ),
              child: Text(
                "hello",

                /// custom text style
                style: 'Card Text'.asTextStyle,
              ),
            ),
          ],
        ),
      ),
    ),
  ));
}
