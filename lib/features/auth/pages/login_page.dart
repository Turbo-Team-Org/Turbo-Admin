import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../cubit/admin_auth_cubit.dart';
import '../widgets/turbo_text_field.dart';
import '../widgets/turbo_button.dart';
import 'package:turbo_admin/core/widgets/turbo_logo.dart';

/// Página de inicio de sesión con diseño Turbo
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<AdminAuthCubit>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() == true) {
      context.read<AdminAuthCubit>().signUpWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            displayName: 'Admin',
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: BlocListener<AdminAuthCubit, AdminAuthState>(
        listener: (context, state) {
          if (state is AdminAuthAuthenticated) {
            // Navegar al dashboard
            context.go('/dashboard');
          } else if (state is AdminAuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFFEF4444),
              ),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo y título
                      const _Header(),
                      const SizedBox(height: 48),

                      // Botón de Google
                      TurboButton(
                        text: 'Continuar con Google',
                        isSecondary: true,
                        icon: Image.asset(
                          'assets/images/google_logo.png',
                          width: 20,
                          height: 20,
                        ),
                        onPressed: () {
                          // TODO: Implementar login con Google
                        },
                      ),

                      const SizedBox(height: 24),

                      // Separador
                      const Row(
                        children: [
                          Expanded(child: Divider(color: Color(0xFFD1D5DB))),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'O',
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 14,
                                fontFamily: 'MuseoSans',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Color(0xFFD1D5DB))),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Campos de formulario
                      TurboTextField(
                        label: 'Email',
                        hintText: 'admin@turbo.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Por favor ingresa un email válido';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      TurboTextField(
                        label: 'Password',
                        hintText: '••••••',
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu contraseña';
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFF6B7280),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Botón de login
                      BlocBuilder<AdminAuthCubit, AdminAuthState>(
                        builder: (context, state) {
                          return TurboButton(
                            text: 'Iniciar Sesión',
                            isLoading: state is AdminAuthLoading,
                            onPressed: _handleLogin,
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Link a registro
                      RichText(
                        text: TextSpan(
                          text: '¿No tienes cuenta? ',
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 14,
                            fontFamily: 'MuseoSans',
                            fontWeight: FontWeight.w300,
                          ),
                          children: [
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  context.go('/register');
                                },
                                child: const Text(
                                  'Registrarse',
                                  style: TextStyle(
                                    color: Color(0xFFE53E3E),
                                    fontSize: 14,
                                    fontFamily: 'MuseoSans',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Información de acceso demo
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          border: Border.all(color: const Color(0xFF22C55E)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.admin_panel_settings,
                                  color: Color(0xFF15803D),
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Acceso de Administrador',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'MuseoSans',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF15803D),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Solo usuarios autorizados como dueños de lugares pueden acceder al panel',
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'MuseoSans',
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF15803D),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo oficial de Turbo (usando SVG por defecto)
        const TurboLogo.svg(
          width: 160,
          height: 118,
        ),

        const SizedBox(height: 32),

        const Text(
          'Panel de Administración',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            fontFamily: 'MuseoSans',
            color: Color(0xFF111827),
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Gestiona lugares, eventos y usuarios',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'MuseoSans',
            fontWeight: FontWeight.w300,
            color: Color(0xFF6B7280),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
