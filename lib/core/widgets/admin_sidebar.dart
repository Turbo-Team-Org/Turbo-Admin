import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'dart:ui';
import 'package:core/core.dart';
import 'theme_toggle_widget.dart';
import 'package:turbo_admin/features/auth/cubit/admin_auth_cubit.dart';

/// Sidebar moderno para el admin panel con diseño de primer nivel
class AdminSidebar extends StatefulWidget {
  const AdminSidebar({super.key});

  @override
  State<AdminSidebar> createState() => _AdminSidebarState();
}

class _AdminSidebarState extends State<AdminSidebar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int _calculateSelectedIndex(BuildContext context) {
    final GoRouterState routerState = GoRouterState.of(context);
    final String? currentRouteName = routerState.name;
    final String? topRouteName = routerState.topRoute?.name;

    if (topRouteName == 'dashboard' || currentRouteName == 'dashboard') {
      return 0;
    }
    if (topRouteName == 'places' ||
        currentRouteName == 'newPlace' ||
        currentRouteName == 'editPlace') {
      return 1;
    }
    if (topRouteName == 'events' ||
        currentRouteName == 'newEvent' ||
        currentRouteName == 'editEvent') {
      return 2;
    }
    if (topRouteName == 'reviews' || currentRouteName == 'moderateReview') {
      return 3;
    }
    if (topRouteName == 'categories' ||
        currentRouteName == 'newCategory' ||
        currentRouteName == 'editCategory') {
      return 4;
    }
    if (topRouteName == 'users' || currentRouteName == 'manageUser') return 5;
    if (topRouteName == 'businessRequests' ||
        currentRouteName == 'businessRequests') return 6;

    final String location = routerState.uri.toString();
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/places')) return 1;
    if (location.startsWith('/events')) return 2;
    if (location.startsWith('/reviews')) return 3;
    if (location.startsWith('/categories')) return 4;
    if (location.startsWith('/users')) return 5;
    if (location.startsWith('/business-requests')) return 6;

