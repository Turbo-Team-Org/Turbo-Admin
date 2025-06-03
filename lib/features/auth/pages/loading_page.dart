import 'package:flutter/material.dart';
import 'package:turbo_admin/core/widgets/turbo_logo.dart';

/// Página de carga para verificación de autenticación
class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo oficial de Turbo
            const TurboLogo.svg(
              width: 120,
              height: 88,
            ),

            const SizedBox(height: 32),

            // Título
            const Text(
              'Panel de Administración',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontFamily: 'MuseoSans',
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 16),

            // Indicador de carga personalizado
            Container(
              width: 200,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53E3E),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF6B35),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Texto de estado
            const Text(
              'Verificando credenciales...',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'MuseoSans',
                fontWeight: FontWeight.w300,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
