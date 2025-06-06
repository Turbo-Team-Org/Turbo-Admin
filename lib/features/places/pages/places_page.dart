import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_admin/core/widgets/admin_page.dart';
import 'package:turbo_admin/core/widgets/data_tables/places_data_table.dart';
import 'package:turbo_admin/features/places/cubit/places_cubit.dart';
import 'package:turbo_admin/features/places/cubit/places_state.dart';

class PlaceholderPlacesListPage extends StatelessWidget {
  const PlaceholderPlacesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<PlacesCubit>()..loadPlaces(),
      child: AdminPage(
        body: BlocBuilder<PlacesCubit, PlacesState>(
          builder: (context, state) {
            if (state is PlacesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PlacesLoaded) {
              return PlacesDataTable(
                places: state.places,
                onEdit: (placeId) => context
                    .goNamed('editPlace', pathParameters: {'placeId': placeId}),
                onDelete: (placeId) {
                  // Basic confirmation dialog
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: const Text("Confirmar"),
                            content: const Text(
                                "¿Seguro que quieres eliminar este lugar?"),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancelar")),
                              TextButton(
                                  onPressed: () {
                                    context
                                        .read<PlacesCubit>()
                                        .deletePlace(placeId);
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Eliminar",
                                      style: TextStyle(color: Colors.red)))
                            ],
                          ));
                },
                onRefresh: () => context.read<PlacesCubit>().loadPlaces(),
              );
            } else if (state is PlacesError) {
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
                      'Error cargando lugares',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<PlacesCubit>().loadPlaces(),
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
          label: const Text('Crear Lugar'),
          onPressed: () {
            context.goNamed('newPlace');
          },
        ),
      ),
    );
  }
}
