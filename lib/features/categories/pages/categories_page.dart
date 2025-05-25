import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_admin/core/widgets/admin_scaffold.dart';
import 'package:turbo_admin/core/widgets/data_tables/categories_data_table.dart';
import 'package:turbo_admin/features/categories/cubit/categories_cubit.dart';
import 'package:get_it/get_it.dart';
// import 'package:core/core.dart'; // For models if needed directly

class PlaceholderCategoriesListPage extends StatelessWidget {
  const PlaceholderCategoriesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<CategoriesCubit>()..loadCategories(),
      child: AdminScaffold(
        title: 'Categorías',
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text('Crear Categoría'),
          onPressed: () {
            context.goNamed('newCategory');
          },
        ),
        body: BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
            if (state is CategoriesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CategoriesLoaded) {
              return CategoriesDataTable(
                categories: state.categories,
                onEdit: (categoryId) => context.goNamed('editCategory', pathParameters: {'categoryId': categoryId}),
                onDelete: (categoryId) {
                    showDialog(context: context, builder: (_) => AlertDialog(
                        title: const Text("Confirmar Eliminación"),
                        content: const Text("¿Seguro que quieres eliminar esta categoría?"),
                        actions: [ TextButton(onPressed: ()=>Navigator.pop(context), child: const Text("Cancelar")), TextButton(onPressed: (){ context.read<CategoriesCubit>().deleteCategory(categoryId); Navigator.pop(context);}, child: Text("Eliminar", style: TextStyle(color: Colors.red))) ],
                    ));
                },
                onRefresh: () => context.read<CategoriesCubit>().loadCategories(),
              );
            }
            if (state is CategoriesError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Lista de Categorías'));
          },
        ),
      ),
    );
  }
}
