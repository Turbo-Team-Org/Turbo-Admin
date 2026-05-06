import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:core/core.dart'; // For Event, Place models and related Repos/Services

// --- EventForm States ---
abstract class EventFormState {}

class EventFormInitial extends EventFormState {}

class EventFormLoading extends EventFormState {}

class EventFormLoaded extends EventFormState {
  final Event? event; // null for create, Event for edit
  final List<Place> places; // To select a place for the event

  EventFormLoaded({this.event, required this.places});
}

class EventFormSaving extends EventFormState {}

class EventFormSuccess extends EventFormState {
  final bool isNewEvent;
  EventFormSuccess({required this.isNewEvent});
}

class EventFormError extends EventFormState {
  final String message;
  EventFormError(this.message);
}

// --- EventForm Cubit ---
class EventFormCubit extends Cubit<EventFormState> {
  final EventRepository _eventRepository;
  final PlaceRepository _placeRepository; // To fetch places for selection

  EventFormCubit({
    required EventRepository eventRepository,
    required PlaceRepository placeRepository,
  })  : _eventRepository = eventRepository,
        _placeRepository = placeRepository,
        super(EventFormInitial());

  Future<void> loadForm({String? eventId}) async {
    emit(EventFormLoading());
    try {
      // Load places for the dropdown/selector
      final places = await _placeRepository.getPlaces();

      Event? event;
      if (eventId != null && eventId.isNotEmpty) {
        event = await _eventRepository.getEventById(eventId);
      }
      emit(EventFormLoaded(event: event, places: places));
    } catch (e) {
      emit(EventFormError(e.toString()));
    }
  }

  Future<void> saveEvent(Event event) async {
    emit(EventFormSaving());
    try {
      bool isNewEvent = event.id.isEmpty;
      if (isNewEvent) {
        await _eventRepository.addEvent(event);
      } else {
        await _eventRepository.updateEvent(event);
      }
      emit(EventFormSuccess(isNewEvent: isNewEvent));
    } catch (e) {
      emit(EventFormError('Error al guardar evento: ${e.toString()}'));
    }
  }
}
