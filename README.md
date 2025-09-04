## Features

### asColor
```dart
'#00FF00'.asColor, // Color(0xff00FF00)
```

- asTextStyle
- asBoxShadow
```dart
'box-shadow: 0px 3px 3px 0px #0000001F;'.asBoxShadows, //
```

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

