import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Base bloc for app's blocs.
mixin BaseBloc<Event, State> on Bloc<Event, State> {
  /// Method that guarantee a new state should be
  /// emitted only if the bloc has not been closed.
  @protected
  void secureEmit(State newState) {
    if (!isClosed) {
      add(newState as Event);
    }
  }
}
