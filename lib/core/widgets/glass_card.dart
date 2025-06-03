import 'package:flutter/material.dart';
import 'dart:ui';

/// Card con glassmorphism premium para profundidad visual
class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double blurAmount;
  final List<BoxShadow>? customShadows;
  final VoidCallback? onTap;
  final bool enableHover;
  final double? width;
  final double? height;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 20,
    this.backgroundColor,
    this.borderColor,
    this.blurAmount = 10,
    this.customShadows,
    this.onTap,
    this.enableHover = true,
    this.width,
    this.height,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _elevationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    if (!widget.enableHover) return;

    setState(() {
      _isHovered = isHovered;
    });

    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return MouseRegion(
          onEnter: (_) => _handleHover(true),
          onExit: (_) => _handleHover(false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: widget.width,
                height: widget.height,
                margin: widget.margin,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  boxShadow: widget.customShadows ??
                      [
                        BoxShadow(
                          offset:
                              Offset(0, 4 + (_elevationAnimation.value * 8)),
                          blurRadius: 20 + (_elevationAnimation.value * 10),
                          color: isDark
                              ? const Color(0xFFFF5757).withOpacity(
                                  0.1 + (_elevationAnimation.value * 0.1))
                              : const Color(0xFFE53E3E).withOpacity(
                                  0.1 + (_elevationAnimation.value * 0.1)),
                        ),
                        if (_isHovered)
                          BoxShadow(
                            offset: const Offset(0, 8),
                            blurRadius: 40,
                            color: isDark
                                ? const Color(0xFFFF5757).withOpacity(0.2)
                                : const Color(0xFFE53E3E).withOpacity(0.2),
                          ),
                      ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: widget.blurAmount,
                      sigmaY: widget.blurAmount,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [
                                  (widget.backgroundColor ??
                                          const Color(0xFF1A1B3A))
                                      .withOpacity(0.8 +
                                          (_elevationAnimation.value * 0.1)),
                                  (widget.backgroundColor ??
                                          const Color(0xFF2D2D4A))
                                      .withOpacity(0.6 +
                                          (_elevationAnimation.value * 0.1)),
                                ]
                              : [
                                  (widget.backgroundColor ?? Colors.white)
                                      .withOpacity(0.9 +
                                          (_elevationAnimation.value * 0.05)),
                                  (widget.backgroundColor ??
                                          const Color(0xFFF9FAFB))
                                      .withOpacity(0.8 +
                                          (_elevationAnimation.value * 0.05)),
                                ],
                        ),
                        border: Border.all(
                          color: widget.borderColor ??
                              (isDark
                                  ? const Color(0xFFFF5757).withOpacity(
                                      0.2 + (_elevationAnimation.value * 0.1))
                                  : const Color(0xFFE53E3E).withOpacity(
                                      0.2 + (_elevationAnimation.value * 0.1))),
                          width: 1,
                        ),
                      ),
                      child: Container(
                        padding: widget.padding ?? const EdgeInsets.all(24),
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Card especializada para métricas con animaciones
class MetricGlassCard extends StatefulWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final Widget? trailing;

  const MetricGlassCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.iconColor,
    this.onTap,
    this.trailing,
  });

  @override
  State<MetricGlassCard> createState() => _MetricGlassCardState();
}

class _MetricGlassCardState extends State<MetricGlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _numberAnimation;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _numberAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));

    _iconAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassCard(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icono animado
                  Transform.scale(
                    scale: _iconAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            widget.iconColor ??
                                (isDark
                                    ? const Color(0xFFFF5757)
                                    : const Color(0xFFE53E3E)),
                            (widget.iconColor ??
                                (isDark
                                    ? const Color(0xFFFF8A65)
                                    : const Color(0xFFFF6B35))),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 4),
                            blurRadius: 12,
                            color: (widget.iconColor ??
                                    (isDark
                                        ? const Color(0xFFFF5757)
                                        : const Color(0xFFE53E3E)))
                                .withOpacity(0.3),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Trailing widget
                  if (widget.trailing != null) widget.trailing!,
                ],
              ),

              const SizedBox(height: 20),

              // Título
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'MuseoSans',
                  color: isDark
                      ? const Color(0xFFA1A1AA)
                      : const Color(0xFF6B7280),
                  letterSpacing: 0.2,
                ),
              ),

              const SizedBox(height: 8),

              // Valor animado
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                tween: Tween(begin: 0.0, end: _numberAnimation.value),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: Text(
                        widget.value,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'MuseoSans',
                          color: isDark
                              ? const Color(0xFFF8FAFC)
                              : const Color(0xFF111827),
                          letterSpacing: -1,
                          height: 1.0,
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Subtítulo
              if (widget.subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  widget.subtitle!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'MuseoSans',
                    color: isDark
                        ? const Color(0xFF71717A)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
