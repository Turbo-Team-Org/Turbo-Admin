import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_admin/core/widgets/admin_scaffold.dart';
import 'package:turbo_admin/core/widgets/data_tables/places_data_table.dart';
import 'package:turbo_admin/features/places/cubit/places_cubit.dart';
import 'package:get_it/get_it.dart';


class PlaceholderPlacesListPage extends StatelessWidget { // Renamed for clarity
  const PlaceholderPlacesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<PlacesCubit>()..loadPlaces(),
      child: AdminScaffold(
        title: 'Lugares',
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text('Crear Lugar'),
          onPressed: () {
            context.goNamed('newPlace');
          },
        ),
        body: BlocBuilder<PlacesCubit, PlacesState>(
          builder: (context, state) {
            if (state is PlacesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is PlacesLoaded) {
              return PlacesDataTable(
                places: state.places,
                onEdit: (placeId) => context.goNamed('editPlace', pathParameters: {'placeId': placeId}),
                onDelete: (placeId) { // Basic confirmation dialog
                    showDialog(context: context, builder: (_) => AlertDialog(
                        title: Text("Confirmar"),
                        content: Text("¿Seguro que quieres eliminar este lugar?"),
                        actions: [ TextButton(onPressed: ()=>Navigator.pop(context), child: Text("Cancelar")), TextButton(onPressed: (){ context.read<PlacesCubit>().deletePlace(placeId); Navigator.pop(context);}, child: Text("Eliminar", style: TextStyle(color: Colors.red))) ],
                    ));
                },
                onRefresh: () => context.read<PlacesCubit>().loadPlaces(),
              );
            }
            if (state is PlacesError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Places List - Placeholder'));
          },
        ),
      ),
    );
  }
}
