import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart'; // For navigation
import 'package:turbo_admin/core/widgets/admin_page.dart';
import 'package:turbo_admin/features/places/cubit/place_form_cubit.dart';
import 'package:core/core.dart'; // For Place and Category models

// Assuming Place and Category models are correctly exported from package:core/core.dart
// e.g., import 'package:core/models/place.dart';
// import 'package:core/models/category.dart';

class PlaceFormPage extends StatefulWidget {
  final String? placeId; // Nullable for creating a new place

  const PlaceFormPage({super.key, this.placeId});

  @override
  State<PlaceFormPage> createState() => _PlaceFormPageState();
}

class _PlaceFormPageState extends State<PlaceFormPage> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers for form fields
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  // Add controllers for other Place fields as needed (e.g., latitude, longitude, phone, website)
  // For example:
  // late TextEditingController _latitudeController;
  // late TextEditingController _longitudeController;
  // late TextEditingController _phoneController;

  Category? _selectedCategory;
  // Placeholder for other fields like images, schedule, etc.
  // List<String> _imageUrls = [];
  // bool _isOpen = true; // Example for a schedule field

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _addressController = TextEditingController();
    // Initialize other controllers
    // _latitudeController = TextEditingController();
    // _longitudeController = TextEditingController();
    // _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    // Dispose other controllers
    // _latitudeController.dispose();
    // _longitudeController.dispose();
    // _phoneController.dispose();
    super.dispose();
  }

  void _initializeControllers(Place? place) {
    if (place != null) {
      _nameController.text = place.name;
      _descriptionController.text = place.description ?? '';
      _addressController.text = place.address;
      // _latitudeController.text = place.latitude?.toString() ?? '';
      // _longitudeController.text = place.longitude?.toString() ?? '';
      // _phoneController.text = place.phone ?? '';
      // _selectedCategory = place.category; // Assuming Place has a Category object
      // _imageUrls = List<String>.from(place.imageUrls ?? []);
      // _isOpen = place.isOpen; // Assuming this field exists
    }
  }

  void _clearControllers() {
    _nameController.clear();
    _descriptionController.clear();
    _addressController.clear();
    // _latitudeController.clear();
    // _longitudeController.clear();
    // _phoneController.clear();
    _selectedCategory = null;
    // _imageUrls = [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetIt.instance<PlaceFormCubit>()..loadForm(placeId: widget.placeId),
      child: AdminPage(
        //  title: widget.placeId == null ? 'Crear Lugar' : 'Editar Lugar',
        body: BlocConsumer<PlaceFormCubit, PlaceFormState>(
          listener: (context, state) {
            if (state is PlaceFormSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Lugar guardado exitosamente'),
                    backgroundColor: Colors.green),
              );
              // Navigate back to places list or details page
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/places'); // Fallback route
              }
            } else if (state is PlaceFormError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Error: ${state.message}'),
                    backgroundColor: Colors.red),
              );
            } else if (state is PlaceFormLoaded) {
              if (widget.placeId == null && state.place == null) {
                // Creating new
                _clearControllers(); // Clear fields for new entry
              } else {
                // Editing existing or loaded existing
                _initializeControllers(state.place);
                // Ensure _selectedCategory is set if editing and categories are loaded
                if (state.place?.categoryId != null &&
                    state.categories.isNotEmpty) {
                  try {
                    _selectedCategory = state.categories
                        .firstWhere((cat) => cat.id == state.place!.categoryId);
                  } catch (e) {
                    // Category might not be in the list, handle appropriately
                    _selectedCategory = null;
                  }
                }
              }
            }
          },
          builder: (context, state) {
            if (state is PlaceFormLoading || state is PlaceFormInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PlaceFormLoaded) {
              // _initializeControllers(state.place); // Moved to listener to avoid issues with multiple builds

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildBasicInfoSection(context, state.place),
                      const SizedBox(height: 24),
                      _buildCategorySection(
                          context, state.categories, state.place),
                      const SizedBox(height: 24),
                      // _buildLocationSection(context, state.place),
                      // const SizedBox(height: 24),
                      // _buildImagesSection(context, state.place),
                      // const SizedBox(height: 24),
                      // _buildScheduleSection(context, state.place),
                      // const SizedBox(height: 32),
                      _buildSaveButton(context, state.place),
                    ],
                  ),
                ),
              );
            }

            if (state is PlaceFormSaving) {
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
                child: Text('Algo salió mal. Por favor, intenta de nuevo.'));
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }

  Widget _buildBasicInfoSection(BuildContext context, Place? currentPlace) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionTitle('Información Básica'),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
              labelText: 'Nombre del Lugar', border: OutlineInputBorder()),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa un nombre';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
              labelText: 'Descripción', border: OutlineInputBorder()),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
              labelText: 'Dirección', border: OutlineInputBorder()),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa una dirección';
            }
            return null;
          },
        ),
        // Add more fields like phone, website etc.
      ],
    );
  }

  Widget _buildCategorySection(
      BuildContext context, List<Category> categories, Place? currentPlace) {
    // This ensures that _selectedCategory is updated if categories load after the place data or vice-versa
    if (_selectedCategory == null &&
        currentPlace?.categoryId != null &&
        categories.isNotEmpty) {
      try {
        _selectedCategory =
            categories.firstWhere((cat) => cat.id == currentPlace!.categoryId);
      } catch (e) {
        _selectedCategory = null; // Category not found
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionTitle('Categoría'),
        if (categories.isEmpty)
          const Text(
              'No hay categorías disponibles. Por favor, crea una primero.')
        else
          DropdownButtonFormField<Category>(
            value: _selectedCategory,
            decoration: const InputDecoration(
                labelText: 'Selecciona una Categoría',
                border: OutlineInputBorder()),
            items: categories.map((Category category) {
              return DropdownMenuItem<Category>(
                value: category,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: (Category? newValue) {
              setState(() {
                _selectedCategory = newValue;
              });
            },
            validator: (value) =>
                value == null ? 'Categoría es requerida' : null,
          ),
      ],
    );
  }

  // Placeholder for other sections like _buildLocationSection, _buildImagesSection, _buildScheduleSection
  // These would contain TextFormFields for latitude/longitude, image pickers, and schedule inputs

  Widget _buildSaveButton(BuildContext context, Place? currentPlace) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.save),
      label: const Text('Guardar Lugar'),
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!
              .save(); // Not strictly necessary with controllers usually

          // Construct the Place object from form values
          // This is a simplified version. A real Place object would have more fields.
          // Ensure all required fields from your core.Place model are included.
          final placeToSave = Place(
            id: widget.placeId ??
                currentPlace?.id ??
                '', // Use currentPlace?.id if available and widget.placeId is null (e.g. after failed save)
            name: _nameController.text,
            description: _descriptionController.text,
            address: _addressController.text,
            categoryId:
                _selectedCategory!.id, // Ensure _selectedCategory is not null
            categoryName: _selectedCategory!
                .name, // Store name for convenience if needed by UI

            // --- Defaults for other required fields from Place model ---
            // These must match your Place model definition in turbo_core
            // Use currentPlace values if editing, or sensible defaults if creating
            mainImage: currentPlace?.mainImage ??
                '', // Placeholder, image handling is complex
            imageUrls: currentPlace?.imageUrls ?? [], // Placeholder
            latitude:
                currentPlace?.latitude ?? 0.0, // Default or from map picker
            longitude:
                currentPlace?.longitude ?? 0.0, // Default or from map picker
            rating: currentPlace?.rating ??
                0.0, // Usually calculated, not set directly

            isOpen: currentPlace?.isOpen ?? true, // Default state
            phone: currentPlace?.phone ?? '',
            website: currentPlace?.website ?? '',
            metadata: currentPlace?.metadata ?? {},
            averagePrice: currentPlace?.averagePrice ?? 0.0,
            reviews: currentPlace?.reviews ??
                [], // This might need to be set based on logged-in user
            menuUrl: currentPlace?.menuUrl ?? '',
            schedules: currentPlace?.schedules ?? [],
            offers: currentPlace?.offers ??
                [], // This might need to be set based on logged-in user
            tags: currentPlace?.tags ?? [],
            categoryIcon: currentPlace?.categoryIcon ?? '',
            openingHours: currentPlace?.openingHours ?? {},
            priceLevel: 0,
          );

          context.read<PlaceFormCubit>().savePlace(placeToSave);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Por favor corrige los errores en el formulario.'),
                backgroundColor: Colors.orangeAccent),
          );
        }
      },
    );
  }
}
