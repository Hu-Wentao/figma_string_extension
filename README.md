## Features

- asColor
- asTextStyle
- asBoxShadow

## Getting started

> see more at `/example` folder.

```dart
import 'package:figma_string_extension/figma_string_extension.dart';

main() {
  FigmaStringConfig.insertResolver(
    // if you have custom color
    colorResolvers: [
      ColorResolverPart((p) {
        switch (p) {
          case 'Card Color':
            return const Color(0xffFFF0FE);
          default:
            throw 'unknown color [$p]';
        }
      })
    ],
  );

  runApp(MaterialApp(
    home: Scaffold(
      body: Center(
        child: Container(

          /// figma hex color
          color: '#D8F0FEF1'.asColor,
          child: Text(
            "hello",

            /// custom text style
            style: 'Card Text'.asTextStyle,
          ),
        ),
      ),
    ),
  ));
}
```

## Additional information

