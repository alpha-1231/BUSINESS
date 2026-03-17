// ============================================================
//  fluent_windows_theme.dart
//  Production-ready Windows 12 Fluent Design 2 UI System for Flutter
//
//  Implements:
//  • Acrylic material  (blur + noise + luminosity tint)
//  • Mica material     (wallpaper-sampled ambient tint)
//  • Reveal Highlight  (pointer-aware border glow)
//  • WinUI 3 color tokens & ramp
//  • Segoe UI Variable typography scale
//  • Fluent motion curves & durations
//  • Full dark / light mode
//
//  QUICK START
//  -----------
//  1. Drop this file into lib/theme/
//  2. Wrap your MaterialApp:
//
//     MaterialApp(
//       theme:      FluentWindowsTheme.light(),
//       darkTheme:  FluentWindowsTheme.dark(),
//       home:       const MyHomePage(),
//     )
//
//  3. Use Fluent widgets anywhere:
//
//     AcrylicContainer(child: Text('Hello'))
//     MicaContainer(child: Text('Background'))
//     FluentCard(child: Text('Card'))
//     FluentButton(label: 'Click', onTap: () {})
//     FluentButton.accent(label: 'Primary', onTap: () {})
//     FluentButton.subtle(label: 'Ghost', onTap: () {})
//     FluentTextField(hint: 'Search...')
//     FluentNavPane(items: [...], currentIndex: 0, onTap: (_) {})
//     FluentCommandBar(items: [...])
//     FluentDialog.show(context: ctx, title: 'Title', content: ...)
//     FluentToggleSwitch(value: true, onChanged: (_) {})
//     FluentChip(label: 'Tag')
//     FluentListTile(title: 'Setting', onTap: () {})
//     FluentSectionHeader(title: 'General')
//     FluentIconButton(icon: Icons.add, onTap: () {})
//
// ============================================================

library fluent_windows;

// import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────
// 1. FLUENT DESIGN TOKENS
//    Source: WinUI 3 / Windows 12 design system
// ─────────────────────────────────────────────

abstract class FluentTokens {
  // --- Corner radii (WinUI 3 spec) ---
  static const double radiusNone = 0.0;
  static const double radiusXS = 2.0; // tooltip, badge
  static const double radiusSM = 4.0; // button, input
  static const double radiusMD = 8.0; // card, flyout
  static const double radiusLG = 12.0; // dialog, pane
  static const double radiusXL = 16.0; // large panel
  static const double radiusFull = 999.0; // pill / toggle

  // --- Acrylic blur radii ---
  static const double acrylicBlurSM = 20.0;
  static const double acrylicBlurMD = 30.0;
  static const double acrylicBlurLG = 60.0;
  static const double micaBlur = 80.0;

  // --- Acrylic opacity layers ---
  static const double acrylicTintLight = 0.70; // light mode tint opacity
  static const double acrylicTintDark = 0.80; // dark mode tint opacity
  static const double acrylicLuminosityLight = 0.85;
  static const double acrylicLuminosityDark = 0.60;
  static const double acrylicNoiseOpacity = 0.02;

  // --- Stroke / border ---
  static const double strokeWidthThin = 1.0;
  static const double strokeWidthNormal = 1.5;
  static const double strokeOpacityLight = 0.08; // card divider
  static const double strokeOpacityMedium = 0.14;
  static const double strokeOpacityStrong = 0.22;

  // --- Elevation shadows (Fluent depth) ---
  // Fluent uses layered box shadows; not blurred halos
  static const double shadowSM = 2.0;
  static const double shadowMD = 4.0;
  static const double shadowLG = 8.0;
  static const double shadowXL = 16.0;

  // --- Fluent motion (Windows motion spec) ---
  // FastInvoke: immediate, snappy
  static const Duration durationFastInvoke = Duration(milliseconds: 83);
  // Execute: standard control response
  static const Duration durationExecute = Duration(milliseconds: 167);
  // ExitContent: element leaving the screen
  static const Duration durationExitContent = Duration(milliseconds: 83);
  // EnterContent: element entering the screen
  static const Duration durationEnterContent = Duration(milliseconds: 250);
  // Page transition
  static const Duration durationPage = Duration(milliseconds: 333);

  // --- Fluent easing curves ---
  // DecelerateMax: for things entering the screen
  static const Curve curveDecelerateMax = Curves.easeOutCubic;
  // AccelerateMax: for things leaving the screen
  static const Curve curveAccelerateMax = Curves.easeInCubic;
  // Standard: general-purpose
  static const Curve curveStandard = Curves.easeInOutCubic;

  // --- Spacing (4pt grid) ---
  static const double spacing2 = 2.0;
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;

  // --- Control heights ---
  static const double controlHeightSM = 24.0;
  static const double controlHeightMD = 32.0;
  static const double controlHeightLG = 40.0;
}

// ─────────────────────────────────────────────
// 2. WINDOWS 12 COLOR RAMP
//    WinUI 3 official palette + semantic tokens
// ─────────────────────────────────────────────

class FluentColors {
  const FluentColors._();

  // ── Accent palette (Windows default "Capture" blue) ──────────────
  static const Color accentDark3 = Color(0xFF003966);
  static const Color accentDark2 = Color(0xFF004E8C);
  static const Color accentDark1 = Color(0xFF005FB8);
  static const Color accent = Color(0xFF0067C0); // base
  static const Color accentLight1 = Color(0xFF0078D4);
  static const Color accentLight2 = Color(0xFF479EF5);
  static const Color accentLight3 = Color(0xFF62ABFF);

  // ── System semantic ───────────────────────────────────────────────
  static const Color systemRed = Color(0xFFBC2F32);
  static const Color systemGreen = Color(0xFF107C10);
  static const Color systemYellow = Color(0xFFFFF100);
  static const Color systemOrange = Color(0xFFDA3B01);
  static const Color systemPurple = Color(0xFF881798);

  // ── Light mode surfaces ───────────────────────────────────────────
  // Mica base
  static const Color lightMicaBase = Color(0xFFF3F3F3);
  // Acrylic tint
  static const Color lightAcrylicTint = Color(0xFFFCFCFC);
  // Layered solid surfaces
  static const Color lightSolidBase = Color(0xFFFFFFFF);
  static const Color lightSolidSecondary = Color(0xFFF9F9F9);
  static const Color lightSolidTertiary = Color(0xFFF3F3F3);
  static const Color lightSolidQuarternary = Color(0xFFEEEEEE);
  // Subtle overlays
  static const Color lightFillColorSubtle = Color(0x0F000000); // 6% black
  static const Color lightFillColorSecondary = Color(0x19000000); // 10%
  static const Color lightFillColorTertiary = Color(0x24000000); // 14%

  // ── Dark mode surfaces ────────────────────────────────────────────
  static const Color darkMicaBase = Color(0xFF202020);
  static const Color darkAcrylicTint = Color(0xFF2C2C2C);
  static const Color darkSolidBase = Color(0xFF242424);
  static const Color darkSolidSecondary = Color(0xFF1F1F1F);
  static const Color darkSolidTertiary = Color(0xFF282828);
  static const Color darkSolidQuarternary = Color(0xFF2C2C2C);
  static const Color darkFillColorSubtle = Color(0x0FFFFFFF); // 6% white
  static const Color darkFillColorSecondary = Color(0x19FFFFFF); // 10%
  static const Color darkFillColorTertiary = Color(0x24FFFFFF); // 14%

  // ── Stroke / divider ─────────────────────────────────────────────
  static const Color lightStroke = Color(0x1A000000); // 10% black
  static const Color lightStrokeStrong = Color(0x33000000); // 20% black
  static const Color lightStrokeSurface = Color(0x66000000); // 40% black
  static const Color darkStroke = Color(0x1AFFFFFF);
  static const Color darkStrokeStrong = Color(0x33FFFFFF);
  static const Color darkStrokeSurface = Color(0x66FFFFFF);

