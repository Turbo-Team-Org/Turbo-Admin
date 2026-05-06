import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Widget de filtros para las solicitudes de business owners
/// Implementado como StatelessWidget para mejor rendimiento
class BusinessRequestsFilters extends StatelessWidget {
  final TextEditingController searchController;
  final BusinessOwnerRequestStatus? selectedStatus;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<BusinessOwnerRequestStatus?> onStatusChanged;

  const BusinessRequestsFilters({
    super.key,
    required this.searchController,
    required this.selectedStatus,
    required this.onSearchChanged,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
                  color: const Color(0xFF6B7280).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.filter_list,
                  size: 20,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Filtros y Búsqueda',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MuseoSans',
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Barra de búsqueda y filtros en fila
          Row(
            children: [
              // Campo de búsqueda
              Expanded(
                flex: 2,
                child: _SearchField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                ),
              ),

              const SizedBox(width: 16),

              // Filtro por estado
              Expanded(
                child: _StatusFilter(
                  selectedStatus: selectedStatus,
                  onChanged: onStatusChanged,
                ),
              ),

              const SizedBox(width: 16),

              // Botón de limpiar filtros
              _ClearFiltersButton(
                onPressed: () {
                  searchController.clear();
                  onSearchChanged('');
                  onStatusChanged(null);
                },
                hasActiveFilters:
                    searchController.text.isNotEmpty || selectedStatus != null,
              ),
            ],
          ),

          // Indicadores de filtros activos
          if (searchController.text.isNotEmpty || selectedStatus != null) ...[
            const SizedBox(height: 16),
            _ActiveFiltersIndicator(
              searchQuery: searchController.text,
              selectedStatus: selectedStatus,
              onRemoveSearch: () {
                searchController.clear();
                onSearchChanged('');
              },
              onRemoveStatus: () => onStatusChanged(null),
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget del campo de búsqueda
class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchField({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Buscar por nombre, negocio o email...',
        hintStyle: const TextStyle(
          color: Color(0xFF9CA3AF),
          fontFamily: 'MuseoSans',
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: Color(0xFF6B7280),
          size: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFD1D5DB),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFD1D5DB),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFE53E3E),
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
      ),
      style: const TextStyle(
        fontSize: 14,
        fontFamily: 'MuseoSans',
        color: Color(0xFF111827),
      ),
    );
  }
}

/// Widget del filtro por estado
class _StatusFilter extends StatelessWidget {
  final BusinessOwnerRequestStatus? selectedStatus;
  final ValueChanged<BusinessOwnerRequestStatus?> onChanged;

  const _StatusFilter({
    required this.selectedStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<BusinessOwnerRequestStatus?>(
      value: selectedStatus,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'Estado',
        labelStyle: const TextStyle(
          color: Color(0xFF6B7280),
          fontFamily: 'MuseoSans',
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFD1D5DB),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFD1D5DB),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFE53E3E),
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
      ),
      style: const TextStyle(
        fontSize: 14,
        fontFamily: 'MuseoSans',
        color: Color(0xFF111827),
      ),
      items: [
        const DropdownMenuItem<BusinessOwnerRequestStatus?>(
          value: null,
          child: Text('Todos los estados'),
        ),
        ...BusinessOwnerRequestStatus.values.map((status) {
          return DropdownMenuItem<BusinessOwnerRequestStatus?>(
            value: status,
            child: Row(
              children: [
                Icon(
                  _getStatusIcon(status),
                  size: 16,
                  color: _getStatusColor(status),
                ),
                const SizedBox(width: 8),
                Text(_getStatusText(status)),
              ],
            ),
          );
        }),
      ],
    );
  }

  IconData _getStatusIcon(BusinessOwnerRequestStatus status) {
    switch (status) {
      case BusinessOwnerRequestStatus.pending:
        return Icons.hourglass_empty;
      case BusinessOwnerRequestStatus.reviewing:
        return Icons.rate_review;
      case BusinessOwnerRequestStatus.needsMoreInfo:
        return Icons.info_outline;
      case BusinessOwnerRequestStatus.approved:
        return Icons.verified_user;
      case BusinessOwnerRequestStatus.rejected:
        return Icons.cancel;
    }
  }

  Color _getStatusColor(BusinessOwnerRequestStatus status) {
    switch (status) {
      case BusinessOwnerRequestStatus.pending:
        return Colors.orange.shade600;
      case BusinessOwnerRequestStatus.reviewing:
        return Colors.blue.shade600;
      case BusinessOwnerRequestStatus.needsMoreInfo:
        return Colors.amber.shade600;
      case BusinessOwnerRequestStatus.approved:
        return Colors.green.shade600;
      case BusinessOwnerRequestStatus.rejected:
        return Colors.red.shade600;
    }
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

/// Botón para limpiar todos los filtros
class _ClearFiltersButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool hasActiveFilters;

  const _ClearFiltersButton({
    required this.onPressed,
    required this.hasActiveFilters,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: hasActiveFilters ? 1.0 : 0.5,
      duration: const Duration(milliseconds: 200),
      child: OutlinedButton.icon(
        onPressed: hasActiveFilters ? onPressed : null,
        icon: const Icon(
          Icons.clear_all,
          size: 16,
        ),
        label: const Text('Limpiar'),
        style: OutlinedButton.styleFrom(
          foregroundColor: hasActiveFilters
              ? const Color(0xFFE53E3E)
              : const Color(0xFF9CA3AF),
          side: BorderSide(
            color: hasActiveFilters
                ? const Color(0xFFE53E3E)
                : const Color(0xFFD1D5DB),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}

/// Indicador de filtros activos
class _ActiveFiltersIndicator extends StatelessWidget {
  final String searchQuery;
  final BusinessOwnerRequestStatus? selectedStatus;
  final VoidCallback onRemoveSearch;
  final VoidCallback onRemoveStatus;

  const _ActiveFiltersIndicator({
    required this.searchQuery,
    required this.selectedStatus,
    required this.onRemoveSearch,
    required this.onRemoveStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Filtros activos:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'MuseoSans',
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (searchQuery.isNotEmpty)
              _FilterChip(
                label: 'Búsqueda: "$searchQuery"',
                onRemove: onRemoveSearch,
              ),
            if (selectedStatus != null)
              _FilterChip(
                label: 'Estado: ${_getStatusText(selectedStatus!)}',
                onRemove: onRemoveStatus,
              ),
          ],
        ),
      ],
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

/// Chip individual para cada filtro activo
class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _FilterChip({
    required this.label,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE53E3E).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE53E3E).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'MuseoSans',
              color: Color(0xFFE53E3E),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: const Color(0xFFE53E3E).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 12,
                color: Color(0xFFE53E3E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
