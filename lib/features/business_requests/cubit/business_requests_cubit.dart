import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:core/core.dart';
import 'package:turbo_admin/core/state_management/base_cubit.dart';

part 'business_requests_cubit.freezed.dart';
part 'business_requests_state.dart';

/// Cubit para gestionar las solicitudes de business owners
/// Solo accesible para super administradores
class BusinessRequestsCubit extends Cubit<BusinessRequestsState>
    with BaseCubit {
  final AdminAuthRepository _authRepository;

  BusinessRequestsCubit(this._authRepository)
      : super(const BusinessRequestsState.initial());

  /// Cargar todas las solicitudes de business owners
  Future<void> loadBusinessRequests() async {
    secureEmit(const BusinessRequestsState.loading());

    try {
      final result = await _authRepository.getAllBusinessOwnerRequests();

      result.fold(
        (failure) =>
            secureEmit(BusinessRequestsState.error(failure.toString())),
        (requests) => secureEmit(BusinessRequestsState.loaded(
          requests,
          allRequests: requests,
        )),
      );
    } catch (e) {
      secureEmit(BusinessRequestsState.error(e.toString()));
    }
  }

  /// Aprobar una solicitud de business owner
  Future<void> approveRequest(
    String requestId,
    String approvedByUid, {
    List<String>? initialPlaceIds,
    String? approvalNotes,
  }) async {
    secureEmit(const BusinessRequestsState.loading());

    try {
      final result = await _authRepository.approveBusinessOwnerRequest(
        requestId: requestId,
        approvedByUid: approvedByUid,
        initialPlaceIds: initialPlaceIds,
        approvalNotes: approvalNotes,
      );

      result.fold(
        (failure) =>
            secureEmit(BusinessRequestsState.error(failure.toString())),
        (_) {
          // Recargar la lista después de aprobar
          loadBusinessRequests();
        },
      );
    } catch (e) {
      secureEmit(BusinessRequestsState.error(e.toString()));
    }
  }

  /// Rechazar una solicitud de business owner
  Future<void> rejectRequest(
    String requestId,
    String rejectedByUid,
    String rejectionReason,
  ) async {
    secureEmit(const BusinessRequestsState.loading());

    try {
      final result = await _authRepository.rejectBusinessOwnerRequest(
        requestId: requestId,
        rejectedByUid: rejectedByUid,
        rejectionReason: rejectionReason,
      );

      result.fold(
        (failure) =>
            secureEmit(BusinessRequestsState.error(failure.toString())),
        (_) {
          // Recargar la lista después de rechazar
          loadBusinessRequests();
        },
      );
    } catch (e) {
      secureEmit(BusinessRequestsState.error(e.toString()));
    }
  }

  /// Solicitar más información a un business owner
  /// TODO: Implementar cuando esté disponible en AdminAuthRepository
  Future<void> requestMoreInfo(String requestId, String message) async {
    // Por ahora, mostrar un mensaje de que la funcionalidad no está disponible
    secureEmit(const BusinessRequestsState.error(
        'La funcionalidad de solicitar más información aún no está implementada'));

    // Recargar la lista para mantener consistencia
    await Future.delayed(const Duration(seconds: 1));
    loadBusinessRequests();
  }

  /// Filtrar solicitudes por estado
  void filterByStatus(BusinessOwnerRequestStatus? status) {
    final currentState = state;
    if (currentState is BusinessRequestsLoaded) {
      if (status == null) {
        // Mostrar todas las solicitudes
        secureEmit(BusinessRequestsState.loaded(
          currentState.allRequests,
          allRequests: currentState.allRequests,
        ));
      } else {
        // Filtrar por estado específico
        final filteredRequests = currentState.allRequests
            .where((request) => request.status == status)
            .toList();
        secureEmit(BusinessRequestsState.loaded(
          filteredRequests,
          allRequests: currentState.allRequests,
        ));
      }
    }
  }

  /// Buscar solicitudes por texto
  void searchRequests(String query) {
    final currentState = state;
    if (currentState is BusinessRequestsLoaded) {
      if (query.isEmpty) {
        // Mostrar todas las solicitudes
        secureEmit(BusinessRequestsState.loaded(
          currentState.allRequests,
          allRequests: currentState.allRequests,
        ));
      } else {
        // Filtrar por texto de búsqueda
        final filteredRequests = currentState.allRequests.where((request) {
          final searchText = query.toLowerCase();
          return request.displayName.toLowerCase().contains(searchText) ||
              request.businessName.toLowerCase().contains(searchText) ||
              request.email.toLowerCase().contains(searchText);
        }).toList();

        secureEmit(BusinessRequestsState.loaded(
          filteredRequests,
          allRequests: currentState.allRequests,
        ));
      }
    }
  }

  /// Obtener estadísticas de las solicitudes
  BusinessRequestsStats getStats() {
    final currentState = state;
    if (currentState is BusinessRequestsLoaded) {
      final requests = currentState.allRequests;

      // Debug logs
      print('🔍 BusinessRequestsCubit.getStats():');
      print('   Total requests: ${requests.length}');
      print(
          '   All requests: ${requests.map((r) => '${r.displayName} (${r.status.name})').join(', ')}');

      final stats = BusinessRequestsStats(
        total: requests.length,
        pending: requests
            .where((r) => r.status == BusinessOwnerRequestStatus.pending)
            .length,
        approved: requests
            .where((r) => r.status == BusinessOwnerRequestStatus.approved)
            .length,
        rejected: requests
            .where((r) => r.status == BusinessOwnerRequestStatus.rejected)
            .length,
        reviewing: requests
            .where((r) => r.status == BusinessOwnerRequestStatus.reviewing)
            .length,
        needsMoreInfo: requests
            .where((r) => r.status == BusinessOwnerRequestStatus.needsMoreInfo)
            .length,
      );

      print(
          '   Stats calculated: Total=${stats.total}, Pending=${stats.pending}, Approved=${stats.approved}, Rejected=${stats.rejected}');
      return stats;
    }

    print(
        '🔍 BusinessRequestsCubit.getStats(): State is not loaded, returning empty stats');
    return const BusinessRequestsStats(
      total: 0,
      pending: 0,
      approved: 0,
      rejected: 0,
      reviewing: 0,
      needsMoreInfo: 0,
    );
  }
}

/// Estadísticas de las solicitudes de business owners
@freezed
sealed class BusinessRequestsStats with _$BusinessRequestsStats {
  const factory BusinessRequestsStats({
    required int total,
    required int pending,
    required int approved,
    required int rejected,
    required int reviewing,
    required int needsMoreInfo,
  }) = _BusinessRequestsStats;
}