  // ── Text ──────────────────────────────────────────────────────────
  static const Color lightTextPrimary = Color(0xE4000000); // 89%
  static const Color lightTextSecondary = Color(0x9A000000); // 60%
  static const Color lightTextTertiary = Color(0x72000000); // 45%
  static const Color lightTextDisabled = Color(0x5C000000); // 36%
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xC8FFFFFF); // 78%
  static const Color darkTextTertiary = Color(0x8BFFFFFF); // 54%
  static const Color darkTextDisabled = Color(0x5CFFFFFF); // 36%

  // ── Shadows ───────────────────────────────────────────────────────
  static const Color lightShadow = Color(0x38000000); // 22%
  static const Color darkShadow = Color(0x52000000); // 32%
}

// ─────────────────────────────────────────────
// 3. MATERIAL STYLE CONFIG (per-widget)
// ─────────────────────────────────────────────

enum FluentMaterial { acrylic, mica, solidBase, solidCard, none }

@immutable
class FluentStyle {
  const FluentStyle({
    this.material = FluentMaterial.acrylic,
    this.blur = FluentTokens.acrylicBlurMD,
    this.radius = FluentTokens.radiusMD,
    this.tintColor,
    this.enableRevealHighlight = true,
    this.enableShadow = true,
    this.shadowElevation = FluentTokens.shadowMD,
  });

  final FluentMaterial material;
  final double blur;
  final double radius;
  final Color? tintColor;
  final bool enableRevealHighlight;
  final bool enableShadow;
  final double shadowElevation;

  /// Thin flyout / tooltip surface
  static const FluentStyle flyout = FluentStyle(
    material: FluentMaterial.acrylic,
    blur: FluentTokens.acrylicBlurSM,
    radius: FluentTokens.radiusMD,
    enableRevealHighlight: false,
    shadowElevation: FluentTokens.shadowSM,
  );

  /// Standard card surface
  static const FluentStyle card = FluentStyle(
    material: FluentMaterial.solidCard,
    blur: 0,
    radius: FluentTokens.radiusMD,
    enableRevealHighlight: true,
    shadowElevation: FluentTokens.shadowSM,
  );

  /// Acrylic panel (sidebars, nav pane)
  static const FluentStyle pane = FluentStyle(
    material: FluentMaterial.acrylic,
    blur: FluentTokens.acrylicBlurMD,
    radius: FluentTokens.radiusNone,
    enableRevealHighlight: false,
    shadowElevation: FluentTokens.shadowMD,
  );

  /// Mica background (full-window base layer)
  static const FluentStyle micaPage = FluentStyle(
    material: FluentMaterial.mica,
    blur: FluentTokens.micaBlur,
    radius: FluentTokens.radiusNone,
    enableRevealHighlight: false,
    enableShadow: false,
  );

  /// Dialog surface
  static const FluentStyle dialog = FluentStyle(
    material: FluentMaterial.acrylic,
    blur: FluentTokens.acrylicBlurLG,
    radius: FluentTokens.radiusLG,
    enableRevealHighlight: false,
    shadowElevation: FluentTokens.shadowXL,
  );

  FluentStyle copyWith({
    FluentMaterial? material,
    double? blur,
    double? radius,
    Color? tintColor,
    bool? enableRevealHighlight,
    bool? enableShadow,
    double? shadowElevation,
  }) =>
      FluentStyle(
        material: material ?? this.material,
        blur: blur ?? this.blur,
        radius: radius ?? this.radius,
        tintColor: tintColor ?? this.tintColor,
        enableRevealHighlight:
            enableRevealHighlight ?? this.enableRevealHighlight,
        enableShadow: enableShadow ?? this.enableShadow,
        shadowElevation: shadowElevation ?? this.shadowElevation,
      );
}

// ─────────────────────────────────────────────
// 4. INHERITED FLUENT THEME
// ─────────────────────────────────────────────

class FluentThemeData {
  const FluentThemeData({
    required this.brightness,
    this.accentColor = FluentColors.accent,
  });

  final Brightness brightness;
  final Color accentColor;

  bool get isDark => brightness == Brightness.dark;

  // ── Surface tokens ─────────────────────────
  Color get micaBase =>
      isDark ? FluentColors.darkMicaBase : FluentColors.lightMicaBase;
  Color get acrylicTint =>
      isDark ? FluentColors.darkAcrylicTint : FluentColors.lightAcrylicTint;
  Color get solidBase =>
      isDark ? FluentColors.darkSolidBase : FluentColors.lightSolidBase;
  Color get solidSecondary => isDark
      ? FluentColors.darkSolidSecondary
      : FluentColors.lightSolidSecondary;
  Color get solidTertiary =>
      isDark ? FluentColors.darkSolidTertiary : FluentColors.lightSolidTertiary;
  Color get fillSubtle => isDark
      ? FluentColors.darkFillColorSubtle
      : FluentColors.lightFillColorSubtle;
  Color get fillSecondary => isDark
      ? FluentColors.darkFillColorSecondary
      : FluentColors.lightFillColorSecondary;

  // ── Stroke tokens ──────────────────────────
  Color get stroke =>
      isDark ? FluentColors.darkStroke : FluentColors.lightStroke;
  Color get strokeStrong =>
      isDark ? FluentColors.darkStrokeStrong : FluentColors.lightStrokeStrong;
  Color get strokeSurface =>
      isDark ? FluentColors.darkStrokeSurface : FluentColors.lightStrokeSurface;

  // ── Text tokens ────────────────────────────
  Color get textPrimary =>
      isDark ? FluentColors.darkTextPrimary : FluentColors.lightTextPrimary;
  Color get textSecondary =>
      isDark ? FluentColors.darkTextSecondary : FluentColors.lightTextSecondary;
  Color get textTertiary =>
      isDark ? FluentColors.darkTextTertiary : FluentColors.lightTextTertiary;
  Color get textDisabled =>
      isDark ? FluentColors.darkTextDisabled : FluentColors.lightTextDisabled;

  // ── Shadow token ───────────────────────────
  Color get shadow =>
      isDark ? FluentColors.darkShadow : FluentColors.lightShadow;
}

class FluentTheme extends InheritedWidget {
  const FluentTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final FluentThemeData data;

  static FluentThemeData of(BuildContext context) {
    final t = context.dependOnInheritedWidgetOfExactType<FluentTheme>();
    if (t != null) return t.data;
    final brightness = Theme.of(context).brightness;
    return FluentThemeData(brightness: brightness);
  }

  @override
  bool updateShouldNotify(FluentTheme old) => data != old.data;
}

// ─────────────────────────────────────────────
// 5. FLUENT WINDOWS THEME  (MaterialApp ThemeData)
// ─────────────────────────────────────────────

abstract class FluentWindowsTheme {
  static ThemeData light({Color accent = FluentColors.accent}) =>
      _build(Brightness.light, accent);

  static ThemeData dark({Color accent = FluentColors.accent}) =>
      _build(Brightness.dark, accent);

