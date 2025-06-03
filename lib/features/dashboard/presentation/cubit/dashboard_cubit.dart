import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:core/core.dart';

part 'dashboard_state.dart';
part 'dashboard_cubit.freezed.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final PlaceRepository placeRepository;
  final EventRepository eventRepository;
  final ReviewRepository reviewRepository;
  final CategoryRepository categoryRepository;

  DashboardCubit({
    required this.placeRepository,
    required this.eventRepository,
    required this.reviewRepository,
    required this.categoryRepository,
  }) : super(const DashboardState.initial());

  /// Cargar estadísticas del dashboard
  Future<void> loadDashboardStats() async {
    emit(const DashboardState.loading());

    try {
      // Obtener datos básicos de los repositorios del core
      final places = await placeRepository.getPlaces();
      final events = await eventRepository.getEvents();
      final reviews = await reviewRepository.getReviews();
      final categories = await categoryRepository.getAllCategories();

      // Crear estadísticas del dashboard
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
      emit(DashboardState.error('Error cargando estadísticas: $e'));
    }
  }

  /// Refrescar estadísticas
  Future<void> refreshStats() async {
    if (state is DashboardLoaded) {
      emit(DashboardState.refreshing((state as DashboardLoaded).stats));
    }
    await loadDashboardStats();
  }

  /// Calcular rating promedio
  double _calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0.0;

    final approvedReviews =
        reviews.where((r) => r.status == ReviewStatus.approved);
    if (approvedReviews.isEmpty) return 0.0;

    final totalRating =
        approvedReviews.map((r) => r.rating).reduce((a, b) => a + b);

    return totalRating / approvedReviews.length;
  }

  /// Obtener distribución de lugares por categoría
  Map<String, int> _getPlacesByCategory(
      List<Place> places, List<Category> categories) {
    final result = <String, int>{};

    for (final category in categories) {
      final count = places.where((p) => p.categoryId == category.id).length;
      if (count > 0) {
        result[category.name] = count;
      }
    }

    return result;
  }

  /// Obtener eventos por mes (últimos 6 meses)
  Map<String, int> _getEventsByMonth(List<Event> events) {
    final result = <String, int>{};
    final now = DateTime.now();

    // Inicializar últimos 6 meses
    for (int i = 0; i < 6; i++) {
      final monthDate = DateTime(now.year, now.month - i, 1);
      final monthKey =
          '${monthDate.year}-${monthDate.month.toString().padLeft(2, '0')}';
      result[monthKey] = 0;
    }

    // Contar eventos por mes usando la fecha del evento
    for (final event in events) {
      final monthKey =
          '${event.date.year}-${event.date.month.toString().padLeft(2, '0')}';
      if (result.containsKey(monthKey)) {
        result[monthKey] = result[monthKey]! + 1;
      }
    }

    return result;
  }

  /// Obtener valor específico de métrica
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

  /// Obtener porcentaje de cambio para una métrica (mock por ahora)
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

  /// Verificar si el cambio es positivo
  bool isPositiveChange(String metricId) {
    final change = getChangePercentage(metricId);
    return change >= 0;
  }
}

/// Clase simplificada para estadísticas del dashboard
class DashboardStats {
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
  });
}
