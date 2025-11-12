import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff8d4959),
      surfaceTint: Color(0xff8d4959),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffd9df),
      onPrimaryContainer: Color(0xff713342),
      secondary: Color(0xff8f4953),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffd9dc),
      onSecondaryContainer: Color(0xff72333c),
      tertiary: Color(0xff7a5732),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffdcbc),
      onTertiaryContainer: Color(0xff5f401d),
      error: Color(0xff904b40),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad4),
      onErrorContainer: Color(0xff73342b),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff22191b),
      onSurfaceVariant: Color(0xff524345),
      outline: Color(0xff847375),
      outlineVariant: Color(0xffd6c2c4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e30),
      inversePrimary: Color(0xffffb1c0),
      primaryFixed: Color(0xffffd9df),
      onPrimaryFixed: Color(0xff3a0718),
      primaryFixedDim: Color(0xffffb1c0),
      onPrimaryFixedVariant: Color(0xff713342),
      secondaryFixed: Color(0xffffd9dc),
      onSecondaryFixed: Color(0xff3b0713),
      secondaryFixedDim: Color(0xffffb2ba),
      onSecondaryFixedVariant: Color(0xff72333c),
      tertiaryFixed: Color(0xffffdcbc),
      onTertiaryFixed: Color(0xff2c1700),
      tertiaryFixedDim: Color(0xffecbe91),
      onTertiaryFixedVariant: Color(0xff5f401d),
      surfaceDim: Color(0xffe7d6d8),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0f1),
      surfaceContainer: Color(0xfffbeaec),
      surfaceContainerHigh: Color(0xfff5e4e6),
      surfaceContainerHighest: Color(0xffefdee0),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff5d2232),
      surfaceTint: Color(0xff8d4959),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff9f5868),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff5d222c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffa05861),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff4d300e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff8a663f),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff5e241c),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffa1594e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff170f11),
      onSurfaceVariant: Color(0xff403335),
      outline: Color(0xff5e4f51),
      outlineVariant: Color(0xff7a696b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e30),
      inversePrimary: Color(0xffffb1c0),
      primaryFixed: Color(0xff9f5868),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff824050),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xffa05861),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff834049),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff8a663f),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff6f4e2a),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd3c3c5),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0f1),
      surfaceContainer: Color(0xfff5e4e6),
      surfaceContainerHigh: Color(0xffe9d9db),
      surfaceContainerHighest: Color(0xffdeced0),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff501828),
      surfaceTint: Color(0xff8d4959),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff743544),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff511822),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff75353e),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff412605),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff62431f),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff511a13),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff76362d),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff36292b),
      outlineVariant: Color(0xff544548),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e30),
      inversePrimary: Color(0xffffb1c0),
      primaryFixed: Color(0xff743544),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff581f2e),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff75353e),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff591f29),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff62431f),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff482c0b),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc4b5b7),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffeedef),
      surfaceContainer: Color(0xffefdee0),
      surfaceContainerHigh: Color(0xffe1d0d2),
      surfaceContainerHighest: Color(0xffd3c3c5),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb1c0),
      surfaceTint: Color(0xffffb1c0),
      onPrimary: Color(0xff551d2c),
      primaryContainer: Color(0xff713342),
      onPrimaryContainer: Color(0xffffd9df),
      secondary: Color(0xffffb2ba),
      onSecondary: Color(0xff561d26),
      secondaryContainer: Color(0xff72333c),
      onSecondaryContainer: Color(0xffffd9dc),
      tertiary: Color(0xffecbe91),
      onTertiary: Color(0xff462a08),
      tertiaryContainer: Color(0xff5f401d),
      onTertiaryContainer: Color(0xffffdcbc),
      error: Color(0xffffb4a8),
      onError: Color(0xff561e16),
      errorContainer: Color(0xff73342b),
      onErrorContainer: Color(0xffffdad4),
      surface: Color(0xff191113),
      onSurface: Color(0xffefdee0),
      onSurfaceVariant: Color(0xffd6c2c4),
      outline: Color(0xff9f8c8f),
      outlineVariant: Color(0xff524345),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffefdee0),
      inversePrimary: Color(0xff8d4959),
      primaryFixed: Color(0xffffd9df),
      onPrimaryFixed: Color(0xff3a0718),
      primaryFixedDim: Color(0xffffb1c0),
      onPrimaryFixedVariant: Color(0xff713342),
      secondaryFixed: Color(0xffffd9dc),
      onSecondaryFixed: Color(0xff3b0713),
      secondaryFixedDim: Color(0xffffb2ba),
      onSecondaryFixedVariant: Color(0xff72333c),
      tertiaryFixed: Color(0xffffdcbc),
      onTertiaryFixed: Color(0xff2c1700),
      tertiaryFixedDim: Color(0xffecbe91),
      onTertiaryFixedVariant: Color(0xff5f401d),
      surfaceDim: Color(0xff191113),
      surfaceBright: Color(0xff413738),
      surfaceContainerLowest: Color(0xff140c0e),
      surfaceContainerLow: Color(0xff22191b),
      surfaceContainer: Color(0xff261d1f),
      surfaceContainerHigh: Color(0xff312829),
      surfaceContainerHighest: Color(0xff3c3234),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffd1d8),
      surfaceTint: Color(0xffffb1c0),
      onPrimary: Color(0xff481221),
      primaryContainer: Color(0xffc87a8b),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffffd1d5),
      onSecondary: Color(0xff48121c),
      secondaryContainer: Color(0xffca7a83),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffd5ac),
      onTertiary: Color(0xff392001),
      tertiaryContainer: Color(0xffb1895f),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cb),
      onError: Color(0xff48140d),
      errorContainer: Color(0xffcc7b6f),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff191113),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffedd7da),
      outline: Color(0xffc1adb0),
      outlineVariant: Color(0xff9e8c8e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffefdee0),
      inversePrimary: Color(0xff733443),
      primaryFixed: Color(0xffffd9df),
      onPrimaryFixed: Color(0xff2c000d),
      primaryFixedDim: Color(0xffffb1c0),
      onPrimaryFixedVariant: Color(0xff5d2232),
      secondaryFixed: Color(0xffffd9dc),
      onSecondaryFixed: Color(0xff2c0009),
      secondaryFixedDim: Color(0xffffb2ba),
      onSecondaryFixedVariant: Color(0xff5d222c),
      tertiaryFixed: Color(0xffffdcbc),
      onTertiaryFixed: Color(0xff1d0d00),
      tertiaryFixedDim: Color(0xffecbe91),
      onTertiaryFixedVariant: Color(0xff4d300e),
      surfaceDim: Color(0xff191113),
      surfaceBright: Color(0xff4d4243),
      surfaceContainerLowest: Color(0xff0c0607),
      surfaceContainerLow: Color(0xff241b1d),
      surfaceContainer: Color(0xff2f2527),
      surfaceContainerHigh: Color(0xff3a3032),
      surfaceContainerHighest: Color(0xff463b3d),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffebed),
      surfaceTint: Color(0xffffb1c0),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffacbc),
      onPrimaryContainer: Color(0xff210008),
      secondary: Color(0xffffebec),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffffacb5),
      onSecondaryContainer: Color(0xff210005),
      tertiary: Color(0xffffedde),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffe8ba8d),
      onTertiaryContainer: Color(0xff150800),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea1),
      onErrorContainer: Color(0xff220000),
      surface: Color(0xff191113),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffffebed),
      outlineVariant: Color(0xffd2bec0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffefdee0),
      inversePrimary: Color(0xff733443),
      primaryFixed: Color(0xffffd9df),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffb1c0),
      onPrimaryFixedVariant: Color(0xff2c000d),
      secondaryFixed: Color(0xffffd9dc),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffffb2ba),
      onSecondaryFixedVariant: Color(0xff2c0009),
      tertiaryFixed: Color(0xffffdcbc),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffecbe91),
      onTertiaryFixedVariant: Color(0xff1d0d00),
      surfaceDim: Color(0xff191113),
      surfaceBright: Color(0xff594d4f),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff261d1f),
      surfaceContainer: Color(0xff382e30),
      surfaceContainerHigh: Color(0xff43393a),
      surfaceContainerHighest: Color(0xff4f4446),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.background,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