  static ThemeData _build(Brightness brightness, Color accent) {
    final isDark = brightness == Brightness.dark;

    // Accent color ramp derived from provided accent
    final accentLight1 = Color.lerp(accent, Colors.white, 0.15)!;
    final accentDark1 = Color.lerp(accent, Colors.black, 0.15)!;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: accent,
      onPrimary: Colors.white,
      primaryContainer: accent.withValues(alpha: 0.12),
      onPrimaryContainer: accent,
      secondary: accentLight1,
      onSecondary: Colors.white,
      secondaryContainer: accentLight1.withValues(alpha: 0.12),
      onSecondaryContainer: accentLight1,
      tertiary: FluentColors.systemPurple,
      onTertiary: Colors.white,
      tertiaryContainer: FluentColors.systemPurple.withValues(alpha: 0.12),
      onTertiaryContainer: FluentColors.systemPurple,
      error: FluentColors.systemRed,
      onError: Colors.white,
      errorContainer: FluentColors.systemRed.withValues(alpha: 0.12),
      onErrorContainer: FluentColors.systemRed,
      surface:
          isDark ? FluentColors.darkSolidBase : FluentColors.lightSolidBase,
      onSurface:
          isDark ? FluentColors.darkTextPrimary : FluentColors.lightTextPrimary,
      surfaceContainerHighest: isDark
          ? FluentColors.darkSolidTertiary
          : FluentColors.lightSolidTertiary,
      onSurfaceVariant: isDark
          ? FluentColors.darkTextSecondary
          : FluentColors.lightTextSecondary,
      outline: isDark ? FluentColors.darkStroke : FluentColors.lightStroke,
      outlineVariant: isDark
          ? FluentColors.darkFillColorSubtle
          : FluentColors.lightFillColorSubtle,
      shadow: isDark ? FluentColors.darkShadow : FluentColors.lightShadow,
      scrim: Colors.black.withValues(alpha: 0.5),
      inverseSurface:
          isDark ? FluentColors.lightSolidBase : FluentColors.darkSolidBase,
      onInverseSurface:
          isDark ? FluentColors.lightTextPrimary : FluentColors.darkTextPrimary,
      inversePrimary: accentLight1,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,

      // Segoe UI Variable — Windows 12 system font
      fontFamily: 'Segoe UI Variable',
      fontFamilyFallback: const ['Segoe UI', 'SF Pro Display', 'Roboto'],

      // ── Typography (Fluent type ramp) ───────
      textTheme: TextTheme(
        // Display (72pt equivalent)
        displayLarge:
            _textStyle(68, FontWeight.w700, -1.5, colorScheme.onSurface),
        // Title Large — page headings
        displayMedium:
            _textStyle(40, FontWeight.w700, -0.5, colorScheme.onSurface),
        displaySmall:
            _textStyle(28, FontWeight.w700, -0.2, colorScheme.onSurface),
        // Headline — section headings
        headlineLarge:
            _textStyle(24, FontWeight.w600, 0.0, colorScheme.onSurface),
        headlineMedium:
            _textStyle(20, FontWeight.w600, 0.0, colorScheme.onSurface),
        headlineSmall:
            _textStyle(18, FontWeight.w600, 0.0, colorScheme.onSurface),
        // Title — dialog/card titles
        titleLarge: _textStyle(16, FontWeight.w600, 0.0, colorScheme.onSurface),
        titleMedium:
            _textStyle(14, FontWeight.w600, 0.0, colorScheme.onSurface),
        titleSmall: _textStyle(13, FontWeight.w600, 0.0, colorScheme.onSurface),
        // Body
        bodyLarge: _textStyle(16, FontWeight.w400, 0.0, colorScheme.onSurface),
        bodyMedium: _textStyle(14, FontWeight.w400, 0.0, colorScheme.onSurface),
        bodySmall:
            _textStyle(12, FontWeight.w400, 0.0, colorScheme.onSurfaceVariant),
        // Caption / label
        labelLarge: _textStyle(14, FontWeight.w500, 0.0, colorScheme.onSurface),
        labelMedium:
            _textStyle(12, FontWeight.w500, 0.0, colorScheme.onSurface),
        labelSmall:
            _textStyle(10, FontWeight.w500, 0.4, colorScheme.onSurfaceVariant),
      ),

      // ── App Bar ─────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        // Fluent title bar font: Caption / 12pt semibold
        titleTextStyle:
            _textStyle(13, FontWeight.w600, 0.0, colorScheme.onSurface),
        iconTheme: IconThemeData(color: colorScheme.onSurface, size: 16),
        toolbarHeight: 32, // Compact Windows title bar
      ),

