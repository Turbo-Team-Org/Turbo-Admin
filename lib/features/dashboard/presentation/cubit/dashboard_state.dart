part of 'dashboard_cubit.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState.initial() = DashboardInitial;
  const factory DashboardState.loading() = DashboardLoading;
  const factory DashboardState.loaded(DashboardStats stats) = DashboardLoaded;
  const factory DashboardState.refreshing(DashboardStats stats) =
      DashboardRefreshing;
  const factory DashboardState.error(String message) = DashboardError;
}
