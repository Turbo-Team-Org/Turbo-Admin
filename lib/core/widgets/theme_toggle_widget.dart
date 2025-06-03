import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/theme_service.dart';

/// Widget premium para alternar entre modo claro y oscuro
class ThemeToggleWidget extends StatefulWidget {
  final bool isCompact;

  const ThemeToggleWidget({
    super.key,
    this.isCompact = false,
  });

  @override
  State<ThemeToggleWidget> createState() => _ThemeToggleWidgetState();
}

class _ThemeToggleWidgetState extends State<ThemeToggleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _toggleAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _toggleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    // Sincronizar con el estado actual del tema
    if (ThemeService().isDarkMode) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleTheme() {
    ThemeService().toggleTheme();

    if (ThemeService().isDarkMode) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return widget.isCompact
        ? _buildCompactToggle(isDark)
        : _buildFullToggle(isDark);
  }

  Widget _buildFullToggle(bool isDark) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: _toggleTheme,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        const Color(0xFF1A1B3A).withOpacity(0.8),
                        const Color(0xFF2D2D4A).withOpacity(0.6),
                      ]
                    : [
                        Colors.white.withOpacity(0.9),
                        const Color(0xFFF9FAFB).withOpacity(0.8),
                      ],
              ),
              border: Border.all(
                color: isDark
                    ? const Color(0xFFFF5757).withOpacity(0.2)
                    : const Color(0xFFE53E3E).withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 20,
                  color: isDark
                      ? const Color(0xFFFF5757).withOpacity(0.1)
                      : const Color(0xFFE53E3E).withOpacity(0.1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Row(
                  children: [
                    // Icono del tema actual
                    Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: isDark
                                ? [
                                    const Color(0xFFFF5757),
                                    const Color(0xFFFF8A65)
                                  ]
                                : [
                                    const Color(0xFFE53E3E),
                                    const Color(0xFFFF6B35)
                                  ],
                          ),
                        ),
                        child: Icon(
                          isDark
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Texto del modo
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isDark ? 'Modo Oscuro' : 'Modo Claro',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'MuseoSans',
                              color: isDark
                                  ? const Color(0xFFF8FAFC)
                                  : const Color(0xFF111827),
                            ),
                          ),
                          Text(
                            isDark ? 'Reduce fatiga visual' : 'Máxima claridad',
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'MuseoSans',
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? const Color(0xFFA1A1AA)
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Toggle switch
                    _buildToggleSwitch(isDark),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactToggle(bool isDark) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: _toggleTheme,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        const Color(0xFF1A1B3A).withOpacity(0.8),
                        const Color(0xFF2D2D4A).withOpacity(0.6),
                      ]
                    : [
                        Colors.white.withOpacity(0.9),
                        const Color(0xFFF9FAFB).withOpacity(0.8),
                      ],
              ),
              border: Border.all(
                color: isDark
                    ? const Color(0xFFFF5757).withOpacity(0.2)
                    : const Color(0xFFE53E3E).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color:
                    isDark ? const Color(0xFFFF5757) : const Color(0xFFE53E3E),
                size: 20,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildToggleSwitch(bool isDark) {
    return AnimatedBuilder(
      animation: _toggleAnimation,
      builder: (context, child) {
        return Container(
          width: 50,
          height: 26,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFFFF5757), const Color(0xFFFF8A65)]
                  : [const Color(0xFFE53E3E), const Color(0xFFFF6B35)],
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 2),
                blurRadius: 8,
                color: isDark
                    ? const Color(0xFFFF5757).withOpacity(0.3)
                    : const Color(0xFFE53E3E).withOpacity(0.3),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                left: _toggleAnimation.value * 24 + 2,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                    size: 12,
                    color: isDark
                        ? const Color(0xFF1A1B3A)
                        : const Color(0xFFFF6B35),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
