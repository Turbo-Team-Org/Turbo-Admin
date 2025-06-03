import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum TurboLogoType { svg, png }

/// Widget del logo oficial de Turbo
class TurboLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? primaryColor;
  final Color? secondaryColor;
  final TurboLogoType type;

  const TurboLogo({
    super.key,
    this.width,
    this.height,
    this.primaryColor,
    this.secondaryColor,
    this.type = TurboLogoType.svg,
  });

  /// Constructor para logo SVG (por defecto)
  const TurboLogo.svg({
    super.key,
    this.width,
    this.height,
    this.primaryColor,
    this.secondaryColor,
  }) : type = TurboLogoType.svg;

  /// Constructor para logo PNG
  const TurboLogo.png({
    super.key,
    this.width,
    this.height,
    this.primaryColor,
    this.secondaryColor,
  }) : type = TurboLogoType.png;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TurboLogoType.svg:
        return SvgPicture.asset(
          'assets/images/Turbo Marca 7.svg',
          width: width ?? 120,
          height:
              height ?? 88, // Mantiene la proporción del SVG original (375x275)
          colorFilter: const ColorFilter.mode(
            Color.fromARGB(255, 236, 64, 52),
            BlendMode.srcIn,
          ),
        );
      case TurboLogoType.png:
        return Image.asset(
          'assets/images/app_icon.png',
          width: width ?? 120,
          height: height ?? 120, // El PNG es cuadrado
          color: primaryColor,
          colorBlendMode: primaryColor != null ? BlendMode.srcIn : null,
        );
    }
  }
}

/// Widget del logo pequeño de Turbo para el sidebar
class TurboLogoSmall extends StatelessWidget {
  final double size;
  final TurboLogoType type;
  final bool useContainer;

  const TurboLogoSmall({
    super.key,
    this.size = 40,
    this.type = TurboLogoType.svg,
    this.useContainer = true,
  });

  /// Constructor con contenedor de gradiente (recomendado para sidebar)
  const TurboLogoSmall.withContainer({
    super.key,
    this.size = 40,
    this.type = TurboLogoType.svg,
  }) : useContainer = true;

  /// Constructor sin contenedor (logo directo)
  const TurboLogoSmall.direct({
    super.key,
    this.size = 40,
    this.type = TurboLogoType.svg,
  }) : useContainer = false;

  @override
  Widget build(BuildContext context) {
    final logoWidget = type == TurboLogoType.svg
        ? SvgPicture.asset(
            'assets/images/Turbo Marca 1.svg',
            width: useContainer ? size * 0.7 : size,
            height: useContainer ? size * 0.7 : size,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          )
        : Image.asset(
            'assets/images/app_icon.png',
            width: useContainer ? size * 0.7 : size,
            height: useContainer ? size * 0.7 : size,
            color: Colors.white,
            colorBlendMode: BlendMode.srcIn,
          );

    if (!useContainer) {
      return logoWidget;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE53E3E), // Color rojo de Turbo
            Color(0xFFFF6B35),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE53E3E).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(child: logoWidget),
    );
  }
}

/// Widget de logo animado para splash screens
class TurboLogoAnimated extends StatefulWidget {
  final double? width;
  final double? height;
  final TurboLogoType type;
  final Duration animationDuration;

  const TurboLogoAnimated({
    super.key,
    this.width,
    this.height,
    this.type = TurboLogoType.svg,
    this.animationDuration = const Duration(seconds: 2),
  });

  @override
  State<TurboLogoAnimated> createState() => _TurboLogoAnimatedState();
}

class _TurboLogoAnimatedState extends State<TurboLogoAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: TurboLogo(
              width: widget.width,
              height: widget.height,
              type: widget.type,
            ),
          ),
        );
      },
    );
  }
}