      // ── Card ─────────────────────────────────
      cardTheme: CardThemeData(
        color: isDark
            ? FluentColors.darkSolidSecondary.withValues(alpha: 0.50)
            : FluentColors.lightSolidBase.withValues(alpha: 0.70),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FluentTokens.radiusMD),
          side: BorderSide(
            color: isDark ? FluentColors.darkStroke : FluentColors.lightStroke,
            width: FluentTokens.strokeWidthThin,
          ),
        ),
        margin: EdgeInsets.zero,
        shadowColor: colorScheme.shadow,
      ),

      // ── Buttons ──────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          // Accent fill button
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled))
              return colorScheme.onSurface.withValues(alpha: 0.04);
            if (states.contains(WidgetState.pressed))
              return accentDark1.withValues(alpha: 0.88);
            if (states.contains(WidgetState.hovered)) return accentLight1;
            return accent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled))
              return colorScheme.onSurface.withValues(alpha: 0.36);
            return Colors.white;
          }),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          elevation: WidgetStateProperty.all(0),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(FluentTokens.radiusSM),
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(
                horizontal: FluentTokens.spacing12,
                vertical: FluentTokens.spacing8),
          ),
          minimumSize: WidgetStateProperty.all(
              const Size(0, FluentTokens.controlHeightMD)),
          textStyle: WidgetStateProperty.all(
            _textStyle(14, FontWeight.w500, 0.0, Colors.white),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        // Standard (default) button — filled with card tint, stroked border
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled))
              return colorScheme.onSurface.withValues(alpha: 0.02);
            if (states.contains(WidgetState.pressed))
              return isDark
                  ? FluentColors.darkFillColorSecondary
                  : FluentColors.lightFillColorSecondary;
            if (states.contains(WidgetState.hovered))
              return isDark
                  ? FluentColors.darkFillColorSubtle
                  : FluentColors.lightFillColorSubtle;
            return isDark
                ? FluentColors.darkFillColorSubtle
                : FluentColors.lightFillColorSubtle;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled))
              return colorScheme.onSurface.withValues(alpha: 0.36);
            return colorScheme.onSurface;
          }),
          side: WidgetStateProperty.resolveWith((states) {
            return BorderSide(
              color:
                  isDark ? FluentColors.darkStroke : FluentColors.lightStroke,
              width: FluentTokens.strokeWidthThin,
            );
          }),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          elevation: WidgetStateProperty.all(0),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(FluentTokens.radiusSM),
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(
                horizontal: FluentTokens.spacing12,
                vertical: FluentTokens.spacing8),
          ),
          minimumSize: WidgetStateProperty.all(
              const Size(0, FluentTokens.controlHeightMD)),
          textStyle: WidgetStateProperty.all(
            _textStyle(14, FontWeight.w500, 0.0, colorScheme.onSurface),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        // Subtle button — no background, no border
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed))
              return colorScheme.onSurface.withValues(alpha: 0.06);
            if (states.contains(WidgetState.hovered))
              return colorScheme.onSurface.withValues(alpha: 0.04);
            return Colors.transparent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled))
              return colorScheme.onSurface.withValues(alpha: 0.36);
            return colorScheme.onSurface;
          }),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(FluentTokens.radiusSM),
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(
                horizontal: FluentTokens.spacing8,
                vertical: FluentTokens.spacing8),
          ),
          minimumSize: WidgetStateProperty.all(
              const Size(0, FluentTokens.controlHeightMD)),
          textStyle: WidgetStateProperty.all(
            _textStyle(14, FontWeight.w400, 0.0, colorScheme.onSurface),
          ),
        ),
      ),

      // ── Input / TextField ────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? FluentColors.darkFillColorSubtle
            : FluentColors.lightSolidBase,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FluentTokens.radiusSM),
          borderSide: BorderSide(
            color: isDark ? FluentColors.darkStroke : FluentColors.lightStroke,
            width: FluentTokens.strokeWidthThin,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FluentTokens.radiusSM),
          borderSide: BorderSide(
            color: isDark ? FluentColors.darkStroke : FluentColors.lightStroke,
            width: FluentTokens.strokeWidthThin,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FluentTokens.radiusSM),
          // Fluent uses a 2px bottom accent stroke on focus
          borderSide: BorderSide(color: accent, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FluentTokens.radiusSM),
          borderSide:
              const BorderSide(color: FluentColors.systemRed, width: 2.0),
        ),
        hintStyle: TextStyle(
          color: isDark
              ? FluentColors.darkTextTertiary
              : FluentColors.lightTextTertiary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: FluentTokens.spacing12,
          vertical: FluentTokens.spacing8,
        ),
        isDense: true,
      ),

      // ── Chip ─────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: isDark
            ? FluentColors.darkFillColorSubtle
            : FluentColors.lightFillColorSubtle,
        selectedColor: accent.withValues(alpha: 0.14),
        labelStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        side: BorderSide(
          color: isDark ? FluentColors.darkStroke : FluentColors.lightStroke,
          width: FluentTokens.strokeWidthThin,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FluentTokens.radiusSM),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: FluentTokens.spacing8,
          vertical: FluentTokens.spacing2,
        ),
      ),

      // ── Dialog ───────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: isDark
            ? FluentColors.darkSolidSecondary.withValues(alpha: 0.85)
            : FluentColors.lightSolidBase.withValues(alpha: 0.85),
        elevation: 8,
        shadowColor: colorScheme.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FluentTokens.radiusLG),
          side: BorderSide(
            color: isDark ? FluentColors.darkStroke : FluentColors.lightStroke,
            width: FluentTokens.strokeWidthThin,
          ),
        ),
        titleTextStyle:
            _textStyle(20, FontWeight.w600, 0.0, colorScheme.onSurface),
        contentTextStyle:
            _textStyle(14, FontWeight.w400, 0.0, colorScheme.onSurfaceVariant),
      ),

      // ── Bottom Sheet (Fluent: content dialog) ─
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark
            ? FluentColors.darkSolidBase.withValues(alpha: 0.85)
            : FluentColors.lightSolidBase.withValues(alpha: 0.85),
        elevation: 8,
        shadowColor: colorScheme.shadow,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(FluentTokens.radiusLG),
          ),
        ),
        modalBarrierColor: Colors.black.withValues(alpha: 0.40),
      ),

      // ── Navigation Rail (nav pane collapsed) ──
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedIconTheme: IconThemeData(color: accent, size: 16),
        unselectedIconTheme:
            IconThemeData(color: colorScheme.onSurfaceVariant, size: 16),
        indicatorColor: accent.withValues(alpha: 0.14),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FluentTokens.radiusSM),
        ),
        labelType: NavigationRailLabelType.none, // Icons-only by default
        minWidth: 48,
        groupAlignment: -1,
      ),

      // ── Navigation Bar (Mobile nav equiv.) ────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        indicatorColor: accent.withValues(alpha: 0.14),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _textStyle(10, FontWeight.w600, 0.0, accent);
          }
          return _textStyle(
              10, FontWeight.w400, 0.0, colorScheme.onSurfaceVariant);
        }),
      ),

      // ── List Tile ─────────────────────────────
      listTileTheme: ListTileThemeData(
        titleTextStyle:
            _textStyle(14, FontWeight.w400, 0.0, colorScheme.onSurface),
        subtitleTextStyle:
            _textStyle(12, FontWeight.w400, 0.0, colorScheme.onSurfaceVariant),
        iconColor: colorScheme.onSurface,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: FluentTokens.spacing12,
          vertical: FluentTokens.spacing4,
        ),
        minLeadingWidth: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FluentTokens.radiusSM),
        ),
      ),

      // ── Switch (Fluent Toggle Switch) ─────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return isDark
              ? FluentColors.darkTextSecondary
              : FluentColors.lightTextSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return accent;
          return isDark
              ? FluentColors.darkFillColorSecondary
              : FluentColors.lightSolidQuarternary;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.transparent;
          return isDark ? FluentColors.darkStroke : FluentColors.lightStroke;
        }),
      ),

      // ── Slider ────────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor: accent,
        inactiveTrackColor: accent.withValues(alpha: 0.20),
        thumbColor: Colors.white,
        overlayColor: accent.withValues(alpha: 0.12),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        trackHeight: 4,
        trackShape: const RoundedRectSliderTrackShape(),
      ),

      // ── Divider ───────────────────────────────
      dividerTheme: DividerThemeData(
        color: isDark ? FluentColors.darkStroke : FluentColors.lightStroke,
        thickness: 1.0,
        space: 0,
      ),

      // ── Tab Bar ───────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: accent,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: accent, width: 2),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: _textStyle(14, FontWeight.w600, 0.0, accent),
        unselectedLabelStyle:
            _textStyle(14, FontWeight.w400, 0.0, colorScheme.onSurfaceVariant),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        dividerColor: Colors.transparent,
      ),

      // ── Progress Indicator ────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accent,
        linearTrackColor: accent.withValues(alpha: 0.14),
        circularTrackColor: accent.withValues(alpha: 0.14),
        linearMinHeight: 4,
        borderRadius: BorderRadius.circular(FluentTokens.radiusFull),
      ),

      // ── Scrollbar ─────────────────────────────
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(
          colorScheme.onSurface.withValues(alpha: 0.20),
        ),
        radius: const Radius.circular(FluentTokens.radiusFull),
        thickness: WidgetStateProperty.all(4),
        minThumbLength: 32,
      ),

      // ── Tooltip ───────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark
              ? FluentColors.darkSolidTertiary.withValues(alpha: 0.92)
              : FluentColors.lightSolidBase.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(FluentTokens.radiusSM),
          border: Border.all(
            color: isDark ? FluentColors.darkStroke : FluentColors.lightStroke,
          ),
          boxShadow: _buildShadow(FluentTokens.shadowSM, colorScheme.shadow),
        ),
        textStyle: _textStyle(12, FontWeight.w400, 0.0, colorScheme.onSurface),
        padding: const EdgeInsets.symmetric(
          horizontal: FluentTokens.spacing8,
          vertical: FluentTokens.spacing4,
        ),
        waitDuration: const Duration(milliseconds: 700),
      ),

      // ── Snack Bar ─────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor:
            isDark ? FluentColors.darkSolidTertiary : const Color(0xFF323130),
        contentTextStyle: _textStyle(14, FontWeight.w400, 0.0, Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FluentTokens.radiusMD),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),

      // ── FAB ───────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        elevation: 2,
        focusElevation: 4,
        hoverElevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FluentTokens.radiusMD),
        ),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────

  static TextStyle _textStyle(
    double size,
    FontWeight weight,
    double letterSpacing,
    Color color,
  ) =>
      TextStyle(
        fontFamily: 'Segoe UI Variable',
        fontFamilyFallback: const ['Segoe UI', 'Roboto'],
        fontSize: size,
        fontWeight: weight,
        letterSpacing: letterSpacing,
        color: color,
      );

  static List<BoxShadow> _buildShadow(double elevation, Color shadowColor) {
    return [
      BoxShadow(
        color: shadowColor.withValues(alpha: 0.12),
        blurRadius: elevation,
        offset: Offset(0, elevation / 2),
      ),
      BoxShadow(
        color: shadowColor.withValues(alpha: 0.08),
        blurRadius: elevation * 2,
        offset: Offset(0, elevation),
      ),
    ];
  }
}

// ─────────────────────────────────────────────
// 6. ACRYLIC CONTAINER
//    The core Fluent surface: blur + tint + noise
// ─────────────────────────────────────────────

class AcrylicContainer extends StatelessWidget {
  const AcrylicContainer({
    super.key,
    required this.child,
    this.style = FluentStyle.card,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget child;
  final FluentStyle style;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final fd = FluentTheme.of(context);
    final isDark = fd.isDark;

    final tint = style.tintColor ??
        (isDark ? FluentColors.darkAcrylicTint : FluentColors.lightAcrylicTint);

    final tintOpacity =
        isDark ? FluentTokens.acrylicTintDark : FluentTokens.acrylicTintLight;

    final strokeColor =
        isDark ? FluentColors.darkStroke : FluentColors.lightStroke;

    Widget surface = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: tint.withValues(alpha: tintOpacity),
        borderRadius: BorderRadius.circular(style.radius),
        border:
            Border.all(color: strokeColor, width: FluentTokens.strokeWidthThin),
        boxShadow: style.enableShadow
            ? FluentWindowsTheme._buildShadow(style.shadowElevation, fd.shadow)
            : null,
      ),
      child: child,
    );

    if (style.material == FluentMaterial.acrylic && style.blur > 0) {
      surface = ClipRRect(
        borderRadius: BorderRadius.circular(style.radius),
        clipBehavior: clipBehavior,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: style.blur, sigmaY: style.blur),
          child: surface,
        ),
      );
    }

    if (margin != null) {
      surface = Padding(padding: margin!, child: surface);
    }

    return surface;
  }
}

