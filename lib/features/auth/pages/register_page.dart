import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../cubit/admin_auth_cubit.dart';
import '../widgets/turbo_text_field.dart';
import '../widgets/turbo_button.dart';
import 'package:turbo_admin/core/widgets/turbo_logo.dart';

/// Página de registro con diseño Turbo
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _RegisterView();
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _businessDescriptionController = TextEditingController();
  final _businessAddressController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _businessNameController.dispose();
    _businessDescriptionController.dispose();
    _businessAddressController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_formKey.currentState?.validate() == true) {
      await context.read<AdminAuthCubit>().registerAndRequestBusinessOwner(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            displayName: _nameController.text.trim(),
            businessName: _businessNameController.text.trim(),
            businessDescription: _businessDescriptionController.text.trim(),
            businessAddress: _businessAddressController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: BlocListener<AdminAuthCubit, AdminAuthState>(
        listener: (context, state) {
          if (state is AdminAuthBusinessOwnerRegistered) {
            // Mostrar mensaje de éxito y navegar al dashboard de business owner
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    '¡Registro exitoso! Tu solicitud está siendo revisada.'),
                backgroundColor: Color(0xFF10B981),
              ),
            );
            context.go('/business-owner-dashboard');
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
                      // Botón de regresar
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Logo y título
                      const _Header(),
                      const SizedBox(height: 48),

                      // Botón de Google
                      TurboButton(
                        text: 'Registrarse con Google',
                        isSecondary: true,
                        icon: Image.asset(
                          'assets/images/google_logo.png',
                          width: 20,
                          height: 20,
                        ),
                        onPressed: () {
                          // TODO: Implementar registro con Google
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
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Color(0xFFD1D5DB))),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Campos de formulario
                      TurboTextField(
                        label: 'Nombre',
                        hintText: 'David García',
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu nombre';
                          }
                          if (value.length < 2) {
                            return 'El nombre debe tener al menos 2 caracteres';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      TurboTextField(
                        label: 'Email',
                        hintText: 'david@gmail.com',
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
                        label: 'Contraseña',
                        hintText: '••••••••',
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa una contraseña';
                          }
                          if (value.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
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

                      const SizedBox(height: 20),

                      TurboTextField(
                        label: 'Confirmar Contraseña',
                        hintText: '••••••••',
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor confirma tu contraseña';
                          }
                          if (value != _passwordController.text) {
                            return 'Las contraseñas no coinciden';
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFF6B7280),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Separador para información del negocio
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: const Color(0xFFE5E7EB),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                      ),

                      const Text(
                        'Información del Negocio',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'MuseoSans',
                          color: Color(0xFF374151),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TurboTextField(
                        label: 'Nombre del Negocio',
                        hintText: 'Mi Restaurante',
                        controller: _businessNameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa el nombre del negocio';
                          }
                          if (value.length < 3) {
                            return 'El nombre debe tener al menos 3 caracteres';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      TurboTextField(
                        label: 'Descripción del Negocio',
                        hintText:
                            'Restaurante de comida italiana con ambiente familiar...',
                        controller: _businessDescriptionController,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor describe tu negocio';
                          }
                          if (value.length < 20) {
                            return 'La descripción debe tener al menos 20 caracteres';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      TurboTextField(
                        label: 'Dirección del Negocio (Opcional)',
                        hintText: 'Calle 123, Ciudad, Estado',
                        controller: _businessAddressController,
                        keyboardType: TextInputType.streetAddress,
                        validator: (value) {
                          // Campo opcional, no requiere validación
                          return null;
                        },
                      ),

                      const SizedBox(height: 32),

                      // Botón de registro
                      BlocBuilder<AdminAuthCubit, AdminAuthState>(
                        builder: (context, state) {
                          return TurboButton(
                            text: 'Registrarse',
                            isLoading: state is AdminAuthLoading,
                            onPressed: _handleRegister,
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Link a login
                      RichText(
                        text: TextSpan(
                          text: '¿Ya tienes cuenta? ',
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
                                  context.go('/login');
                                },
                                child: const Text(
                                  'Iniciar Sesión',
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
    return const Column(
      children: [
        // Logo oficial de Turbo
        TurboLogo(
          width: 160,
          height: 118,
        ),

        SizedBox(height: 32),

        Text(
          'Crear Cuenta',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            fontFamily: 'MuseoSans',
            color: Color(0xFF111827),
          ),
        ),

        SizedBox(height: 8),

        Text(
          'Únete al equipo de administradores',
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
