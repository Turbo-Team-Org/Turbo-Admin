import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_admin/core/widgets/admin_page.dart';
import 'package:turbo_admin/core/widgets/data_tables/places_data_table.dart';
import 'package:turbo_admin/features/places/cubit/places_cubit.dart';
import 'package:turbo_admin/features/places/cubit/places_state.dart';
import 'package:turbo_admin/features/auth/cubit/admin_auth_cubit.dart';

class PlacesListPage extends StatefulWidget {
  const PlacesListPage({super.key});

  @override
  State<PlacesListPage> createState() => _PlacesListPageState();
}

class _PlacesListPageState extends State<PlacesListPage> {
  bool _didLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didLoad) {
      context.read<PlacesCubit>().loadPlaces();
    }
    _didLoad = true;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AdminPage(
      body: BlocBuilder<PlacesCubit, PlacesState>(
        builder: (context, state) {
          if (state is PlacesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PlacesLoaded) {
            return PlacesDataTable(
              places: state.places,
              onEdit: (placeId) {
                debugPrint(
                    '🔄 PlacesListPage: Editando lugar con ID: $placeId');

                // Verificar autenticación antes de navegar
                final adminAuthCubit = GetIt.instance<AdminAuthCubit>();
                final authState = adminAuthCubit.state;

                if (authState is AdminAuthenticatedAdmin ||
                    authState is AdminAuthenticatedBusinessOwner) {
                  debugPrint(
                      '✅ PlacesListPage: Usuario autenticado, navegando a editar lugar');
                  // Usar pushReplacement para evitar navegaciones duplicadas
                  context.pushReplacementNamed('editPlace',
                      pathParameters: {'placeId': placeId});
                } else {
                  // Si no está autenticado, mostrar mensaje y redirigir al login
                  debugPrint(
                      '❌ PlacesListPage: Usuario no autenticado, redirigiendo al login');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Sesión expirada. Por favor, inicia sesión nuevamente.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  context.go('/login');
                }
              },
              onDelete: (placeId) {
                // Basic confirmation dialog
                showDialog(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                          title: const Text("Confirmar"),
                          content: const Text(
                              "¿Seguro que quieres eliminar este lugar?"),
                          actions: [
                            TextButton(
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(),
                                child: const Text("Cancelar")),
                            TextButton(
                                onPressed: () async {
                                  // Cerrar el diálogo primero
                                  Navigator.of(dialogContext).pop();
                                  // Luego eliminar el lugar
                                  await context
                                      .read<PlacesCubit>()
                                      .deletePlace(placeId);
                                  // Recargar la lista de lugares
                                  if (context.mounted) {
                                    context.read<PlacesCubit>().loadPlaces();
                                  }
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
        backgroundColor:
            isDark ? const Color(0xFFFF5757) : const Color(0xFFE53E3E),
        icon: const Icon(Icons.add),
        label: const Text('Crear Lugar'),
        onPressed: () {
          context.goNamed('newPlace');
        },
      ),
    );
  }
}