// ─────────────────────────────────────────────
// 7. MICA CONTAINER
//    Ambient Mica — full background tint
// ─────────────────────────────────────────────

class MicaContainer extends StatelessWidget {
  const MicaContainer({
    super.key,
    required this.child,
    this.micaTintStrength = 0.05, // subtle ambient tint
  });

  final Widget child;
  final double micaTintStrength;

  @override
  Widget build(BuildContext context) {
    final fd = FluentTheme.of(context);
    final base =
        fd.isDark ? FluentColors.darkMicaBase : FluentColors.lightMicaBase;
    final accentTint = fd.accentColor.withValues(alpha: micaTintStrength);

    return Container(
      decoration: BoxDecoration(
        color: Color.alphaBlend(accentTint, base),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: FluentTokens.micaBlur, sigmaY: FluentTokens.micaBlur),
        child: child,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 8. FLUENT CARD
// ─────────────────────────────────────────────

class FluentCard extends StatefulWidget {
  const FluentCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(FluentTokens.spacing16),
    this.margin = EdgeInsets.zero,
    this.style = FluentStyle.card,
    this.width,
    this.height,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final FluentStyle style;
  final double? width;
  final double? height;

  @override
  State<FluentCard> createState() => _FluentCardState();
}

class _FluentCardState extends State<FluentCard> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final fd = FluentTheme.of(context);
    final isDark = fd.isDark;
    final accent = fd.accentColor;

    final baseColor = isDark
        ? FluentColors.darkSolidSecondary.withValues(alpha: 0.60)
        : FluentColors.lightSolidBase.withValues(alpha: 0.80);

    final hoverColor = isDark
        ? FluentColors.darkSolidTertiary.withValues(alpha: 0.70)
        : FluentColors.lightSolidSecondary.withValues(alpha: 0.90);

    final pressedColor = isDark
        ? FluentColors.darkFillColorTertiary.withValues(alpha: 0.80)
        : FluentColors.lightFillColorSecondary.withValues(alpha: 0.90);

    final surfaceColor = _pressed
        ? pressedColor
        : _hovered
            ? hoverColor
            : baseColor;

    final strokeColor = _hovered && widget.style.enableRevealHighlight
        ? accent.withValues(alpha: 0.35)
        : (isDark ? FluentColors.darkStroke : FluentColors.lightStroke);

    return Padding(
      padding: widget.margin,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor:
            widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: FluentTokens.durationExecute,
            curve: FluentTokens.curveStandard,
            width: widget.width,
            height: widget.height,
            padding: widget.padding,
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(widget.style.radius),
              border: Border.all(
                  color: strokeColor, width: FluentTokens.strokeWidthThin),
              boxShadow: widget.style.enableShadow
                  ? FluentWindowsTheme._buildShadow(
                      _hovered
                          ? widget.style.shadowElevation * 1.5
                          : widget.style.shadowElevation,
                      fd.shadow,
                    )
                  : null,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 9. FLUENT BUTTON (accent / standard / subtle)
// ─────────────────────────────────────────────

enum _FluentButtonVariant { accent, standard, subtle }

class FluentButton extends StatefulWidget {
  const FluentButton({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
  }) : _variant = _FluentButtonVariant.standard;

  const FluentButton.accent({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
  }) : _variant = _FluentButtonVariant.accent;

  const FluentButton.subtle({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
  }) : _variant = _FluentButtonVariant.subtle;

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isLoading;
  final bool enabled;
  final _FluentButtonVariant _variant;

  @override
  State<FluentButton> createState() => _FluentButtonState();
}

class _FluentButtonState extends State<FluentButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: FluentTokens.durationFastInvoke);
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
        CurvedAnimation(parent: _ctrl, curve: FluentTokens.curveStandard));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fd = FluentTheme.of(context);
    final isDark = fd.isDark;
    final accent = fd.accentColor;
    final enabled = widget.enabled && !widget.isLoading;

    Color bgColor;
    Color fgColor;
    Color borderColor;

    switch (widget._variant) {
      case _FluentButtonVariant.accent:
        bgColor = enabled
            ? (_hovered ? Color.lerp(accent, Colors.white, 0.15)! : accent)
            : accent.withValues(alpha: 0.20);
        fgColor = enabled ? Colors.white : Colors.white.withValues(alpha: 0.36);
        borderColor = Colors.transparent;
        break;
      case _FluentButtonVariant.standard:
        bgColor = enabled
            ? (_hovered
                ? (isDark
                    ? FluentColors.darkFillColorTertiary
                    : FluentColors.lightFillColorSecondary)
                : (isDark
                    ? FluentColors.darkFillColorSubtle
                    : FluentColors.lightFillColorSubtle))
            : (isDark
                ? FluentColors.darkFillColorSubtle.withValues(alpha: 0.4)
                : FluentColors.lightFillColorSubtle.withValues(alpha: 0.4));
        fgColor = enabled ? fd.textPrimary : fd.textDisabled;
        borderColor =
            isDark ? FluentColors.darkStroke : FluentColors.lightStroke;
        break;
      case _FluentButtonVariant.subtle:
        bgColor = enabled && _hovered
            ? (isDark
                ? FluentColors.darkFillColorSubtle
                : FluentColors.lightFillColorSubtle)
            : Colors.transparent;
        fgColor = enabled ? fd.textPrimary : fd.textDisabled;
        borderColor = Colors.transparent;
        break;
    }

    return MouseRegion(
      onEnter: (_) {
        if (enabled) setState(() => _hovered = true);
      },
      onExit: (_) => setState(() => _hovered = false),
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      child: GestureDetector(
        onTapDown: (_) {
          if (enabled) _ctrl.forward();
        },
        onTapUp: (_) {
          _ctrl.reverse();
          if (enabled) widget.onTap?.call();
        },
        onTapCancel: () => _ctrl.reverse(),
        child: AnimatedBuilder(
          animation: _scale,
          builder: (_, child) =>
              Transform.scale(scale: _scale.value, child: child),
          child: AnimatedContainer(
            duration: FluentTokens.durationExecute,
            curve: FluentTokens.curveStandard,
            height: FluentTokens.controlHeightMD,
            padding:
                const EdgeInsets.symmetric(horizontal: FluentTokens.spacing12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(FluentTokens.radiusSM),
              border: Border.all(
                  color: borderColor, width: FluentTokens.strokeWidthThin),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.isLoading) ...[
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                    ),
                  ),
                  const SizedBox(width: FluentTokens.spacing8),
                ] else if (widget.icon != null) ...[
                  Icon(widget.icon, color: fgColor, size: 16),
                  const SizedBox(width: FluentTokens.spacing8),
                ],
                Text(
                  widget.label,
                  style: TextStyle(
                    fontFamily: 'Segoe UI Variable',
                    fontFamilyFallback: const ['Segoe UI', 'Roboto'],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: fgColor,
                    letterSpacing: 0.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 10. FLUENT TEXT FIELD
//     Fluent bottom-accent stroke on focus
// ─────────────────────────────────────────────

class FluentTextField extends StatefulWidget {
  const FluentTextField({
    super.key,
    this.controller,
    this.hint,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.maxLines = 1,
    this.errorText,
  });

  final TextEditingController? controller;
  final String? hint;
  final String? label;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String? errorText;

  @override
  State<FluentTextField> createState() => _FluentTextFieldState();
}

class _FluentTextFieldState extends State<FluentTextField> {
  final _focus = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() => _focused = _focus.hasFocus));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fd = FluentTheme.of(context);
    final isDark = fd.isDark;
    final accent = fd.accentColor;
    final hasError = widget.errorText != null;

    final fillColor = isDark
        ? (_focused
            ? FluentColors.darkFillColorSecondary
            : FluentColors.darkFillColorSubtle)
        : (_focused
            ? FluentColors.lightSolidBase
            : FluentColors.lightSolidSecondary);

    final topBorderColor = hasError
        ? FluentColors.systemRed
        : (_focused
            ? accent.withValues(alpha: 0.50)
            : (isDark ? FluentColors.darkStroke : FluentColors.lightStroke));

    final bottomBorderColor = hasError
        ? FluentColors.systemRed
        : (_focused
            ? accent
            : (isDark ? FluentColors.darkStroke : FluentColors.lightStroke));

    final bottomBorderWidth = _focused || hasError ? 2.0 : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontFamily: 'Segoe UI Variable',
              fontFamilyFallback: const ['Segoe UI', 'Roboto'],
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: fd.textPrimary,
            ),
          ),
          const SizedBox(height: FluentTokens.spacing4),
        ],
        AnimatedContainer(
          duration: FluentTokens.durationExecute,
          curve: FluentTokens.curveStandard,
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(FluentTokens.radiusSM),
            border: Border(
              top: BorderSide(color: topBorderColor, width: 1.0),
              left: BorderSide(color: topBorderColor, width: 1.0),
              right: BorderSide(color: topBorderColor, width: 1.0),
              bottom: BorderSide(
                  color: bottomBorderColor, width: bottomBorderWidth),
            ),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focus,
            obscureText: widget.obscureText,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            style: TextStyle(
              fontFamily: 'Segoe UI Variable',
              fontFamilyFallback: const ['Segoe UI', 'Roboto'],
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: fd.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(
                fontFamily: 'Segoe UI Variable',
                fontFamilyFallback: const ['Segoe UI', 'Roboto'],
                fontSize: 14,
                color: fd.textTertiary,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, size: 16, color: fd.textSecondary)
                  : null,
              suffixIcon: widget.suffixIcon,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: FluentTokens.spacing12,
                vertical: FluentTokens.spacing8,
              ),
              isDense: true,
              filled: false,
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: FluentTokens.spacing4),
          Row(
            children: [
              const Icon(Icons.error_outline,
                  size: 12, color: FluentColors.systemRed),
              const SizedBox(width: FluentTokens.spacing4),
              Text(
                widget.errorText!,
                style: const TextStyle(
                  fontFamily: 'Segoe UI Variable',
                  fontSize: 12,
                  color: FluentColors.systemRed,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────
// 11. FLUENT NAV PANE
//     Compact rail + labels + header branding
// ─────────────────────────────────────────────

class FluentNavItem {
  const FluentNavItem({
    required this.icon,
    required this.label,
    this.selectedIcon,
  });

  final IconData icon;
  final String label;
  final IconData? selectedIcon;
}

class FluentNavPane extends StatefulWidget {
  const FluentNavPane({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.header,
    this.footer,
    this.expanded = false,
  });

  final List<FluentNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Widget? header;
  final Widget? footer;
  final bool expanded;

  @override
  State<FluentNavPane> createState() => _FluentNavPaneState();
}

class _FluentNavPaneState extends State<FluentNavPane> {
  int? _hovered;

  @override
  Widget build(BuildContext context) {
    final fd = FluentTheme.of(context);
    final isDark = fd.isDark;
    final accent = fd.accentColor;
    final width = widget.expanded ? 220.0 : 48.0;

    return AnimatedContainer(
      duration: FluentTokens.durationEnterContent,
      curve: FluentTokens.curveDecelerateMax,
      width: width,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            color: isDark
                ? FluentColors.darkAcrylicTint.withValues(alpha: 0.80)
                : FluentColors.lightAcrylicTint.withValues(alpha: 0.70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.header != null) ...[
                  Padding(
                    padding: const EdgeInsets.all(FluentTokens.spacing8),
                    child: widget.header!,
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: isDark
                        ? FluentColors.darkStroke
                        : FluentColors.lightStroke,
                  ),
                ],
                const SizedBox(height: FluentTokens.spacing8),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: widget.items.length,
                    itemBuilder: (context, i) {
                      final item = widget.items[i];
                      final selected = i == widget.currentIndex;
                      final hovered = _hovered == i;

                      final icon = selected && item.selectedIcon != null
                          ? item.selectedIcon!
                          : item.icon;

                      final bgColor = selected
                          ? accent.withValues(alpha: isDark ? 0.18 : 0.12)
                          : hovered
                              ? (isDark
                                  ? FluentColors.darkFillColorSubtle
                                  : FluentColors.lightFillColorSubtle)
                              : Colors.transparent;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: FluentTokens.spacing4,
                          vertical: FluentTokens.spacing2,
                        ),
                        child: MouseRegion(
                          onEnter: (_) => setState(() => _hovered = i),
                          onExit: (_) => setState(() => _hovered = null),
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => widget.onTap(i),
                            child: AnimatedContainer(
                              duration: FluentTokens.durationExecute,
                              height: FluentTokens.controlHeightLG,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: FluentTokens.spacing8),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(
                                    FluentTokens.radiusSM),
                              ),
                              child: Row(
                                children: [
                                  // Selection indicator bar
                                  AnimatedContainer(
                                    duration: FluentTokens.durationExecute,
                                    width: 3,
                                    height: selected ? 16 : 0,
                                    decoration: BoxDecoration(
                                      color: accent,
                                      borderRadius: BorderRadius.circular(
                                          FluentTokens.radiusFull),
                                    ),
                                  ),
                                  const SizedBox(width: FluentTokens.spacing8),
                                  Icon(
                                    icon,
                                    size: 16,
                                    color: selected ? accent : fd.textSecondary,
                                  ),
                                  if (widget.expanded) ...[
                                    const SizedBox(
                                        width: FluentTokens.spacing12),
                                    Expanded(
                                      child: Text(
                                        item.label,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Segoe UI Variable',
                                          fontFamilyFallback: const [
                                            'Segoe UI',
                                            'Roboto'
                                          ],
                                          fontSize: 14,
                                          fontWeight: selected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          color: selected
                                              ? accent
                                              : fd.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (widget.footer != null) ...[
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: isDark
                        ? FluentColors.darkStroke
                        : FluentColors.lightStroke,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(FluentTokens.spacing8),
                    child: widget.footer!,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 12. FLUENT COMMAND BAR
//     Windows toolbar with icon buttons + overflow
// ─────────────────────────────────────────────

class FluentCommandItem {
  const FluentCommandItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.enabled = true,
  });

  final IconData label2 = Icons.more_horiz;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool enabled;
}

class FluentCommandBar extends StatelessWidget {
  const FluentCommandBar({
    super.key,
    required this.items,
    this.alignment = MainAxisAlignment.start,
  });

  final List<FluentCommandItem> items;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final fd = FluentTheme.of(context);
    final isDark = fd.isDark;

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: FluentTokens.spacing8),
      decoration: BoxDecoration(
        color: isDark
            ? FluentColors.darkAcrylicTint.withValues(alpha: 0.75)
            : FluentColors.lightAcrylicTint.withValues(alpha: 0.85),
        border: Border(
          bottom: BorderSide(
            color: isDark ? FluentColors.darkStroke : FluentColors.lightStroke,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: alignment,
        children: items.map((item) => _CommandBarButton(item: item)).toList(),
      ),
    );
  }
}

class _CommandBarButton extends StatefulWidget {
  const _CommandBarButton({required this.item});
  final FluentCommandItem item;

  @override
  State<_CommandBarButton> createState() => _CommandBarButtonState();
}

class _CommandBarButtonState extends State<_CommandBarButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final fd = FluentTheme.of(context);
    final isDark = fd.isDark;
    final enabled = widget.item.enabled;

    return Tooltip(
      message: widget.item.label,
      child: MouseRegion(
        onEnter: (_) {
          if (enabled) setState(() => _hovered = true);
        },
        onExit: (_) => setState(() => _hovered = false),
        cursor:
            enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
        child: GestureDetector(
          onTap: enabled ? widget.item.onTap : null,
          child: AnimatedContainer(
            duration: FluentTokens.durationExecute,
            width: 36,
            height: 32,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: _hovered
                  ? (isDark
                      ? FluentColors.darkFillColorSubtle
                      : FluentColors.lightFillColorSubtle)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(FluentTokens.radiusSM),
            ),
            child: Icon(
              widget.item.icon,
              size: 16,
              color: enabled ? fd.textPrimary : fd.textDisabled,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 13. FLUENT DIALOG
//     Windows ContentDialog equivalent
// ─────────────────────────────────────────────

class FluentDialog extends StatelessWidget {
  const FluentDialog({
    super.key,
    this.title,
    required this.content,
    this.primaryAction,
    this.primaryLabel,
    this.secondaryAction,
    this.secondaryLabel,
    this.closeAction,
  });

  final String? title;
  final Widget content;
  final VoidCallback? primaryAction;
  final String? primaryLabel;
  final VoidCallback? secondaryAction;
  final String? secondaryLabel;
  final VoidCallback? closeAction;

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget content,
    VoidCallback? primaryAction,
    String? primaryLabel,
    VoidCallback? secondaryAction,
    String? secondaryLabel,
  }) {
    return showDialog<T>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.40),
      builder: (_) => FluentDialog(
        title: title,
        content: content,
        primaryAction: primaryAction,
        primaryLabel: primaryLabel,
        secondaryAction: secondaryAction,
        secondaryLabel: secondaryLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fd = FluentTheme.of(context);
    final isDark = fd.isDark;
    // ignore: unused_local_variable
    final accent = fd.accentColor;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(FluentTokens.radiusLG),
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: FluentTokens.acrylicBlurLG,
              sigmaY: FluentTokens.acrylicBlurLG),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440, minWidth: 280),
            decoration: BoxDecoration(
              color: isDark
                  ? FluentColors.darkSolidSecondary.withValues(alpha: 0.90)
                  : FluentColors.lightSolidBase.withValues(alpha: 0.90),
              borderRadius: BorderRadius.circular(FluentTokens.radiusLG),
              border: Border.all(
                color:
                    isDark ? FluentColors.darkStroke : FluentColors.lightStroke,
                width: FluentTokens.strokeWidthThin,
              ),
              boxShadow: FluentWindowsTheme._buildShadow(
                  FluentTokens.shadowXL, fd.shadow),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    FluentTokens.spacing24,
                    FluentTokens.spacing20,
                    FluentTokens.spacing24,
                    FluentTokens.spacing12,
                  ),
                  child: Row(
                    children: [
                      if (title != null)
                        Expanded(
                          child: Text(
                            title!,
                            style: TextStyle(
                              fontFamily: 'Segoe UI Variable',
                              fontFamilyFallback: const ['Segoe UI', 'Roboto'],
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: fd.textPrimary,
                            ),
                          ),
                        ),
                      if (closeAction != null)
                        GestureDetector(
                          onTap:
                              closeAction ?? () => Navigator.of(context).pop(),
                          child: Icon(Icons.close,
                              size: 16, color: fd.textSecondary),
                        ),
                    ],
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    FluentTokens.spacing24,
                    0,
                    FluentTokens.spacing24,
                    FluentTokens.spacing20,
                  ),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontFamily: 'Segoe UI Variable',
                      fontFamilyFallback: const ['Segoe UI', 'Roboto'],
                      fontSize: 14,
                      color: fd.textSecondary,
                      height: 1.5,
                    ),
                    child: content,
                  ),
                ),

                // Divider
                Divider(
                  height: 1,
                  thickness: 1,
                  color: isDark
                      ? FluentColors.darkStroke
                      : FluentColors.lightStroke,
                ),

                // Actions
                Padding(
                  padding: const EdgeInsets.all(FluentTokens.spacing16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (secondaryAction != null)
                        FluentButton(
                          label: secondaryLabel ?? 'Cancel',
                          onTap: secondaryAction,
                        ),
                      if (secondaryAction != null && primaryAction != null)
                        const SizedBox(width: FluentTokens.spacing8),
                      if (primaryAction != null)
                        FluentButton.accent(
                          label: primaryLabel ?? 'OK',
                          onTap: primaryAction,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 14. FLUENT TOGGLE SWITCH
// ─────────────────────────────────────────────

class FluentToggleSwitch extends StatefulWidget {
  const FluentToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.enabled = true,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;
  final bool enabled;

  @override
  State<FluentToggleSwitch> createState() => _FluentToggleSwitchState();
}

class _FluentToggleSwitchState extends State<FluentToggleSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _position;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: FluentTokens.durationExecute,
      value: widget.value ? 1.0 : 0.0,
    );
    _position =
        CurvedAnimation(parent: _ctrl, curve: FluentTokens.curveStandard);
  }

  @override
  void didUpdateWidget(FluentToggleSwitch old) {
    super.didUpdateWidget(old);
    if (widget.value != old.value) {
      widget.value ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fd = FluentTheme.of(context);
    final isDark = fd.isDark;
    final accent = fd.accentColor;

    final trackOn = accent;
    final trackOff = isDark
        ? FluentColors.darkFillColorSecondary
        : FluentColors.lightSolidQuarternary;
    final strokeOff =
        isDark ? FluentColors.darkStroke : FluentColors.lightStroke;

    return MouseRegion(
      onEnter: (_) {
        if (widget.enabled) setState(() => _hovered = true);
      },
      onExit: (_) => setState(() => _hovered = false),
      cursor: widget.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
      child: GestureDetector(
        onTap: widget.enabled ? () => widget.onChanged(!widget.value) : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _position,
              builder: (_, __) {
                final t = _position.value;
                final track = Color.lerp(trackOff, trackOn, t)!;
                final thumb = Colors.white;

                return Container(
                  width: 40,
                  height: 20,
                  decoration: BoxDecoration(
                    color: track,
                    borderRadius:
                        BorderRadius.circular(FluentTokens.radiusFull),
                    border: widget.value
                        ? null
                        : Border.all(
                            color: strokeOff,
                            width: FluentTokens.strokeWidthThin),
                  ),
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        duration: FluentTokens.durationExecute,
                        curve: FluentTokens.curveStandard,
                        left: widget.value ? 22.0 : 2.0,
                        top: 2.0,
                        child: AnimatedContainer(
                          duration: FluentTokens.durationExecute,
                          width: _hovered ? 18 : 16,
                          height: _hovered ? 18 : 16,
                          decoration: BoxDecoration(
                            color: thumb,
                            borderRadius:
                                BorderRadius.circular(FluentTokens.radiusFull),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.14),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            if (widget.label != null) ...[
              const SizedBox(width: FluentTokens.spacing8),
              Text(
                widget.label!,
                style: TextStyle(
                  fontFamily: 'Segoe UI Variable',
                  fontFamilyFallback: const ['Segoe UI', 'Roboto'],
                  fontSize: 14,
                  color: widget.enabled ? fd.textPrimary : fd.textDisabled,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 15. FLUENT CHIP (Tag)
// ─────────────────────────────────────────────

class FluentChip extends StatelessWidget {
  const FluentChip({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.onDeleted,
    this.selected = false,
    this.color,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final bool selected;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final fd = FluentTheme.of(context);
    final isDark = fd.isDark;
    final accent = color ?? fd.accentColor;

    final bgColor = selected
        ? accent.withValues(alpha: 0.14)
        : (isDark
            ? FluentColors.darkFillColorSubtle
            : FluentColors.lightFillColorSubtle);

    final borderColor = selected
        ? accent.withValues(alpha: 0.40)
        : (isDark ? FluentColors.darkStroke : FluentColors.lightStroke);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: FluentTokens.durationExecute,
        padding: const EdgeInsets.symmetric(
          horizontal: FluentTokens.spacing8,
          vertical: FluentTokens.spacing4,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(FluentTokens.radiusSM),
          border: Border.all(
              color: borderColor, width: FluentTokens.strokeWidthThin),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12, color: selected ? accent : fd.textSecondary),
              const SizedBox(width: FluentTokens.spacing4),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Segoe UI Variable',
                fontFamilyFallback: const ['Segoe UI', 'Roboto'],
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? accent : fd.textPrimary,
              ),
            ),
            if (onDeleted != null) ...[
              const SizedBox(width: FluentTokens.spacing4),
              GestureDetector(
                onTap: onDeleted,
                child: Icon(Icons.close, size: 12, color: fd.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 16. FLUENT LIST TILE
//     Windows settings-style row with separator
// ─────────────────────────────────────────────

class FluentListTile extends StatefulWidget {
  const FluentListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.showSeparator = true,
    this.isFirst = false,
    this.isLast = false,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showSeparator;
  final bool isFirst;
  final bool isLast;

  @override
  State<FluentListTile> createState() => _FluentListTileState();
}

class _FluentListTileState extends State<FluentListTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final fd = FluentTheme.of(context);
    final isDark = fd.isDark;

    final topLeft = widget.isFirst
        ? const Radius.circular(FluentTokens.radiusMD)
        : Radius.zero;
    final topRight = widget.isFirst
        ? const Radius.circular(FluentTokens.radiusMD)
        : Radius.zero;
    final bottomLeft = widget.isLast
        ? const Radius.circular(FluentTokens.radiusMD)
        : Radius.zero;
    final bottomRight = widget.isLast
        ? const Radius.circular(FluentTokens.radiusMD)
        : Radius.zero;

    final baseColor = isDark
        ? FluentColors.darkSolidSecondary.withValues(alpha: 0.55)
        : FluentColors.lightSolidBase.withValues(alpha: 0.75);

    final hoverColor = isDark
        ? FluentColors.darkSolidTertiary.withValues(alpha: 0.65)
        : FluentColors.lightSolidSecondary.withValues(alpha: 0.85);

    return MouseRegion(
      onEnter: (_) {
        if (widget.onTap != null) setState(() => _hovered = true);
      },
      onExit: (_) => setState(() => _hovered = false),
      cursor:
          widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: FluentTokens.durationExecute,
          decoration: BoxDecoration(
            color: _hovered ? hoverColor : baseColor,
            borderRadius: BorderRadius.only(
              topLeft: topLeft,
              topRight: topRight,
              bottomLeft: bottomLeft,
              bottomRight: bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: FluentTokens.spacing12,
                  vertical: FluentTokens.spacing12,
                ),
                child: Row(
                  children: [
                    if (widget.leading != null) ...[
                      widget.leading!,
                      const SizedBox(width: FluentTokens.spacing12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontFamily: 'Segoe UI Variable',
                              fontFamilyFallback: const ['Segoe UI', 'Roboto'],
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: fd.textPrimary,
                            ),
                          ),
                          if (widget.subtitle != null) ...[
                            const SizedBox(height: FluentTokens.spacing2),
                            Text(
                              widget.subtitle!,
                              style: TextStyle(
                                fontFamily: 'Segoe UI Variable',
                                fontFamilyFallback: const [
                                  'Segoe UI',
                                  'Roboto'
                                ],
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: fd.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    widget.trailing ??
                        (widget.onTap != null
                            ? Icon(Icons.chevron_right,
                                size: 16, color: fd.textTertiary)
                            : const SizedBox.shrink()),
                  ],
                ),
              ),
              if (!widget.isLast && widget.showSeparator)
                Padding(
                  padding: const EdgeInsets.only(left: FluentTokens.spacing12),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: isDark
                        ? FluentColors.darkStroke
                        : FluentColors.lightStroke,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 17. FLUENT SECTION HEADER
// ─────────────────────────────────────────────

class FluentSectionHeader extends StatelessWidget {
  const FluentSectionHeader({
    super.key,
    required this.title,
    this.action,
  });

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final fd = FluentTheme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        FluentTokens.spacing4,
        FluentTokens.spacing20,
        FluentTokens.spacing4,
        FluentTokens.spacing8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Segoe UI Variable',
              fontFamilyFallback: const ['Segoe UI', 'Roboto'],
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: fd.textSecondary,
              letterSpacing: 0.3,
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 18. FLUENT ICON BUTTON
//     Compact toolbar / action button
// ─────────────────────────────────────────────

class FluentIconButton extends StatefulWidget {
  const FluentIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 32.0,
    this.iconSize = 16.0,
    this.color,
    this.tooltip,
    this.enabled = true,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final Color? color;
  final String? tooltip;
  final bool enabled;

  @override
  State<FluentIconButton> createState() => _FluentIconButtonState();
}

class _FluentIconButtonState extends State<FluentIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: FluentTokens.durationFastInvoke);
    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(
        CurvedAnimation(parent: _ctrl, curve: FluentTokens.curveStandard));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fd = FluentTheme.of(context);
    final isDark = fd.isDark;
    final iconColor = widget.color ?? fd.textPrimary;

    Widget btn = MouseRegion(
      onEnter: (_) {
        if (widget.enabled) setState(() => _hovered = true);
      },
      onExit: (_) => setState(() => _hovered = false),
      cursor: widget.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
      child: GestureDetector(
        onTapDown: (_) {
          if (widget.enabled) _ctrl.forward();
        },
        onTapUp: (_) {
          _ctrl.reverse();
          if (widget.enabled) widget.onTap();
        },
        onTapCancel: () => _ctrl.reverse(),
        child: AnimatedBuilder(
          animation: _scale,
          builder: (_, child) =>
              Transform.scale(scale: _scale.value, child: child),
          child: AnimatedContainer(
            duration: FluentTokens.durationExecute,
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: _hovered
                  ? (isDark
                      ? FluentColors.darkFillColorSubtle
                      : FluentColors.lightFillColorSubtle)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(FluentTokens.radiusSM),
            ),
            child: Icon(
              widget.icon,
              size: widget.iconSize,
              color: widget.enabled ? iconColor : fd.textDisabled,
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      btn = Tooltip(message: widget.tooltip!, child: btn);
    }

    return btn;
  }
}

// ─────────────────────────────────────────────
// 19. FLUENT BOTTOM SHEET (Task pane / Pane)
// ─────────────────────────────────────────────

class FluentSheet extends StatelessWidget {
  const FluentSheet({
    super.key,
    required this.child,
    this.title,
    this.showHandle = true,
  });

  final Widget child;
  final String? title;
  final bool showHandle;

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.40),
      builder: (_) => FluentSheet(title: title, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fd = FluentTheme.of(context);
    final isDark = fd.isDark;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(FluentTokens.radiusLG),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? FluentColors.darkSolidBase.withValues(alpha: 0.90)
                : FluentColors.lightSolidBase.withValues(alpha: 0.92),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(FluentTokens.radiusLG),
            ),
            border: Border(
              top: BorderSide(
                color:
                    isDark ? FluentColors.darkStroke : FluentColors.lightStroke,
                width: FluentTokens.strokeWidthThin,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showHandle) ...[
                  const SizedBox(height: FluentTokens.spacing12),
                  Container(
                    width: 32,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark
                          ? FluentColors.darkStrokeStrong
                          : FluentColors.lightStrokeStrong,
                      borderRadius:
                          BorderRadius.circular(FluentTokens.radiusFull),
                    ),
                  ),
                ],
                if (title != null) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      FluentTokens.spacing20,
                      FluentTokens.spacing16,
                      FluentTokens.spacing20,
                      FluentTokens.spacing4,
                    ),
                    child: Row(
                      children: [
                        Text(
                          title!,
                          style: TextStyle(
                            fontFamily: 'Segoe UI Variable',
                            fontFamilyFallback: const ['Segoe UI', 'Roboto'],
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: fd.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    FluentTokens.spacing16,
                    title != null
                        ? FluentTokens.spacing8
                        : FluentTokens.spacing16,
                    FluentTokens.spacing16,
                    FluentTokens.spacing16 +
                        MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 20. EXTENSION: BuildContext helpers
// ─────────────────────────────────────────────

extension FluentContextExtension on BuildContext {
  FluentThemeData get fluentTheme => FluentTheme.of(this);
  bool get isDarkFluent => FluentTheme.of(this).isDark;
  Color get fluentAccent => FluentTheme.of(this).accentColor;

  Future<T?> showFluentSheet<T>({required Widget child, String? title}) =>
      FluentSheet.show<T>(context: this, child: child, title: title);

  Future<T?> showFluentDialog<T>({
    String? title,
    required Widget content,
    VoidCallback? primaryAction,
    String? primaryLabel,
    VoidCallback? secondaryAction,
    String? secondaryLabel,
  }) =>
      FluentDialog.show<T>(
        context: this,
        title: title,
        content: content,
        primaryAction: primaryAction,
        primaryLabel: primaryLabel,
        secondaryAction: secondaryAction,
        secondaryLabel: secondaryLabel,
      );
}
