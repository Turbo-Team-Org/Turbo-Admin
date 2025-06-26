import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Widget para mostrar las reservas del día actual
class TodayReservationsSection extends StatelessWidget {
  final List<Reservation> reservations;
  final Function(Reservation) onReservationTap;

  const TodayReservationsSection({
    super.key,
    required this.reservations,
    required this.onReservationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Reservas de Hoy',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'MuseoSans',
                    color: Color(0xFF111827),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF8FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${reservations.length}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3B82F6),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: reservations.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: reservations.length,
                      itemBuilder: (context, index) {
                        final reservation = reservations[index];
                        return _ReservationTile(
                          reservation: reservation,
                          onTap: () => onReservationTap(reservation),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.event_available,
              size: 48,
              color: Color(0xFF6B7280),
            ),
            SizedBox(height: 12),
            Text(
              'No hay reservas para hoy',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'MuseoSans',
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Las reservas aparecerán aquí cuando los clientes hagan reservas',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'MuseoSans',
                color: Color(0xFF9CA3AF),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget individual para cada reserva
class _ReservationTile extends StatelessWidget {
  final Reservation reservation;
  final VoidCallback onTap;

  const _ReservationTile({
    required this.reservation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(reservation.status).withOpacity(0.1),
          child: Icon(
            _getStatusIcon(reservation.status),
            color: _getStatusColor(reservation.status),
            size: 20,
          ),
        ),
        title: Text(
          reservation.customerName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'MuseoSans',
            color: Color(0xFF111827),
          ),
        ),
        subtitle: Text(
          '${_formatTime(reservation.startTime)} • ${reservation.partySize} personas',
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'MuseoSans',
            color: Color(0xFF6B7280),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(reservation.status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _getStatusText(reservation.status),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _getStatusColor(reservation.status),
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(ReservationStatus status) {
    switch (status) {
      case ReservationStatus.pending:
        return const Color(0xFFF59E0B);
      case ReservationStatus.confirmed:
        return const Color(0xFF10B981);
      case ReservationStatus.rejected:
        return const Color(0xFFEF4444);
      case ReservationStatus.cancelled:
        return const Color(0xFF6B7280);
      case ReservationStatus.checkedIn:
        return const Color(0xFF3B82F6);
      case ReservationStatus.completed:
        return const Color(0xFF059669);
      case ReservationStatus.noShow:
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFFF59E0B);
    }
  }

  IconData _getStatusIcon(ReservationStatus status) {
    switch (status) {
      case ReservationStatus.pending:
        return Icons.pending;
      case ReservationStatus.confirmed:
        return Icons.check_circle;
      case ReservationStatus.rejected:
        return Icons.cancel;
      case ReservationStatus.cancelled:
        return Icons.block;
      case ReservationStatus.checkedIn:
        return Icons.login;
      case ReservationStatus.completed:
        return Icons.check_circle_outline;
      case ReservationStatus.noShow:
        return Icons.person_off;
      default:
        return Icons.pending;
    }
  }

  String _getStatusText(ReservationStatus status) {
    switch (status) {
      case ReservationStatus.pending:
        return 'Pendiente';
      case ReservationStatus.confirmed:
        return 'Confirmada';
      case ReservationStatus.rejected:
        return 'Rechazada';
      case ReservationStatus.cancelled:
        return 'Cancelada';
      case ReservationStatus.checkedIn:
        return 'Check-in';
      case ReservationStatus.completed:
        return 'Completada';
      case ReservationStatus.noShow:
        return 'No-show';
      default:
        return 'Pendiente';
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
