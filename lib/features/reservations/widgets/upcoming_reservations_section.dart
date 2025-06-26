import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Widget para mostrar las próximas reservas de la semana
class UpcomingReservationsSection extends StatelessWidget {
  final List<Reservation> reservations;
  final Function(Reservation) onReservationTap;

  const UpcomingReservationsSection({
    super.key,
    required this.reservations,
    required this.onReservationTap,
  });

  @override
  Widget build(BuildContext context) {
    // Filtrar solo las reservas futuras (no de hoy)
    final upcomingReservations = reservations.where((r) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final reservationDate =
          DateTime(r.startTime.year, r.startTime.month, r.startTime.day);
      return reservationDate.isAfter(today);
    }).toList();

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
                  'Próximas Reservas',
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
                    color: const Color(0xFFF3E8FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${upcomingReservations.length}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7C3AED),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: upcomingReservations.isEmpty
                  ? _buildEmptyState()
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: upcomingReservations.take(5).length,
                            itemBuilder: (context, index) {
                              final reservation =
                                  upcomingReservations.toList()[index];
                              return _UpcomingReservationTile(
                                reservation: reservation,
                                onTap: () => onReservationTap(reservation),
                              );
                            },
                          ),
                        ),
                        if (upcomingReservations.length > 5)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Center(
                              child: TextButton(
                                onPressed: () {
                                  // TODO: Navegar a vista completa de próximas reservas
                                },
                                child: Text(
                                    'Ver todas las ${upcomingReservations.length} próximas'),
                              ),
                            ),
                          ),
                      ],
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
              Icons.event_note,
              size: 48,
              color: Color(0xFF6B7280),
            ),
            SizedBox(height: 12),
            Text(
              'No hay próximas reservas',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'MuseoSans',
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Las próximas reservas aparecerán aquí',
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

/// Widget individual para cada próxima reserva
class _UpcomingReservationTile extends StatelessWidget {
  final Reservation reservation;
  final VoidCallback onTap;

  const _UpcomingReservationTile({
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
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF7C3AED).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${reservation.startTime.day}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF7C3AED),
                ),
              ),
              Text(
                _getMonthAbbreviation(reservation.startTime.month),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7C3AED),
                ),
              ),
            ],
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
          '${_formatTime(reservation.startTime)} • ${reservation.partySize} personas • ${_getDaysUntil(reservation.startTime)}',
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
      case ReservationStatus.modifying:
        return 'Modificando';
      default:
        return 'Pendiente';
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      'ENE',
      'FEB',
      'MAR',
      'ABR',
      'MAY',
      'JUN',
      'JUL',
      'AGO',
      'SEP',
      'OCT',
      'NOV',
      'DIC'
    ];
    return months[month - 1];
  }

  String _getDaysUntil(DateTime reservationTime) {
    final now = DateTime.now();
    final difference = reservationTime.difference(now).inDays;

    if (difference == 0) {
      return 'Hoy';
    } else if (difference == 1) {
      return 'Mañana';
    } else {
      return 'En $difference días';
    }
  }
}
