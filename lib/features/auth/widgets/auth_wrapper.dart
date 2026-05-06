import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../cubit/admin_auth_cubit.dart';
import 'package:turbo_admin/core/widgets/turbo_logo.dart';

/// Wrapper que protege las rutas del admin panel verificando autenticación
/// TEMPORALMENTE DESHABILITADO - Permite acceso directo para desarrollo
class AuthWrapper extends StatelessWidget {
  final Widget child;

  const AuthWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminAuthCubit, AdminAuthState>(
      listener: (context, state) {
        if (state is AdminAuthUnauthenticated || state is AdminAuthError) {
          // Si no está autenticado, redirigir a login
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/login');
          });
        }
      },
      child: BlocBuilder<AdminAuthCubit, AdminAuthState>(
        builder: (context, state) {
          if (state is AdminAuthLoading || state is AdminAuthInitial) {
            return const _LoadingView();
          } else if (state is AdminAuthenticatedAdmin ||
              state is AdminAuthenticatedBusinessOwner) {
            return child;
          } else {
            // En caso de error o no autenticado, mostrar página de carga
            // El listener se encargará de redirigir
            return const _LoadingView();
          }
        },
      ),
    );
  }
}

/// Vista de carga elegante con branding Turbo
class _LoadingView extends StatelessWidget {
  const _LoadingView();

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
