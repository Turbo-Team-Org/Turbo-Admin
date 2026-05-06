import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:turbo_admin/core/widgets/admin_page.dart';
import 'package:turbo_admin/features/auth/cubit/admin_auth_cubit.dart';
import '../cubit/business_requests_cubit.dart';
import '../widgets/business_request.dart';

/// Página principal para gestionar solicitudes de business owners
/// Solo accesible para super administradores
class BusinessRequestsPage extends StatelessWidget {
  const BusinessRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetIt.instance<BusinessRequestsCubit>()..loadBusinessRequests(),
      child: const _BusinessRequestsView(),
    );
  }
}

class _BusinessRequestsView extends StatefulWidget {
  const _BusinessRequestsView();

  @override
  State<_BusinessRequestsView> createState() => _BusinessRequestsViewState();
}

class _BusinessRequestsViewState extends State<_BusinessRequestsView> {
  final _searchController = TextEditingController();
  BusinessOwnerRequestStatus? _selectedStatus;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminAuthCubit, AdminAuthState>(
      builder: (context, authState) {
        // Verificar que sea super admin
        if (authState is AdminAuthenticatedAdmin) {
          final isSuperAdmin = authState.user.role.name == 'superAdmin';
          if (!isSuperAdmin) {
            return _buildAccessDenied();
          }
        } else {
          return _buildAccessDenied();
        }

        return AdminPage(
          body: BlocConsumer<BusinessRequestsCubit, BusinessRequestsState>(
            listener: (context, state) {
              if (state is BusinessRequestsError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header con título y acciones
                    _buildHeader(context, state),

                    const SizedBox(height: 24),

                    // Estadísticas
                    if (state is BusinessRequestsLoaded) ...[
                      BusinessRequestsStatsWidget(
                        stats: context.read<BusinessRequestsCubit>().getStats(),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Filtros y búsqueda
                    BusinessRequestsFilters(
                      searchController: _searchController,
                      selectedStatus: _selectedStatus,
                      onSearchChanged: (query) {
                        context
                            .read<BusinessRequestsCubit>()
                            .searchRequests(query);
                      },
                      onStatusChanged: (status) {
                        setState(() {
                          _selectedStatus = status;
                        });
                        context
                            .read<BusinessRequestsCubit>()
                            .filterByStatus(status);
                      },
                    ),

                    const SizedBox(height: 24),

                    // Lista de solicitudes
                    _buildRequestsList(state),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, BusinessRequestsState state) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Solicitudes de Business Owners',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111827),
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Gestiona las solicitudes de registro de propietarios de negocios',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF6B7280),
                    ),
              ),
            ],
          ),
        ),

        // Botón de actualizar
        IconButton(
          onPressed: state is BusinessRequestsLoading
              ? null
              : () =>
                  context.read<BusinessRequestsCubit>().loadBusinessRequests(),
          icon: Icon(
            Icons.refresh,
            color: state is BusinessRequestsLoading
                ? Colors.grey
                : const Color(0xFFE53E3E),
          ),
          tooltip: 'Actualizar solicitudes',
        ),
      ],
    );
  }

  Widget _buildRequestsList(BusinessRequestsState state) {
    if (state is BusinessRequestsLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFE53E3E),
        ),
      );
    }

    if (state is BusinessRequestsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar las solicitudes',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.red.shade700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.red.shade600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  context.read<BusinessRequestsCubit>().loadBusinessRequests(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53E3E),
                foregroundColor: Colors.white,
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (state is BusinessRequestsLoaded) {
      if (state.requests.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.business_center_outlined,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No hay solicitudes',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                _selectedStatus != null
                    ? 'No hay solicitudes con el estado seleccionado'
                    : 'Aún no se han recibido solicitudes de business owners',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade500,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: state.requests.length,
        itemBuilder: (context, index) {
          final request = state.requests[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: BusinessRequestCard(
              request: request,
              onApprove: () => _showApproveDialog(context, request),
              onReject: () => _showRejectDialog(context, request),
              onRequestMoreInfo: () =>
                  _showRequestMoreInfoDialog(context, request),
              onViewDetails: () => _showDetailsDialog(context, request),
            ),
          );
        },
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildAccessDenied() {
    return AdminPage(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Acceso Denegado',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Solo los super administradores pueden acceder a esta sección',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.red.shade600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/dashboard'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53E3E),
                foregroundColor: Colors.white,
              ),
              child: const Text('Volver al Dashboard'),
            ),
          ],
        ),
      ),
    );
  }

  void _showApproveDialog(BuildContext context, BusinessOwnerRequest request) {
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Aprobar Solicitud'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '¿Estás seguro de que deseas aprobar la solicitud de ${request.displayName}?'),
            const SizedBox(height: 16),
            Text(
              'Negocio: ${request.businessName}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text('Email: ${request.email}'),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Notas de aprobación (opcional)',
                hintText: 'Agregar comentarios sobre la aprobación...',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              final adminAuthCubit = context.read<AdminAuthCubit>();
              final currentAdminUid =
                  adminAuthCubit.currentAdminUser?.uid ?? '';

              context.read<BusinessRequestsCubit>().approveRequest(
                    request.id,
                    currentAdminUid,
                    approvalNotes: notesController.text.trim().isNotEmpty
                        ? notesController.text.trim()
                        : null,
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Aprobar'),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context, BusinessOwnerRequest request) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Rechazar Solicitud'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '¿Por qué deseas rechazar la solicitud de ${request.displayName}?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Motivo del rechazo',
                hintText: 'Explica el motivo del rechazo...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isNotEmpty) {
                Navigator.of(dialogContext).pop();
                final adminAuthCubit = context.read<AdminAuthCubit>();
                final currentAdminUid =
                    adminAuthCubit.currentAdminUser?.uid ?? '';

                context.read<BusinessRequestsCubit>().rejectRequest(
                      request.id,
                      currentAdminUid,
                      reasonController.text.trim(),
                    );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );
  }

  void _showRequestMoreInfoDialog(
      BuildContext context, BusinessOwnerRequest request) {
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Solicitar Más Información'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '¿Qué información adicional necesitas de ${request.displayName}?'),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              decoration: const InputDecoration(
                labelText: 'Mensaje',
                hintText: 'Describe qué información necesitas...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (messageController.text.trim().isNotEmpty) {
                Navigator.of(dialogContext).pop();
                context.read<BusinessRequestsCubit>().requestMoreInfo(
                      request.id,
                      messageController.text.trim(),
                    );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, BusinessOwnerRequest request) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Detalles de ${request.displayName}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Nombre', request.displayName),
              _buildDetailRow('Email', request.email),
              _buildDetailRow('Negocio', request.businessName),
              _buildDetailRow('Descripción', request.businessDescription),
              if (request.businessAddress.isNotEmpty)
                _buildDetailRow('Dirección', request.businessAddress),
              if (request.phoneNumber != null &&
                  request.phoneNumber!.isNotEmpty)
                _buildDetailRow('Teléfono', request.phoneNumber!),
              if (request.website != null && request.website!.isNotEmpty)
                _buildDetailRow('Sitio Web', request.website!),
              _buildDetailRow('Estado', _getStatusText(request.status)),
              _buildDetailRow('Fecha de Solicitud',
                  request.createdAt.toString().split(' ')[0]),
              if (request.rejectionReason != null)
                _buildDetailRow('Motivo de Rechazo', request.rejectionReason!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(BusinessOwnerRequestStatus status) {
    switch (status) {
      case BusinessOwnerRequestStatus.pending:
        return 'Pendiente';
      case BusinessOwnerRequestStatus.reviewing:
        return 'En Revisión';
      case BusinessOwnerRequestStatus.needsMoreInfo:
        return 'Necesita Más Información';
      case BusinessOwnerRequestStatus.approved:
        return 'Aprobado';
      case BusinessOwnerRequestStatus.rejected:
        return 'Rechazado';
    }
  }
}
