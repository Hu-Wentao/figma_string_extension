## Features

- asBoxShadow
- asColor

## Getting started

```dart
import 'package:figma_string_extension/figma_string_extension.dart';
```

## Usage

see more at `/example` folder.

```dart
import 'package:figma_string_extension/figma_string_extension.dart';

main() {
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
```

## Additional information

