import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_admin/core/widgets/admin_page.dart';
import 'package:turbo_admin/core/widgets/data_tables/categories_data_table.dart';
import 'package:turbo_admin/features/categories/cubit/categories_cubit.dart';

class PlaceholderCategoriesListPage extends StatelessWidget {
  const PlaceholderCategoriesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<CategoriesCubit>()..loadCategories(),
      child: AdminPage(
        body: BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
            if (state is CategoriesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CategoriesLoaded) {
              return CategoriesDataTable(
                categories: state.categories,
                onEdit: (categoryId) => context.goNamed('editCategory',
                    pathParameters: {'categoryId': categoryId}),
                onDelete: (categoryId) {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: const Text("Confirmar Eliminación"),
                            content: const Text(
                                "¿Seguro que quieres eliminar esta categoría?"),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancelar")),
                              TextButton(
                                  onPressed: () {
                                    context
                                        .read<CategoriesCubit>()
                                        .deleteCategory(categoryId);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Eliminar",
                                      style: TextStyle(color: Colors.red)))
                            ],
                          ));
                },
                onRefresh: () =>
                    context.read<CategoriesCubit>().loadCategories(),
              );
            } else if (state is CategoriesError) {
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
                      'Error cargando categorías',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<CategoriesCubit>().loadCategories(),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Implementar navegación a formulario de nueva categoría
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
