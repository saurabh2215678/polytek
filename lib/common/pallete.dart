import 'package:flutter/material.dart';
class Palette {
  static const MaterialColor themePallete = const MaterialColor(
    0xffF16532, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0x1af16532),//10%
      100: const Color(0x33f16532),//20%
      200: const Color(0x4df16532),//30%
      300: const Color(0x66f16532),//40%
      400: const Color(0x80f16532),//50%
      500: const Color(0x99f16532),//60%
      600: const Color(0xb3f16532),//70%
      700: const Color(0xccf16532),//80%
      800: const Color(0xe6f16532),//90%
      900: const Color(0xffF16532),//100%
    },
  );
}