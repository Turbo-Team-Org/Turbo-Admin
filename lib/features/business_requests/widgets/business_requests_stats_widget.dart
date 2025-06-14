import 'package:flutter/material.dart';
import '../cubit/business_requests_cubit.dart';

/// Widget para mostrar estadísticas de las solicitudes de business owners
/// Implementado como StatelessWidget para mejor rendimiento
class BusinessRequestsStatsWidget extends StatelessWidget {
  final BusinessRequestsStats stats;

  const BusinessRequestsStatsWidget({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF9FAFB),
            Color(0xFFFFFFFF),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 3,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la sección
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53E3E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.analytics_outlined,
                  size: 20,
                  color: Color(0xFFE53E3E),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Estadísticas de Solicitudes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MuseoSans',
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Grid de estadísticas
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _StatCard(
                title: 'Total',
                value: stats.total.toString(),
                icon: Icons.business_center_outlined,
                color: const Color(0xFF6B7280),
                backgroundColor: const Color(0xFFF3F4F6),
              ),
              _StatCard(
                title: 'Pendientes',
                value: stats.pending.toString(),
                icon: Icons.hourglass_empty,
                color: Colors.orange.shade600,
                backgroundColor: Colors.orange.shade50,
              ),
              _StatCard(
                title: 'En Revisión',
                value: stats.reviewing.toString(),
                icon: Icons.rate_review,
                color: Colors.blue.shade600,
                backgroundColor: Colors.blue.shade50,
              ),
              _StatCard(
                title: 'Aprobadas',
                value: stats.approved.toString(),
                icon: Icons.verified_user,
                color: Colors.green.shade600,
                backgroundColor: Colors.green.shade50,
              ),
              _StatCard(
                title: 'Rechazadas',
                value: stats.rejected.toString(),
                icon: Icons.cancel,
                color: Colors.red.shade600,
                backgroundColor: Colors.red.shade50,
              ),
              _StatCard(
                title: 'Más Info',
                value: stats.needsMoreInfo.toString(),
                icon: Icons.info_outline,
                color: Colors.amber.shade600,
                backgroundColor: Colors.amber.shade50,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Barra de progreso visual
          if (stats.total > 0) ...[
            const Text(
              'Distribución de Estados',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'MuseoSans',
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 8),
            _ProgressBar(stats: stats),
          ],
        ],
      ),
    );
  }
}

/// Widget individual para cada estadística
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'MuseoSans',
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'MuseoSans',
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Widget de barra de progreso para mostrar distribución
class _ProgressBar extends StatelessWidget {
  final BusinessRequestsStats stats;

  const _ProgressBar({required this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats.total == 0) return const SizedBox.shrink();

    final pendingPercent = stats.pending / stats.total;
    final reviewingPercent = stats.reviewing / stats.total;
    final approvedPercent = stats.approved / stats.total;
    final rejectedPercent = stats.rejected / stats.total;
    final needsMoreInfoPercent = stats.needsMoreInfo / stats.total;

    return Column(
      children: [
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: const Color(0xFFE5E7EB),
          ),
          child: Row(
            children: [
              if (pendingPercent > 0)
                Expanded(
                  flex: (pendingPercent * 100).round(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange.shade400,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        bottomLeft: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
              if (reviewingPercent > 0)
                Expanded(
                  flex: (reviewingPercent * 100).round(),
                  child: Container(
                    color: Colors.blue.shade400,
                  ),
                ),
              if (needsMoreInfoPercent > 0)
                Expanded(
                  flex: (needsMoreInfoPercent * 100).round(),
                  child: Container(
                    color: Colors.amber.shade400,
                  ),
                ),
              if (approvedPercent > 0)
                Expanded(
                  flex: (approvedPercent * 100).round(),
                  child: Container(
                    color: Colors.green.shade400,
                  ),
                ),
              if (rejectedPercent > 0)
                Expanded(
                  flex: (rejectedPercent * 100).round(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (stats.pending > 0)
              _LegendItem(
                color: Colors.orange.shade400,
                label: 'Pendientes',
                percentage: (pendingPercent * 100).round(),
              ),
            if (stats.reviewing > 0)
              _LegendItem(
                color: Colors.blue.shade400,
                label: 'En Revisión',
                percentage: (reviewingPercent * 100).round(),
              ),
            if (stats.needsMoreInfo > 0)
              _LegendItem(
                color: Colors.amber.shade400,
                label: 'Más Info',
                percentage: (needsMoreInfoPercent * 100).round(),
              ),
            if (stats.approved > 0)
              _LegendItem(
                color: Colors.green.shade400,
                label: 'Aprobadas',
                percentage: (approvedPercent * 100).round(),
              ),
            if (stats.rejected > 0)
              _LegendItem(
                color: Colors.red.shade400,
                label: 'Rechazadas',
                percentage: (rejectedPercent * 100).round(),
              ),
          ],
        ),
      ],
    );
  }
}

/// Widget para elementos de la leyenda
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int percentage;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$label ($percentage%)',
          style: const TextStyle(
            fontSize: 10,
            fontFamily: 'MuseoSans',
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}
