import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart'; // For navigation
import 'package:turbo_admin/core/widgets/admin_page.dart';
import 'package:turbo_admin/features/places/cubit/place_form_cubit.dart';
import 'package:turbo_admin/features/places/cubit/place_form_state.dart';
import 'package:turbo_admin/features/auth/cubit/admin_auth_cubit.dart';

class PlaceFormPage extends StatefulWidget {
  final String? placeId;
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

  // Add this flag to the state class
  bool _didLoadData = false;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint(
        '🔄 PlaceFormPage: didChangeDependencies - placeId: ${widget.placeId}');
    if (!_didLoadData) {
      _didLoadData = true;
      context.read<PlaceFormCubit>().loadFormData(placeId: widget.placeId);
    }
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
      _descriptionController.text = place.description;
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
    return AdminPage(
      //  title: widget.placeId == null ? 'Crear Lugar' : 'Editar Lugar',
      body: BlocListener<PlaceFormCubit, PlaceFormState>(
        listener: (context, state) {
          debugPrint(
              '🔄 PlaceFormPage: Estado cambiado a: ${state.runtimeType}');

          if (state is PlaceFormSuccess) {
            debugPrint(
                '✅ PlaceFormPage: Lugar guardado exitosamente, navegando de vuelta');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Lugar guardado exitosamente'),
                  backgroundColor: Colors.green),
            );

            // Limpiar el estado del cubit antes de navegar
            final cubit = context.read<PlaceFormCubit>();
            cubit.clearState();

            // Navigate back to places list or details page
            if (context.canPop()) {
              context.pop(true); // Indica que SÍ hubo cambios
            } else {
              context.go('/places'); // Fallback route
            }
          } else if (state is PlaceFormError) {
            debugPrint('❌ PlaceFormPage: Error en estado: ${state.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Error: ${state.message}'),
                  backgroundColor: Colors.red),
            );
          } else if (state is PlaceFormLoaded) {
            debugPrint(
                '✅ PlaceFormPage: Datos cargados - Lugar: ${state.place?.name ?? 'Nuevo'}, Categorías: ${state.categories.length}');
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
        child: BlocBuilder<PlaceFormCubit, PlaceFormState>(
          builder: (context, state) {
            debugPrint(
                '🔄 PlaceFormPage: Builder llamado con estado: ${state.runtimeType}');

            if (state is PlaceFormLoading || state is PlaceFormInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PlaceFormLoaded) {
              debugPrint(
                  '✅ PlaceFormPage: Renderizando formulario con datos cargados');
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Nueva fila de encabezado con flecha y título
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            tooltip: 'Atrás',
                            onPressed: () {
                              if (context.canPop()) {
                                context
                                    .pop(false); // Indica que NO hubo cambios
                              } else {
                                context.go('/places');
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.placeId == null
                                ? 'Crear Lugar'
                                : 'Editar Lugar',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
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

            if (state is PlaceFormSuccess) {
              debugPrint('✅ PlaceFormPage: Renderizando estado de éxito');
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 64,
                      color: Colors.green,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Lugar guardado exitosamente',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Redirigiendo...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            if (state is PlaceFormError) {
              debugPrint(
                  '❌ PlaceFormPage: Renderizando estado de error: ${state.message}');
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
                      'Error al cargar el formulario',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        final cubit = context.read<PlaceFormCubit>();
                        cubit.clearState();
                        cubit.loadFormData(placeId: widget.placeId);
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            debugPrint(
                '⚠️ PlaceFormPage: Estado no manejado: ${state.runtimeType}');
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
          _formKey.currentState!.save();

          // Obtener el admin actual
          final adminAuthCubit = GetIt.instance<AdminAuthCubit>();
          final currentAdmin = adminAuthCubit.currentAdminUser;

          if (currentAdmin == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error: No hay un administrador autenticado'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          // Construct the Place object from form values
          final placeToSave = Place(
            id: widget.placeId ?? currentPlace?.id ?? '',
            name: _nameController.text,
            description: _descriptionController.text,
            address: _addressController.text,
            categoryId: _selectedCategory!.id,
            categoryName: _selectedCategory!.name,
            mainImage: currentPlace?.mainImage ?? '',
            imageUrls: currentPlace?.imageUrls ?? [],
            latitude: currentPlace?.latitude ?? 0.0,
            longitude: currentPlace?.longitude ?? 0.0,
            rating: currentPlace?.rating ?? 0.0,
            isOpen: currentPlace?.isOpen ?? true,
            phone: currentPlace?.phone ?? '',
            website: currentPlace?.website ?? '',
            metadata: {
              ...currentPlace?.metadata ?? {},
              'ownerId': currentAdmin.uid, // Agregar ownerId en metadata
            },
            averagePrice: currentPlace?.averagePrice ?? 0.0,
            reviews: currentPlace?.reviews ?? [],
            menuUrl: currentPlace?.menuUrl ?? '',
            schedules: currentPlace?.schedules ?? [],
            offers: currentPlace?.offers ?? [],
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
