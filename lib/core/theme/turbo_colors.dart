import 'package:flutter/material.dart';

/// Paleta de colores coherente para Turbo Admin Panel
class TurboColors {
  TurboColors._();

  // === COLORES PRIMARIOS DE TURBO ===
  static const Color primary = Color(0xFFE53E3E);
  static const Color primaryDark = Color(0xFFD32F2F);
  static const Color primaryLight = Color(0xFFFF5757);

  static const Color secondary = Color(0xFFFF6B35);
  static const Color secondaryDark = Color(0xFFE65100);
  static const Color secondaryLight = Color(0xFFFF8A65);

  // === PALETA EXTENDIDA COHERENTE ===

  // Rojos (familia principal)
  static const Color red50 = Color(0xFFFEF2F2);
  static const Color red100 = Color(0xFFFDE2E2);
  static const Color red200 = Color(0xFFFBCACA);
  static const Color red300 = Color(0xFFF8A5A5);
  static const Color red400 = Color(0xFFF87171);
  static const Color red500 = Color(0xFFEF4444);
  static const Color red600 = Color(0xFFE53E3E); // Primary
  static const Color red700 = Color(0xFFD32F2F);
  static const Color red800 = Color(0xFFB71C1C);
  static const Color red900 = Color(0xFF991B1B);

  // Naranjas (familia secundaria)
  static const Color orange50 = Color(0xFFFFF7ED);
  static const Color orange100 = Color(0xFFFFEDD5);
  static const Color orange200 = Color(0xFFFED7AA);
  static const Color orange300 = Color(0xFFFFB375);
  static const Color orange400 = Color(0xFFFF8A3D);
  static const Color orange500 = Color(0xFFFF6B35); // Secondary
  static const Color orange600 = Color(0xFFEA580C);
  static const Color orange700 = Color(0xFFC2410C);
  static const Color orange800 = Color(0xFF9A3412);
  static const Color orange900 = Color(0xFF7C2D12);

  // Azules (acentos profesionales)
  static const Color blue50 = Color(0xFFEFF6FF);
  static const Color blue100 = Color(0xFFDBEAFE);
  static const Color blue200 = Color(0xFFBFDBFE);
  static const Color blue300 = Color(0xFF93C5FD);
  static const Color blue400 = Color(0xFF60A5FA);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color blue600 = Color(0xFF2563EB);
  static const Color blue700 = Color(0xFF1D4ED8);
  static const Color blue800 = Color(0xFF1E40AF);
  static const Color blue900 = Color(0xFF1E3A8A);

  // Verdes (éxito y confirmación)
  static const Color green50 = Color(0xFFF0FDF4);
  static const Color green100 = Color(0xFFDCFCE7);
  static const Color green200 = Color(0xFFBBF7D0);
  static const Color green300 = Color(0xFF86EFAC);
  static const Color green400 = Color(0xFF4ADE80);
  static const Color green500 = Color(0xFF22C55E);
  static const Color green600 = Color(0xFF16A34A);
  static const Color green700 = Color(0xFF15803D);
  static const Color green800 = Color(0xFF166534);
  static const Color green900 = Color(0xFF14532D);

  // Púrpuras (categorías y premium)
  static const Color purple50 = Color(0xFFFAF5FF);
  static const Color purple100 = Color(0xFFF3E8FF);
  static const Color purple200 = Color(0xFFE9D5FF);
  static const Color purple300 = Color(0xFFD8B4FE);
  static const Color purple400 = Color(0xFFC084FC);
  static const Color purple500 = Color(0xFFA855F7);
  static const Color purple600 = Color(0xFF9333EA);
  static const Color purple700 = Color(0xFF7C3AED);
  static const Color purple800 = Color(0xFF6B21A8);
  static const Color purple900 = Color(0xFF581C87);

  // Amarillos (advertencias)
  static const Color yellow50 = Color(0xFFFFFBEB);
  static const Color yellow100 = Color(0xFFFEF3C7);
  static const Color yellow200 = Color(0xFFFDE68A);
  static const Color yellow300 = Color(0xFFFCD34D);
  static const Color yellow400 = Color(0xFFFBBF24);
  static const Color yellow500 = Color(0xFFF59E0B);
  static const Color yellow600 = Color(0xFFD97706);
  static const Color yellow700 = Color(0xFFB45309);
  static const Color yellow800 = Color(0xFF92400E);
  static const Color yellow900 = Color(0xFF78350F);

  // === GRISES COHERENTES ===

  // Grises claros (modo light)
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  // Grises oscuros (modo dark)
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);

  // === FONDOS ESPECIALES ===

  // Fondos con gradientes para modo claro
  static const LinearGradient lightBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFEFEFE),
      Color(0xFFFEF7F7),
      Color(0xFFFDF2F2),
    ],
  );

  // Fondos con gradientes para modo oscuro
  static const LinearGradient darkBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F0F23),
      Color(0xFF1A1B3A),
      Color(0xFF1E1E3F),
    ],
  );

  // === MÉTODOS HELPER ===

  /// Obtiene el color de estado según la categoría
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'activo':
      case 'aprobado':
      case 'éxito':
        return green500;
      case 'pendiente':
      case 'advertencia':
        return yellow500;
      case 'error':
      case 'rechazado':
      case 'inactivo':
        return red500;
      case 'info':
      case 'procesando':
        return blue500;
      case 'premium':
      case 'destacado':
        return purple500;
      default:
        return gray500;
    }
  }

  /// Obtiene el gradiente de un color con sus variantes
  static LinearGradient getGradient(Color baseColor, {bool isDark = false}) {
    if (baseColor == primary) {
      return LinearGradient(
        colors: isDark ? [primaryLight, secondaryLight] : [primary, secondary],
      );
    } else if (baseColor == blue500) {
      return LinearGradient(
        colors: [blue500, blue600],
      );
    } else if (baseColor == green500) {
      return LinearGradient(
        colors: [green500, green600],
      );
    } else if (baseColor == purple500) {
      return LinearGradient(
        colors: [purple500, purple600],
      );
    } else if (baseColor == yellow500) {
      return LinearGradient(
        colors: [yellow500, orange500],
      );
    }

    // Gradiente genérico
    return LinearGradient(
      colors: [baseColor, baseColor.withOpacity(0.8)],
    );
  }

  /// Obtiene el color de superficie según el tema
  static Color getSurfaceColor(bool isDark, {double opacity = 1.0}) {
    return isDark
        ? slate800.withOpacity(opacity)
        : Colors.white.withOpacity(opacity);
  }

  /// Obtiene el color de texto según el tema
  static Color getTextColor(bool isDark, {bool isSecondary = false}) {
    if (isDark) {
      return isSecondary ? slate400 : slate50;
    } else {
      return isSecondary ? gray600 : gray900;
    }
  }

  /// Obtiene el color de borde según el tema
  static Color getBorderColor(bool isDark, {double opacity = 0.2}) {
    return isDark
        ? primaryLight.withOpacity(opacity)
        : primary.withOpacity(opacity);
  }
}

/// Extensión para facilitar el uso de colores en widgets
extension TurboColorExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get primaryColor => TurboColors.primary;
  Color get secondaryColor => TurboColors.secondary;
  Color get surfaceColor => TurboColors.getSurfaceColor(isDark);
  Color get textColor => TurboColors.getTextColor(isDark);
  Color get secondaryTextColor =>
      TurboColors.getTextColor(isDark, isSecondary: true);
  Color get borderColor => TurboColors.getBorderColor(isDark);
}