    return 0;
  }

  void _navigateToIndex(int index) {
    switch (index) {
      case 0:
        context.goNamed('dashboard');
        break;
      case 1:
        context.goNamed('places');
        break;
      case 2:
        context.goNamed('events');
        break;
      case 3:
        context.goNamed('reviews');
        break;
      case 4:
        context.goNamed('categories');
        break;
      case 5:
        context.goNamed('users');
        break;
      case 6:
        context.goNamed('businessRequests');
        break;
    }
  }

  void _showSignOutConfirmation(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isDark
                          ? const Color(0xFFFF5757)
                          : const Color(0xFFE53E3E))
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.logout,
                  color: isDark
                      ? const Color(0xFFFF5757)
                      : const Color(0xFFE53E3E),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Cerrar Sesión',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'MuseoSans',
                  color: isDark
                      ? const Color(0xFFF8FAFC)
                      : const Color(0xFF111827),
                ),
              ),
            ],
          ),
          content: Text(
            '¿Estás seguro de que quieres cerrar sesión?',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'MuseoSans',
              color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF6B7280),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'MuseoSans',
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF6B7280),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AdminAuthCubit>().signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDark ? const Color(0xFFFF5757) : const Color(0xFFE53E3E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                'Cerrar Sesión',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'MuseoSans',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AdminAuthCubit, AdminAuthState>(
      listener: (context, state) {
        if (state is AdminAuthUnauthenticated) {
          if (kDebugMode) {
            debugPrint(
                '🔄 AdminSidebar: Usuario desautenticado, redirigiendo a login');
          }
          // Redirigir al login cuando el usuario se desautentica
          context.go('/login');
        }
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeOutCubic,
            )),
            child: Container(
              width: 280,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          const Color(0xFF0F0F23),
                          const Color(0xFF1A1B3A),
                          const Color(0xFF1E1E3F),
                        ]
                      : [
                          Colors.white,
                          const Color(0xFFFEF7F7),
                          const Color(0xFFFDF2F2),
                        ],
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(4, 0),
                    blurRadius: 30,
                    color: isDark
                        ? const Color(0xFFFF5757).withOpacity(0.1)
                        : const Color(0xFFE53E3E).withOpacity(0.1),
                  ),
                ],
              ),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: isDark
                              ? const Color(0xFFFF5757).withOpacity(0.1)
                              : const Color(0xFFE53E3E).withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Header con logo
                        _buildHeader(isDark),

                        // Menú principal
                        Expanded(
                          child: _buildMainMenu(selectedIndex, isDark),
                        ),

                        // Footer con toggle de tema
                        _buildFooter(isDark),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        children: [
          // Logo oficial de Turbo
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [const Color(0xFFFF5757), const Color(0xFFFF8A65)]
                    : [const Color(0xFFE53E3E), const Color(0xFFFF6B35)],
              ),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 8),
                  blurRadius: 20,
                  color: isDark
                      ? const Color(0xFFFF5757).withOpacity(0.3)
                      : const Color(0xFFE53E3E).withOpacity(0.3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/app_icon.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Título
          Text(
            'Turbo Admin',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              fontFamily: 'MuseoSans',
              color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF111827),
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 4),

          // Subtítulo
          Text(
            'Panel de Control',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'MuseoSans',
              fontWeight: FontWeight.w500,
              color: isDark ? const Color(0xFFA1A1AA) : const Color(0xFF6B7280),
              letterSpacing: 0.2,
            ),
          ),

          const SizedBox(height: 20),

          // Indicador de modo demo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        const Color(0xFFFF5757).withOpacity(0.15),
                        const Color(0xFFFF8A65).withOpacity(0.15),
                      ]
                    : [
                        const Color(0xFFE53E3E).withOpacity(0.1),
                        const Color(0xFFFF6B35).withOpacity(0.1),
                      ],
              ),
              border: Border.all(
                color: isDark
                    ? const Color(0xFFFF5757).withOpacity(0.3)
                    : const Color(0xFFE53E3E).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? const Color(0xFFFF5757)
                        : const Color(0xFFE53E3E),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'MODO DEMO',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'MuseoSans',
                    color: isDark
                        ? const Color(0xFFFF5757)
                        : const Color(0xFFE53E3E),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainMenu(int selectedIndex, bool isDark) {
    return BlocBuilder<AdminAuthCubit, AdminAuthState>(
      builder: (context, authState) {
        // Verificar si es super admin
        bool isSuperAdmin = false;
        if (authState is AdminAuthenticatedAdmin) {
          isSuperAdmin = authState.user.role.name == 'superAdmin';
        }

        final menuItems = [
          _MenuItem(
            icon: Icons.dashboard_rounded,
            label: 'Dashboard',
            index: 0,
          ),
          _MenuItem(
            icon: Icons.location_on_rounded,
            label: 'Lugares',
            index: 1,
          ),
          _MenuItem(
            icon: Icons.event_rounded,
            label: 'Eventos',
            index: 2,
          ),
          _MenuItem(
            icon: Icons.rate_review_rounded,
            label: 'Reseñas',
            index: 3,
          ),
          _MenuItem(
            icon: Icons.category_rounded,
            label: 'Categorías',
            index: 4,
          ),
          _MenuItem(
            icon: Icons.people_rounded,
            label: 'Usuarios',
            index: 5,
          ),
          // Solo mostrar para super admins
          if (isSuperAdmin)
            _MenuItem(
              icon: Icons.business_center_rounded,
              label: 'Solicitudes',
              index: 6,
            ),
        ];

        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'NAVEGACIÓN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'MuseoSans',
                      color: isDark
                          ? const Color(0xFF71717A)
                          : const Color(0xFF9CA3AF),
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ...menuItems.map((item) {
                  final isSelected = selectedIndex == item.index;
                  final isHovered = _hoveredIndex == item.index;

                  return TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 200),
                    tween: Tween(
                        begin: 0.0, end: isSelected || isHovered ? 1.0 : 0.0),
                    builder: (context, animation, child) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        child: MouseRegion(
                          onEnter: (_) =>
                              setState(() => _hoveredIndex = item.index),
                          onExit: (_) => setState(() => _hoveredIndex = null),
                          child: GestureDetector(
                            onTap: () => _navigateToIndex(item.index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOutCubic,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: isSelected
                                    ? LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: isDark
                                            ? [
                                                const Color(0xFFFF5757),
                                                const Color(0xFFFF8A65)
                                              ]
                                            : [
                                                const Color(0xFFE53E3E),
                                                const Color(0xFFFF6B35)
                                              ],
                                      )
                                    : LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: isDark
                                            ? [
                                                const Color(0xFFFF5757)
                                                    .withOpacity(
                                                        animation * 0.15),
                                                const Color(0xFFFF8A65)
                                                    .withOpacity(
                                                        animation * 0.15),
                                              ]
                                            : [
                                                const Color(0xFFE53E3E)
                                                    .withOpacity(
                                                        animation * 0.1),
                                                const Color(0xFFFF6B35)
                                                    .withOpacity(
                                                        animation * 0.1),
                                              ],
                                      ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          offset: const Offset(0, 4),
                                          blurRadius: 12,
                                          color: isDark
                                              ? const Color(0xFFFF5757)
                                                  .withOpacity(0.3)
                                              : const Color(0xFFE53E3E)
                                                  .withOpacity(0.3),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: isSelected
                                          ? Colors.white.withOpacity(0.2)
                                          : Colors.transparent,
                                    ),
                                    child: Icon(
                                      item.icon,
                                      size: 22,
                                      color: isSelected
                                          ? Colors.white
                                          : Color.lerp(
                                              isDark
                                                  ? const Color(0xFFA1A1AA)
                                                  : const Color(0xFF6B7280),
                                              isDark
                                                  ? const Color(0xFFFF5757)
                                                  : const Color(0xFFE53E3E),
                                              animation,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      item.label,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                        fontFamily: 'MuseoSans',
                                        color: isSelected
                                            ? Colors.white
                                            : Color.lerp(
                                                isDark
                                                    ? const Color(0xFFF8FAFC)
                                                    : const Color(0xFF374151),
                                                isDark
                                                    ? const Color(0xFFFF5757)
                                                    : const Color(0xFFE53E3E),
                                                animation,
                                              ),
                                        letterSpacing: 0.1,
                                      ),
                                    ),
                                  ),
                                  if (isSelected || isHovered)
                                    TweenAnimationBuilder<double>(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      tween: Tween(begin: 0.0, end: 1.0),
                                      builder:
                                          (context, scaleAnimation, child) {
                                        return Transform.scale(
                                          scale: scaleAnimation,
                                          child: Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isSelected
                                                  ? Colors.white
                                                  : isDark
                                                      ? const Color(0xFFFF5757)
                                                      : const Color(0xFFE53E3E),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
                // Espaciado adicional al final para mejor UX del scroll
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter(bool isDark) {
    return BlocProvider.value(
      value: GetIt.instance<AdminAuthCubit>(),
      child: BlocBuilder<AdminAuthCubit, AdminAuthState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Divider elegante
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        isDark
                            ? const Color(0xFFFF5757).withOpacity(0.2)
                            : const Color(0xFFE53E3E).withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Usuario actual - mostrar información según el tipo de usuario
                if (state is AdminAuthenticatedAdmin) ...[
                  _buildAdminUserInfo(context, state.user, isDark),
                ] else if (state is AdminAuthenticatedBusinessOwner) ...[
                  _buildBusinessOwnerUserInfo(context, state.request, isDark),
                ] else if (state is AdminAuthBusinessOwnerRegistered) ...[
                  _buildBusinessOwnerUserInfo(context, state.request, isDark),
                ],

                // Toggle de tema
                const ThemeToggleWidget(),

                const SizedBox(height: 16),

                // Footer text
                Text(
                  '© 2025 Turbo Admin',
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'MuseoSans',
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? const Color(0xFF71717A)
                        : const Color(0xFF9CA3AF),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdminUserInfo(
      BuildContext context, AdminUser user, bool isDark) {
    final isSuperAdmin = user.role.name == 'superAdmin';

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isDark
                ? const Color(0xFF1F2937).withOpacity(0.5)
                : const Color(0xFFF3F4F6),
            border: Border.all(
              color: isDark
                  ? const Color(0xFFFF5757).withOpacity(0.1)
                  : const Color(0xFFE53E3E).withOpacity(0.1),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isSuperAdmin
                            ? [const Color(0xFF7C3AED), const Color(0xFFA855F7)]
                            : isDark
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
                      isSuperAdmin
                          ? Icons.admin_panel_settings
                          : Icons.business,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.displayName ?? 'Admin',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'MuseoSans',
                            color: isDark
                                ? const Color(0xFFF8FAFC)
                                : const Color(0xFF374151),
                          ),
                        ),
                        Text(
                          isSuperAdmin
                              ? 'Super Administrador'
                              : 'Administrador',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'MuseoSans',
                            color: isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF6B7280),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 9,
                            fontFamily: 'MuseoSans',
                            color: isDark
                                ? const Color(0xFF71717A)
                                : const Color(0xFF9CA3AF),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => _showSignOutConfirmation(context),
                  icon: Icon(
                    Icons.logout,
                    size: 14,
                    color: isDark
                        ? const Color(0xFFFF5757)
                        : const Color(0xFFE53E3E),
                  ),
                  label: Text(
                    'Cerrar Sesión',
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'MuseoSans',
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? const Color(0xFFFF5757)
                          : const Color(0xFFE53E3E),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBusinessOwnerUserInfo(
      BuildContext context, BusinessOwnerRequest request, bool isDark) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (request.status) {
      case BusinessOwnerRequestStatus.pending:
        statusColor = Colors.orange;
        statusText = 'Pendiente';
        statusIcon = Icons.hourglass_empty;
        break;
      case BusinessOwnerRequestStatus.reviewing:
        statusColor = Colors.blue;
        statusText = 'En Revisión';
        statusIcon = Icons.rate_review;
        break;
      case BusinessOwnerRequestStatus.needsMoreInfo:
        statusColor = Colors.amber;
        statusText = 'Más Info';
        statusIcon = Icons.info_outline;
        break;
      case BusinessOwnerRequestStatus.approved:
        statusColor = Colors.green;
        statusText = 'Aprobado';
        statusIcon = Icons.verified_user;
        break;
      case BusinessOwnerRequestStatus.rejected:
        statusColor = Colors.red;
        statusText = 'Rechazado';
        statusIcon = Icons.cancel;
        break;
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isDark
                ? const Color(0xFF1F2937).withOpacity(0.5)
                : const Color(0xFFF3F4F6),
            border: Border.all(
              color: statusColor.withOpacity(0.3),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: statusColor.withOpacity(0.2),
                    ),
                    child: Icon(
                      statusIcon,
                      color: statusColor,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.displayName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'MuseoSans',
                            color: isDark
                                ? const Color(0xFFF8FAFC)
                                : const Color(0xFF374151),
                          ),
                        ),
                        Text(
                          request.businessName,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'MuseoSans',
                            color: isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF6B7280),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                statusText,
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => _showSignOutConfirmation(context),
                  icon: Icon(
                    Icons.logout,
                    size: 14,
                    color: statusColor,
                  ),
                  label: Text(
                    'Cerrar Sesión',
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'MuseoSans',
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final int index;

  _MenuItem({
    required this.icon,
    required this.label,
    required this.index,
  });
}
