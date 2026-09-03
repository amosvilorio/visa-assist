import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // =====================================
  // COLORES PRINCIPALES VISA ASSIST
  // =====================================

  static const Color primary = Color(0xFF082B66);

  static const Color secondary = Color(0xFF0B3D91);

  static const Color accentRed = Color(0xFFD90429);

  static const Color lightBlue = Color(0xFFE8EEF8);


  // =====================================
  // FONDOS
  // =====================================

  static const Color background = Color(0xFFF8F9FC);

  static const Color card = Colors.white;


  // =====================================
  // TEXTOS
  // =====================================

  static const Color textPrimary = Color(0xFF102A43);

  static const Color textSecondary = Color(0xFF6B7280);


  // =====================================
  // ESTADOS
  // =====================================

  static const Color success = Color(0xFF2E7D32);

  static const Color warning = Color(0xFFEF6C00);

  static const Color danger = Color(0xFFD90429);


  // =====================================
  // OTROS
  // =====================================

  static const Color border = Color(0xFFE1E5EC);

  static const Color shadow = Color(0x18000000);


  // =====================================
  // GRADIENTE PRINCIPAL
  // =====================================

  static const LinearGradient primaryGradient = LinearGradient(

    begin: Alignment.topLeft,

    end: Alignment.bottomRight,

    colors: [

      Color(0xFF041B4D),

      Color(0xFF082B66),

      Color(0xFF0B3D91),

    ],

  );

}