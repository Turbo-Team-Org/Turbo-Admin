import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:core/core.dart'; // For Event model, EventRepository, EventService

// --- Events States ---
abstract class EventsState {}

class EventsInitial extends EventsState {}

class EventsLoading extends EventsState {}

class EventsLoaded extends EventsState {
  final List<Event> events; // Event comes from turbo_core
  final int totalCount; // For potential pagination
  final int currentPage; // For potential pagination

  EventsLoaded({
    required this.events,
    required this.totalCount,
    required this.currentPage,
  });
}

class EventsError extends EventsState {
  final String message;
  EventsError(this.message);
}

// --- Events Cubit ---
class EventsCubit extends Cubit<EventsState> {
  final EventRepository _eventRepository;
  final EventService _eventService;

  EventsCubit({
    EventRepository? eventRepository,
    EventService? eventService,
  }) : _eventRepository = eventRepository ?? GetIt.instance<EventRepository>(),
       _eventService = eventService ?? GetIt.instance<EventService>(),
       super(EventsInitial());

  Future<void> loadEvents({int page = 1, String? placeId, DateTime? date}) async {
    emit(EventsLoading());
    try {
      // Assuming EventRepository has methods like getEvents, getEventsByPlace, getEventsByDate
      // This is a simplified example; actual filtering logic might be more complex
      List<Event> events;
      if (placeId != null && placeId.isNotEmpty) {
        events = await _eventRepository.getEventsByPlace(placeId);
      } else if (date != null) {
        events = await _eventRepository.getEventsByDate(date);
      } else {
        events = await _eventRepository.getEvents(); // Gets all or a page
      }
      
      emit(EventsLoaded(
        events: events,
        totalCount: events.length, // Replace with actual total count if paginated
        currentPage: page,
      ));
    } catch (e) {
      emit(EventsError(e.toString()));
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _eventService.deleteEvent(eventId);
      await loadEvents(); // Reload events after deletion
    } catch (e) {
      // If the current state is EventsLoaded, we might want to emit an error but keep the data
      if (state is EventsLoaded) {
        final currentEvents = (state as EventsLoaded).events;
        final totalCount = (state as EventsLoaded).totalCount;
        final currentPage = (state as EventsLoaded).currentPage;
        emit(EventsError('Error al eliminar evento: ${e.toString()}')); // Show error
        emit(EventsLoaded(events: currentEvents, totalCount: totalCount, currentPage: currentPage)); // Re-emit current data
      } else {
        emit(EventsError('Error al eliminar evento: ${e.toString()}'));
      }
    }
  }
}
