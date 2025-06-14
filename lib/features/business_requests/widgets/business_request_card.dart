import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Widget de tarjeta para mostrar una solicitud de business owner
/// Implementado como StatelessWidget para mejor rendimiento
class BusinessRequestCard extends StatelessWidget {
  final BusinessOwnerRequest request;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onRequestMoreInfo;
  final VoidCallback onViewDetails;

  const BusinessRequestCard({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onReject,
    required this.onRequestMoreInfo,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con información básica y estado
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.displayName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MuseoSans',
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        request.businessName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'MuseoSans',
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        request.email,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'MuseoSans',
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                _StatusChip(status: request.status),
              ],
            ),

            const SizedBox(height: 16),

            // Descripción del negocio
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Descripción del Negocio',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'MuseoSans',
                      color: Color(0xFF6B7280),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    request.businessDescription,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'MuseoSans',
                      color: Color(0xFF374151),
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Información adicional
            if (request.businessAddress.isNotEmpty ||
                (request.phoneNumber != null &&
                    request.phoneNumber!.isNotEmpty) ||
                (request.website != null && request.website!.isNotEmpty)) ...[
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  if (request.businessAddress.isNotEmpty)
                    _InfoChip(
                      icon: Icons.location_on_outlined,
                      label: request.businessAddress,
                    ),
                  if (request.phoneNumber != null &&
                      request.phoneNumber!.isNotEmpty)
                    _InfoChip(
                      icon: Icons.phone_outlined,
                      label: request.phoneNumber!,
                    ),
                  if (request.website != null && request.website!.isNotEmpty)
                    _InfoChip(
                      icon: Icons.language_outlined,
                      label: request.website!,
                    ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Fecha de solicitud
            Row(
              children: [
                Icon(
                  Icons.schedule_outlined,
                  size: 16,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 4),
                Text(
                  'Solicitado el ${_formatDate(request.createdAt)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'MuseoSans',
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            // Motivo de rechazo si existe
            if (request.rejectionReason != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.red.shade200,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 16,
                      color: Colors.red.shade600,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Motivo de rechazo: ${request.rejectionReason}',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'MuseoSans',
                          color: Colors.red.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Botones de acción
            Row(
              children: [
                // Botón de ver detalles (siempre visible)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onViewDetails,
                    icon: const Icon(Icons.visibility_outlined, size: 16),
                    label: const Text('Ver Detalles'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF6B7280),
                      side: const BorderSide(color: Color(0xFFD1D5DB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Botones específicos según el estado
                if (request.status == BusinessOwnerRequestStatus.pending) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onRequestMoreInfo,
                      icon: const Icon(Icons.info_outline, size: 16),
                      label: const Text('Más Info'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange.shade600,
                        side: BorderSide(color: Colors.orange.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onReject,
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Rechazar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade600,
                        side: BorderSide(color: Colors.red.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: onApprove,
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Aprobar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ] else if (request.status ==
                    BusinessOwnerRequestStatus.needsMoreInfo) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onReject,
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Rechazar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade600,
                        side: BorderSide(color: Colors.red.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: onApprove,
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Aprobar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre'
    ];

    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }
}

/// Widget para mostrar el estado de la solicitud
class _StatusChip extends StatelessWidget {
  final BusinessOwnerRequestStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusInfo.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusInfo.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusInfo.icon,
            size: 14,
            color: statusInfo.textColor,
          ),
          const SizedBox(width: 6),
          Text(
            statusInfo.text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'MuseoSans',
              color: statusInfo.textColor,
            ),
          ),
        ],
      ),
    );
  }

  _StatusInfo _getStatusInfo(BusinessOwnerRequestStatus status) {
    switch (status) {
      case BusinessOwnerRequestStatus.pending:
        return _StatusInfo(
          text: 'Pendiente',
          icon: Icons.hourglass_empty,
          textColor: Colors.orange.shade700,
          backgroundColor: Colors.orange.shade50,
          borderColor: Colors.orange.shade200,
        );
      case BusinessOwnerRequestStatus.reviewing:
        return _StatusInfo(
          text: 'En Revisión',
          icon: Icons.rate_review,
          textColor: Colors.blue.shade700,
          backgroundColor: Colors.blue.shade50,
          borderColor: Colors.blue.shade200,
        );
      case BusinessOwnerRequestStatus.needsMoreInfo:
        return _StatusInfo(
          text: 'Más Información',
          icon: Icons.info_outline,
          textColor: Colors.amber.shade700,
          backgroundColor: Colors.amber.shade50,
          borderColor: Colors.amber.shade200,
        );
      case BusinessOwnerRequestStatus.approved:
        return _StatusInfo(
          text: 'Aprobado',
          icon: Icons.verified_user,
          textColor: Colors.green.shade700,
          backgroundColor: Colors.green.shade50,
          borderColor: Colors.green.shade200,
        );
      case BusinessOwnerRequestStatus.rejected:
        return _StatusInfo(
          text: 'Rechazado',
          icon: Icons.cancel,
          textColor: Colors.red.shade700,
          backgroundColor: Colors.red.shade50,
          borderColor: Colors.red.shade200,
        );
    }
  }
}

/// Widget para mostrar información adicional con icono
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: const Color(0xFF6B7280),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'MuseoSans',
                color: Color(0xFF374151),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Clase helper para información de estado
class _StatusInfo {
  final String text;
  final IconData icon;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;

  const _StatusInfo({
    required this.text,
    required this.icon,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
  });
}
