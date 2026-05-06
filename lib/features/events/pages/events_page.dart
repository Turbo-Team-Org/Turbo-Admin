import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_admin/core/widgets/admin_page.dart';
import 'package:turbo_admin/core/widgets/data_tables/events_data_table.dart';
import 'package:turbo_admin/features/events/cubit/events_cubit.dart';

class PlaceholderEventsListPage extends StatelessWidget {
  const PlaceholderEventsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<EventsCubit>()..loadEvents(),
      child: AdminPage(
        body: BlocBuilder<EventsCubit, EventsState>(
          builder: (context, state) {
            if (state is EventsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EventsLoaded) {
              return EventsDataTable(
                events: state.events,
                onEdit: (eventId) => context
                    .goNamed('editEvent', pathParameters: {'eventId': eventId}),
                onDelete: (eventId) {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: const Text("Confirmar Eliminación"),
                            content: const Text(
                                "¿Seguro que quieres eliminar este evento?"),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancelar")),
                              TextButton(
                                  onPressed: () {
                                    context
                                        .read<EventsCubit>()
                                        .deleteEvent(eventId);
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Eliminar",
                                      style: TextStyle(color: Colors.red)))
                            ],
                          ));
                },
                onRefresh: () => context.read<EventsCubit>().loadEvents(),
                // onView: (eventId) => context.goNamed('viewEvent', pathParameters: {'eventId': eventId}), // Assuming 'viewEvent' route does not exist yet
              );
            } else if (state is EventsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error cargando eventos',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<EventsCubit>().loadEvents(),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('Estado inicial'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text('Crear Evento'),
          onPressed: () {
            context.goNamed('newEvent');
          },
        ),
      ),
    );
  }
}
