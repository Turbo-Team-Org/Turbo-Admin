import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_admin/core/widgets/admin_scaffold.dart';
import 'package:turbo_admin/core/widgets/data_tables/events_data_table.dart';
import 'package:turbo_admin/features/events/cubit/events_cubit.dart';
import 'package:get_it/get_it.dart';
// import 'package:core/core.dart'; // For models if needed directly

class PlaceholderEventsListPage extends StatelessWidget {
  const PlaceholderEventsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<EventsCubit>()..loadEvents(),
      child: AdminScaffold(
        title: 'Eventos',
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text('Crear Evento'),
          onPressed: () {
            context.goNamed('newEvent');
          },
        ),
        body: BlocBuilder<EventsCubit, EventsState>(
          builder: (context, state) {
            if (state is EventsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is EventsLoaded) {
              return EventsDataTable(
                events: state.events,
                onEdit: (eventId) => context.goNamed('editEvent', pathParameters: {'eventId': eventId}),
                onDelete: (eventId) {
                    showDialog(context: context, builder: (_) => AlertDialog(
                        title: const Text("Confirmar Eliminación"),
                        content: const Text("¿Seguro que quieres eliminar este evento?"),
                        actions: [ TextButton(onPressed: ()=>Navigator.pop(context), child: const Text("Cancelar")), TextButton(onPressed: (){ context.read<EventsCubit>().deleteEvent(eventId); Navigator.pop(context);}, child: Text("Eliminar", style: TextStyle(color: Colors.red))) ],
                    ));
                },
                onRefresh: () => context.read<EventsCubit>().loadEvents(),
                // onView: (eventId) => context.goNamed('viewEvent', pathParameters: {'eventId': eventId}), // Assuming 'viewEvent' route does not exist yet
              );
            }
            if (state is EventsError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Lista de Eventos')); 
          },
        ),
      ),
    );
  }
}
