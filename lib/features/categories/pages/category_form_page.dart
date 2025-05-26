import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_admin/core/widgets/admin_scaffold.dart';
import 'package:turbo_admin/features/categories/cubit/category_form_cubit.dart';
import 'package:core/core.dart'; // For Category model

class CategoryFormPage extends StatefulWidget {
  final String? categoryId;

  const CategoryFormPage({super.key, this.categoryId});

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _slugController;
  late TextEditingController _iconUrlController; // For icon URL
  // Category? _selectedParentCategory; // If supporting parent categories

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _slugController = TextEditingController();
    _iconUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _slugController.dispose();
    _iconUrlController.dispose();
    super.dispose();
  }

  void _initializeControllers(Category? category) {
    if (category != null) {
      _nameController.text = category.name;
      _descriptionController.text = category.description ?? '';
      _slugController.text = category.imageUrl ?? '';
      _iconUrlController.text = category.icon ?? '';
      // If loading parent categories in CategoryFormCubit:
      // if (category.parentId != null && loadedParentCategories.isNotEmpty) {
      //   _selectedParentCategory = loadedParentCategories.firstWhere((p) => p.id == category.parentId, orElse: () => null);
      // }
    } else {
      // For new category
      _nameController.clear();
      _descriptionController.clear();
      _slugController.clear();
      _iconUrlController.clear();
      // _selectedParentCategory = null;
    }
  }

  // Auto-generate slug from name
  void _generateSlugFromName() {
    final name = _nameController.text;
    final slug = name
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '-') // Replace spaces with hyphens
        .replaceAll(RegExp(r'[^\w-]'),
            ''); // Remove non-alphanumeric characters except hyphens
    _slugController.text = slug;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<CategoryFormCubit>()
        ..loadForm(categoryId: widget.categoryId),
      child: AdminScaffold(
        title:
            widget.categoryId == null ? 'Crear Categoría' : 'Editar Categoría',
        body: BlocConsumer<CategoryFormCubit, CategoryFormState>(
          listener: (context, state) {
            if (state is CategoryFormSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Categoría guardada exitosamente.'),
                    backgroundColor: Colors.green),
              );
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/categories'); // Fallback route
              }
            } else if (state is CategoryFormError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Error: ${state.message}'),
                    backgroundColor: Colors.red),
              );
            } else if (state is CategoryFormLoaded) {
              _initializeControllers(state.category);
            }
          },
          builder: (context, state) {
            if (state is CategoryFormLoading || state is CategoryFormInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CategoryFormLoaded) {
              // _initializeControllers(state.category); // Moved to listener

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildCategoryFields(context, state),
                      const SizedBox(height: 32),
                      _buildSaveButton(context, state.category),
                    ],
                  ),
                ),
              );
            }

            if (state is CategoryFormSaving) {
              return const Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text("Guardando...")
                ],
              ));
            }

            return const Center(
                child: Text('Error al cargar datos del formulario.'));
          },
        ),
      ),
    );
  }

  Widget _buildCategoryFields(BuildContext context, CategoryFormLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Detalles de la Categoría',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 20),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
              labelText: 'Nombre de Categoría', border: OutlineInputBorder()),
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Ingresa un nombre' : null,
          onChanged: (_) =>
              _generateSlugFromName(), // Auto-generate slug when name changes
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _slugController,
          decoration: InputDecoration(
              labelText: 'Slug (auto-generado)',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(Icons.refresh),
                tooltip: "Regenerar Slug",
                onPressed: _generateSlugFromName,
              )),
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Ingresa un slug' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
              labelText: 'Descripción (opcional)',
              border: OutlineInputBorder()),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _iconUrlController,
          decoration: const InputDecoration(
              labelText: 'URL del Icono (opcional)',
              border: OutlineInputBorder()),
        ),
        // Add Dropdown for parent category if implemented in CategoryFormLoaded state
        // if (state.parentCategories.isNotEmpty) ...[
        //   const SizedBox(height: 16),
        //   DropdownButtonFormField<Category>(
        //     value: _selectedParentCategory,
        //     decoration: const InputDecoration(labelText: 'Categoría Padre (opcional)', border: OutlineInputBorder()),
        //     items: state.parentCategories.map((Category cat) {
        //       return DropdownMenuItem<Category>(value: cat, child: Text(cat.name));
        //     }).toList(),
        //     onChanged: (Category? newValue) {
        //       setState(() { _selectedParentCategory = newValue; });
        //     },
        //   ),
        // ],
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, Category? currentCategory) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.save),
      label: const Text('Guardar Categoría'),
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Construct Category object
          final categoryToSave = Category(
            id: widget.categoryId ?? currentCategory?.id ?? '',
            name: _nameController.text,
            description: _descriptionController.text,
            imageUrl: _iconUrlController.text,
            icon: _iconUrlController.text,
            // parentId: _selectedParentCategory?.id,

            // Ensure all required fields from core.Category are present
            // Example: if 'createdAt' or 'updatedAt' are managed by client
            metadata: currentCategory?.metadata ?? {},
            // Add any other fields your Category model might have
            // e.g. order, isFeatured etc.
            placesCount: currentCategory?.placesCount ?? 0, // Example field
            // parentId: currentCategory?.parentId, // ensure this is handled if you have parent categories
            // order: currentCategory?.order ?? 0, // example field
          );

          context.read<CategoryFormCubit>().saveCategory(categoryToSave);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Por favor corrige los errores.'),
                backgroundColor: Colors.orangeAccent),
          );
        }
      },
    );
  }
}
