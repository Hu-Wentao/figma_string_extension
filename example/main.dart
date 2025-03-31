import 'package:figma_string_extension/figma_string_extension.dart';
import 'package:flutter/material.dart';

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
