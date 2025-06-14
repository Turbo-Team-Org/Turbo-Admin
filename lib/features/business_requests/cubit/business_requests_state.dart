part of 'business_requests_cubit.dart';

@freezed
sealed class BusinessRequestsState with _$BusinessRequestsState {
  /// Estado inicial
  const factory BusinessRequestsState.initial() = BusinessRequestsInitial;

  /// Estado de carga
  const factory BusinessRequestsState.loading() = BusinessRequestsLoading;

  /// Estado con solicitudes cargadas
  const factory BusinessRequestsState.loaded(
    List<BusinessOwnerRequest> requests, {
    @Default([]) List<BusinessOwnerRequest> allRequests,
  }) = BusinessRequestsLoaded;

  /// Estado de error
  const factory BusinessRequestsState.error(String message) =
      BusinessRequestsError;
}
