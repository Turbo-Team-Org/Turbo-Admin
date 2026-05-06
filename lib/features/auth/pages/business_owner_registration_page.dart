import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:turbo_admin/features/auth/cubit/admin_auth_cubit.dart';
import 'package:turbo_admin/features/auth/widgets/turbo_text_field.dart';
import 'package:turbo_admin/features/auth/widgets/turbo_button.dart';
import 'package:turbo_admin/core/widgets/turbo_logo.dart';

/// Página de registro para Business Owners
class BusinessOwnerRegistrationPage extends StatelessWidget {
  const BusinessOwnerRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _RegistrationView();
  }
}

class _RegistrationView extends StatefulWidget {
  const _RegistrationView();

  @override
  State<_RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<_RegistrationView> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentPage = 0;

  // Datos de usuario
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _displayNameController = TextEditingController();

  // Datos de negocio
  final _businessNameController = TextEditingController();
  final _businessDescriptionController = TextEditingController();
  final _businessAddressController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _websiteController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _displayNameController.dispose();
    _businessNameController.dispose();
    _businessDescriptionController.dispose();
    _businessAddressController.dispose();
    _phoneNumberController.dispose();
    _websiteController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage == 0 && _validateUserData()) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (_currentPage == 1) {
      _handleRegistration();
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool _validateUserData() {
    if (!_formKey.currentState!.validate()) return false;
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  void _handleRegistration() {
    if (_formKey.currentState?.validate() == true) {
      context.read<AdminAuthCubit>().registerAndRequestBusinessOwner(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            displayName: _displayNameController.text.trim(),
            businessName: _businessNameController.text.trim(),
            businessDescription: _businessDescriptionController.text.trim(),
            businessAddress: _businessAddressController.text.trim(),
            phoneNumber: _phoneNumberController.text.trim().isEmpty
                ? null
                : _phoneNumberController.text.trim(),
            website: _websiteController.text.trim().isEmpty
                ? null
                : _websiteController.text.trim(),
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
            // Registro exitoso → Navegar al dashboard de business owner
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
          child: Column(
            children: [
              // Header con logo y progreso
              _buildHeader(),

              // Contenido del formulario
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    _buildUserDataPage(),
                    _buildBusinessDataPage(),
                  ],
                ),
              ),

              // Botones de navegación
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Logo
          const TurboLogo.svg(
            width: 120,
            height: 88,
          ),

          const SizedBox(height: 16),

          Text(
            'Registro de Negocio',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 8),

          Text(
            'Únete a Turbo Admin y gestiona tu negocio',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),

          const SizedBox(height: 16),

          // Indicador de progreso
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: _currentPage >= 0
                        ? const Color(0xFFE53E3E)
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: _currentPage >= 1
                        ? const Color(0xFFE53E3E)
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserDataPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Datos Personales',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            TurboTextField(
              label: 'Nombre Completo',
              hintText: 'Tu nombre completo',
              controller: _displayNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu nombre completo';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TurboTextField(
              label: 'Email',
              hintText: 'tu@email.com',
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
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
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
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessDataPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Datos del Negocio',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          TurboTextField(
            label: 'Nombre del Negocio',
            hintText: 'Nombre de tu empresa o negocio',
            controller: _businessNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa el nombre del negocio';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TurboTextField(
            label: 'Descripción del Negocio',
            hintText: 'Describe brevemente tu negocio',
            controller: _businessDescriptionController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa una descripción del negocio';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TurboTextField(
            label: 'Dirección del Negocio',
            hintText: 'Dirección física del negocio',
            controller: _businessAddressController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa la dirección del negocio';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TurboTextField(
            label: 'Teléfono (Opcional)',
            hintText: '+1 234 567 8900',
            controller: _phoneNumberController,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          TurboTextField(
            label: 'Sitio Web (Opcional)',
            hintText: 'https://www.tunegocio.com',
            controller: _websiteController,
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Proceso de Aprobación',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Tu solicitud será revisada por nuestro equipo. Recibirás una notificación por email cuando sea aprobada.',
                  style: TextStyle(
                    color: Colors.blue.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          if (_currentPage > 0) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: _previousPage,
                child: const Text('Anterior'),
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            flex: _currentPage == 0 ? 1 : 1,
            child: BlocBuilder<AdminAuthCubit, AdminAuthState>(
              builder: (context, state) {
                return TurboButton(
                  text: _currentPage == 0 ? 'Siguiente' : 'Registrar Negocio',
                  isLoading: state is AdminAuthLoading,
                  onPressed: _nextPage,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
