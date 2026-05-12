import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:core/core.dart';

part 'dashboard_state.dart';
part 'dashboard_cubit.freezed.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({
    required this.placeRepository,
    required this.eventRepository,
    required this.reviewRepository,
    required this.categoryRepository,
    required this.analyticsRepository,
    required this.reservationRepository,
  }) : super(const DashboardState.initial());

  final PlaceRepository placeRepository;
  final EventRepository eventRepository;
  final ReviewRepository reviewRepository;
  final CategoryRepository categoryRepository;
  final AnalyticsRepository analyticsRepository;
  final ReservationRepository reservationRepository;

  /// Estadísticas agregadas (super admin / vista global).
  Future<void> loadDashboardStats() async {
    emit(const DashboardState.loading());

    try {
      final places = await placeRepository.getPlaces();
      final events = await eventRepository.getEvents();
      final reviews = await reviewRepository.getReviews();
      final categories = await categoryRepository.getAllCategories();

      final stats = DashboardStats(
        totalPlaces: places.length,
        activePlaces: places.where((p) => p.isOpen).length,
        pendingPlaces: places.where((p) => !p.isOpen).length,
        totalEvents: events.length,
        upcomingEvents:
            events.where((e) => e.date.isAfter(DateTime.now())).length,
        totalReviews: reviews.length,
        pendingReviews:
            reviews.where((r) => r.status == ReviewStatus.pending).length,
        approvedReviews:
            reviews.where((r) => r.status == ReviewStatus.approved).length,
        totalCategories: categories.length,
        averageRating: _calculateAverageRating(reviews),
        placesByCategory: _getPlacesByCategory(places, categories),
        eventsByMonth: _getEventsByMonth(events),
        lastUpdated: DateTime.now(),
      );

      emit(DashboardState.loaded(stats));
    } catch (e) {
      String errorMessage = 'Error cargando estadísticas';

      if (e.toString().contains('Timestamp') ||
          e.toString().contains('String')) {
        errorMessage =
            'Error al procesar fechas de eventos. Por favor, verifica que los datos estén correctamente formateados.';
      } else if (e.toString().contains('Error al obtener eventos')) {
        errorMessage = 'Error al cargar eventos desde la base de datos.';
      } else if (e.toString().contains('Error al obtener lugares')) {
        errorMessage = 'Error al cargar lugares desde la base de datos.';
      } else if (e.toString().contains('Error al obtener reseñas')) {
        errorMessage = 'Error al cargar reseñas desde la base de datos.';
      }

      emit(DashboardState.error('$errorMessage: $e'));
    }
  }

  /// Dashboard de negocio: primer lugar del owner + analytics Core (S2-T4).
  Future<void> loadBusinessOwnerDashboard(String ownerUserId) async {
    emit(const DashboardState.loading());

    try {
      final places = await placeRepository.getPlacesByOwnerId(ownerUserId);
      final events = await eventRepository.getEvents();
      final reviews = await reviewRepository.getReviews();
      final categories = await categoryRepository.getAllCategories();

      final range = DateRange.last30Days();
      BusinessDashboard? ownerDashboard;
      var ownerReservations = 0;
      String? ownerAnalyticsError;

      if (places.isEmpty) {
        ownerAnalyticsError =
            'No hay lugares asociados a tu cuenta. Cuando exista un negocio con owner_ids, verás KPIs aquí.';
      } else {
        final placeId = places.first.id;
        try {
          ownerDashboard =
              await analyticsRepository.getDashboardData(placeId, range);
          final reservations =
              await reservationRepository.getReservationsBetweenDates(
            placeId,
            range.startDate,
            range.endDate,
          );
          ownerReservations = reservations.length;
        } catch (e) {
          ownerAnalyticsError =
              'No se pudieron cargar las métricas de analytics: $e';
        }
      }

      final stats = DashboardStats(
        totalPlaces: places.length,
        activePlaces: places.where((p) => p.isOpen).length,
        pendingPlaces: places.where((p) => !p.isOpen).length,
        totalEvents: events.length,
        upcomingEvents:
            events.where((e) => e.date.isAfter(DateTime.now())).length,
        totalReviews: reviews.length,
        pendingReviews:
            reviews.where((r) => r.status == ReviewStatus.pending).length,
        approvedReviews:
            reviews.where((r) => r.status == ReviewStatus.approved).length,
        totalCategories: categories.length,
        averageRating: _calculateAverageRating(reviews),
        placesByCategory: _getPlacesByCategory(places, categories),
        eventsByMonth: _getEventsByMonth(events),
        lastUpdated: DateTime.now(),
        ownerPlaceDashboard: ownerDashboard,
        ownerReservationsLast30Days: ownerReservations,
        ownerAnalyticsError: ownerAnalyticsError,
      );

      emit(DashboardState.loaded(stats));
    } catch (e) {
      emit(DashboardState.error('Error cargando dashboard de negocio: $e'));
    }
  }

  /// Refrescar estadísticas
  Future<void> refreshStats() async {
    if (state is DashboardLoaded) {
      emit(DashboardState.refreshing((state as DashboardLoaded).stats));
    }
    await loadDashboardStats();
  }

  double _calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0.0;

    final approvedReviews =
        reviews.where((r) => r.status == ReviewStatus.approved);
    if (approvedReviews.isEmpty) return 0.0;

    final totalRating =
        approvedReviews.map((r) => r.rating).reduce((a, b) => a + b);

    return totalRating / approvedReviews.length;
  }

  Map<String, int> _getPlacesByCategory(
    List<Place> places,
    List<Category> categories,
  ) {
    final result = <String, int>{};

    for (final category in categories) {
      final count = places.where((p) => p.categoryId == category.id).length;
      if (count > 0) {
        result[category.name] = count;
      }
    }

    return result;
  }

  Map<String, int> _getEventsByMonth(List<Event> events) {
    final result = <String, int>{};
    final now = DateTime.now();

    for (int i = 0; i < 6; i++) {
      final monthDate = DateTime(now.year, now.month - i, 1);
      final monthKey =
          '${monthDate.year}-${monthDate.month.toString().padLeft(2, '0')}';
      result[monthKey] = 0;
    }

    for (final event in events) {
      final monthKey =
          '${event.date.year}-${event.date.month.toString().padLeft(2, '0')}';
      if (result.containsKey(monthKey)) {
        result[monthKey] = result[monthKey]! + 1;
      }
    }

    return result;
  }

  int? getMetricValue(String metricId) {
    if (state is DashboardLoaded) {
      final stats = (state as DashboardLoaded).stats;
      switch (metricId) {
        case 'total_places':
          return stats.totalPlaces;
        case 'active_places':
          return stats.activePlaces;
        case 'pending_places':
          return stats.pendingPlaces;
        case 'total_events':
          return stats.totalEvents;
        case 'upcoming_events':
          return stats.upcomingEvents;
        case 'total_reviews':
          return stats.totalReviews;
        case 'pending_reviews':
          return stats.pendingReviews;
        case 'approved_reviews':
          return stats.approvedReviews;
        case 'total_categories':
          return stats.totalCategories;
        default:
          return null;
      }
    }
    return null;
  }

  double getChangePercentage(String metricId) {
    switch (metricId) {
      case 'total_places':
        return 12.5;
      case 'total_events':
        return 8.3;
      case 'total_reviews':
        return 15.7;
      case 'pending_reviews':
        return -5.2;
      default:
        return 0.0;
    }
  }

  bool isPositiveChange(String metricId) {
    final change = getChangePercentage(metricId);
    return change >= 0;
  }
}

/// Estadísticas del dashboard (global + opcional analytics por negocio).
class DashboardStats {
  const DashboardStats({
    required this.totalPlaces,
    required this.activePlaces,
    required this.pendingPlaces,
    required this.totalEvents,
    required this.upcomingEvents,
    required this.totalReviews,
    required this.pendingReviews,
    required this.approvedReviews,
    required this.totalCategories,
    required this.averageRating,
    required this.placesByCategory,
    required this.eventsByMonth,
    required this.lastUpdated,
    this.ownerPlaceDashboard,
    this.ownerReservationsLast30Days = 0,
    this.ownerAnalyticsError,
  });

  final int totalPlaces;
  final int activePlaces;
  final int pendingPlaces;
  final int totalEvents;
  final int upcomingEvents;
  final int totalReviews;
  final int pendingReviews;
  final int approvedReviews;
  final int totalCategories;
  final double averageRating;
  final Map<String, int> placesByCategory;
  final Map<String, int> eventsByMonth;
  final DateTime lastUpdated;
  final BusinessDashboard? ownerPlaceDashboard;
  final int ownerReservationsLast30Days;
  final String? ownerAnalyticsError;
}
