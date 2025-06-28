import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart'; // For navigation
import 'package:turbo_admin/core/widgets/admin_page.dart';
import 'package:turbo_admin/features/places/cubit/place_form_cubit.dart';
import 'package:turbo_admin/features/places/cubit/place_form_state.dart';
import 'package:turbo_admin/features/auth/cubit/admin_auth_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:html' as html show File, FileReader, DragEvent, window;
import 'dart:typed_data';

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
  late TextEditingController _phoneController;
  late TextEditingController _websiteController;
  late TextEditingController _menuUrlController;
  late TextEditingController _averagePriceController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  late TextEditingController _tagsController;
  late TextEditingController _mainImageController;

  Category? _selectedCategory;
  int _selectedPriceLevel = 0;
  bool _isOpen = true;

  // Horarios de apertura
  Map<String, Map<String, String>> _openingHours = {};

  // Etiquetas
  List<String> _tags = [];

  // Add this flag to the state class
  bool _didLoadData = false;

  List<String> _imageUrls = [];

  bool _isUploadingImage = false;

  static const int maxImageSizeBytes = 3 * 1024 * 1024; // 3MB

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _websiteController = TextEditingController();
    _menuUrlController = TextEditingController();
    _averagePriceController = TextEditingController();
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();
    _tagsController = TextEditingController();
    _mainImageController = TextEditingController();

    // Inicializar horarios por defecto
    _initializeDefaultOpeningHours();
  }

  void _initializeDefaultOpeningHours() {
    final days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ];
    for (final day in days) {
      _openingHours[day] = {
        'open': '09:00',
        'close': '18:00',
        'isOpen': 'true',
      };
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint(
        '🔄 PlaceFormPage: didChangeDependencies - placeId: ${widget.placeId}');
    if (!_didLoadData) {
      _didLoadData = true;
      context.read<PlaceFormCubit>().loadFormData(placeId: widget.placeId);
      // Drag & drop para web
      // Solo registrar una vez
      // ignore: undefined_prefixed_name
      if (identical(0, 0.0)) {
        html.window.onDrop.listen((event) async {
          event.preventDefault();
          if (event.dataTransfer != null &&
              event.dataTransfer!.files != null &&
              event.dataTransfer!.files!.isNotEmpty) {
            final file = event.dataTransfer!.files![0];
            if (file.type.startsWith('image/')) {
              final reader = html.FileReader();
              reader.readAsArrayBuffer(file);
              await reader.onLoad.first;
              final bytes = reader.result as Uint8List;
              // Llama a onAccept del DragTarget manualmente
              if (mounted) {
                setState(() {
                  _isUploadingImage = true;
                });
                final fileName =
                    'places/${DateTime.now().millisecondsSinceEpoch}_${file.name}';
                try {
                  final ref = FirebaseStorage.instance.ref().child(fileName);
                  final uploadTask = await ref.putData(bytes);
                  final url = await uploadTask.ref.getDownloadURL();
                  setState(() {
                    _imageUrls.add(url);
                    if (_mainImageController.text.isEmpty) {
                      _mainImageController.text = url;
                    }
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al subir imagen: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                setState(() {
                  _isUploadingImage = false;
                });
              }
            }
          }
        });
        html.window.onDragOver.listen((event) {
          event.preventDefault();
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _menuUrlController.dispose();
    _averagePriceController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _tagsController.dispose();
    _mainImageController.dispose();
    super.dispose();
  }

  void _initializeControllers(Place? place) {
    if (place != null) {
      _nameController.text = place.name;
      _descriptionController.text = place.description;
      _addressController.text = place.address;
      _phoneController.text = place.phone;
      _websiteController.text = place.website;
      _menuUrlController.text = place.menuUrl;
      _averagePriceController.text = place.averagePrice.toString();
      _latitudeController.text = place.latitude.toString();
      _longitudeController.text = place.longitude.toString();
      _selectedPriceLevel = place.priceLevel;
      _isOpen = place.isOpen;
      _tags = List<String>.from(place.tags);
      _tagsController.text = _tags.join(', ');
      _imageUrls = List<String>.from(place.imageUrls);
      _mainImageController.text = place.mainImage;

      // Cargar horarios si existen
      if (place.openingHours.isNotEmpty) {
        _openingHours =
            Map<String, Map<String, String>>.from(place.openingHours);
      }
    }
  }

  void _clearControllers() {
    _nameController.clear();
    _descriptionController.clear();
    _addressController.clear();
    _phoneController.clear();
    _websiteController.clear();
    _menuUrlController.clear();
    _averagePriceController.clear();
    _latitudeController.clear();
    _longitudeController.clear();
    _tagsController.clear();
    _mainImageController.clear();
    _selectedCategory = null;
    _selectedPriceLevel = 0;
    _isOpen = true;
    _tags = [];
    _imageUrls = [];
    _initializeDefaultOpeningHours();
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
                      _buildContactSection(context, state.place),
                      const SizedBox(height: 24),
                      _buildLocationSection(context, state.place),
                      const SizedBox(height: 24),
                      _buildPricingSection(context, state.place),
                      const SizedBox(height: 24),
                      _buildTagsSection(context, state.place),
                      const SizedBox(height: 24),
                      _buildImagesSection(context, state.place),
                      const SizedBox(height: 24),
                      _buildOpeningHoursSection(context, state.place),
                      const SizedBox(height: 24),
                      _buildStatusSection(context, state.place),
                      const SizedBox(height: 32),
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

  Widget _buildContactSection(BuildContext context, Place? currentPlace) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionTitle('Información de Contacto'),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
              labelText: 'Teléfono', border: OutlineInputBorder()),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _websiteController,
          decoration: const InputDecoration(
              labelText: 'Sitio Web', border: OutlineInputBorder()),
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _menuUrlController,
          decoration: const InputDecoration(
              labelText: 'URL del Menú', border: OutlineInputBorder()),
          keyboardType: TextInputType.url,
        ),
      ],
    );
  }

  Widget _buildLocationSection(BuildContext context, Place? currentPlace) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionTitle('Ubicación'),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _latitudeController,
                decoration: const InputDecoration(
                    labelText: 'Latitud', border: OutlineInputBorder()),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final lat = double.tryParse(value);
                    if (lat == null || lat < -90 || lat > 90) {
                      return 'Latitud debe estar entre -90 y 90';
                    }
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _longitudeController,
                decoration: const InputDecoration(
                    labelText: 'Longitud', border: OutlineInputBorder()),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final lng = double.tryParse(value);
                    if (lng == null || lng < -180 || lng > 180) {
                      return 'Longitud debe estar entre -180 y 180';
                    }
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPricingSection(BuildContext context, Place? currentPlace) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionTitle('Precios'),
        TextFormField(
          controller: _averagePriceController,
          decoration: const InputDecoration(
              labelText: 'Precio Promedio (\$)', border: OutlineInputBorder()),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final price = double.tryParse(value);
              if (price == null || price < 0) {
                return 'El precio debe ser un número positivo';
              }
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          value: _selectedPriceLevel,
          decoration: const InputDecoration(
              labelText: 'Nivel de Precio', border: OutlineInputBorder()),
          items: [
            DropdownMenuItem(value: 0, child: Text('Gratis')),
            DropdownMenuItem(value: 1, child: Text('\$ - Económico')),
            DropdownMenuItem(value: 2, child: Text('\$\$ - Moderado')),
            DropdownMenuItem(value: 3, child: Text('\$\$\$ - Costoso')),
            DropdownMenuItem(value: 4, child: Text('\$\$\$\$ - Muy Costoso')),
          ],
          onChanged: (int? newValue) {
            setState(() {
              _selectedPriceLevel = newValue ?? 0;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTagsSection(BuildContext context, Place? currentPlace) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionTitle('Etiquetas'),
        TextFormField(
          controller: _tagsController,
          decoration: const InputDecoration(
              labelText: 'Etiquetas (separadas por comas)',
              border: OutlineInputBorder(),
              hintText: 'Ej: wifi, parking, terraza, música en vivo'),
          maxLines: 2,
          onChanged: (value) {
            setState(() {
              _tags = value
                  .split(',')
                  .map((tag) => tag.trim())
                  .where((tag) => tag.isNotEmpty)
                  .toList();
            });
          },
        ),
        if (_tags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _tags
                .map((tag) => Chip(
                      label: Text(tag),
                      onDeleted: () {
                        setState(() {
                          _tags.remove(tag);
                          _tagsController.text = _tags.join(', ');
                        });
                      },
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildImagesSection(BuildContext context, Place? currentPlace) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionTitle('Imágenes del Lugar'),
        // Drag & Drop area
        _buildDragDropArea(context),
        const SizedBox(height: 8),
        TextFormField(
          controller: _mainImageController,
          decoration: const InputDecoration(
              labelText: 'URL de la Imagen Principal',
              border: OutlineInputBorder(),
              hintText: 'https://...'),
          onChanged: (value) {
            setState(() {}); // Para refrescar la preview
          },
        ),
        const SizedBox(height: 8),
        if (_mainImageController.text.isNotEmpty)
          Center(
            child: Image.network(
              _mainImageController.text,
              height: 120,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 60),
            ),
          ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Agregar URL de Imagen a la Galería',
                    border: OutlineInputBorder(),
                    hintText: 'https://...'),
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty && !_imageUrls.contains(value)) {
                    setState(() {
                      _imageUrls.add(value);
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text('Subir imagen'),
              onPressed: _isUploadingImage
                  ? null
                  : () async {
                      setState(() {
                        _isUploadingImage = true;
                      });
                      try {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.image,
                          allowMultiple: false,
                          withData: true,
                        );
                        if (result != null &&
                            result.files.single.bytes != null) {
                          final file = result.files.single;
                          if (file.bytes!.length > maxImageSizeBytes) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'La imagen excede el tamaño máximo de 3MB.'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            setState(() {
                              _isUploadingImage = false;
                            });
                            return;
                          }
                          final fileName =
                              'places/${DateTime.now().millisecondsSinceEpoch}_${file.name}';
                          try {
                            final ref =
                                FirebaseStorage.instance.ref().child(fileName);
                            final uploadTask = await ref.putData(file.bytes!);
                            final url = await uploadTask.ref.getDownloadURL();
                            setState(() {
                              _imageUrls.add(url);
                              // Si no hay imagen principal, la ponemos
                              if (_mainImageController.text.isEmpty) {
                                _mainImageController.text = url;
                              }
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error al subir imagen: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        // Error inesperado
                        debugPrint('Error inesperado en picker: $e');
                      } finally {
                        setState(() {
                          _isUploadingImage = false;
                        });
                      }
                    },
            ),
            if (_isUploadingImage) ...[
              const SizedBox(width: 8),
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ]
          ],
        ),
        const SizedBox(height: 8),
        if (_imageUrls.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _imageUrls
                .map((url) => Stack(
                      alignment: Alignment.topRight,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _mainImageController.text = url;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _mainImageController.text == url
                                    ? Colors.green
                                    : Colors.grey,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.network(
                              url,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 40),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.red, size: 18),
                          onPressed: () async {
                            final urlToDelete = url;
                            setState(() {
                              _imageUrls.remove(urlToDelete);
                              if (_mainImageController.text == urlToDelete) {
                                _mainImageController.clear();
                              }
                            });
                            // Solo intentamos borrar si es de nuestro bucket
                            if (urlToDelete
                                .contains('firebasestorage.googleapis.com')) {
                              try {
                                await _deleteImageFromStorage(urlToDelete);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'No se pudo eliminar la imagen del storage: $e'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ))
                .toList(),
          ),
        if (_imageUrls.isEmpty) const Text('No hay imágenes en la galería.'),
        const SizedBox(height: 8),
        const Text(
            'Haz click en una imagen para seleccionarla como principal.'),
      ],
    );
  }

  Widget _buildDragDropArea(BuildContext context) {
    // Solo funciona en web
    return Listener(
      onPointerDown: (_) {},
      child: DragTarget<Uint8List>(
        onWillAccept: (data) => true,
        onAccept: (bytes) async {
          if (bytes.length > maxImageSizeBytes) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('La imagen excede el tamaño máximo de 3MB.'),
                backgroundColor: Colors.orange,
              ),
            );
            return;
          }
          setState(() {
            _isUploadingImage = true;
          });
          final fileName =
              'places/${DateTime.now().millisecondsSinceEpoch}_dropped_image.jpg';
          try {
            final ref = FirebaseStorage.instance.ref().child(fileName);
            final uploadTask = await ref.putData(bytes);
            final url = await uploadTask.ref.getDownloadURL();
            setState(() {
              _imageUrls.add(url);
              if (_mainImageController.text.isEmpty) {
                _mainImageController.text = url;
              }
            });
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al subir imagen: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
          setState(() {
            _isUploadingImage = false;
          });
        },
        builder: (context, candidateData, rejectedData) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(
                  color: _isUploadingImage ? Colors.green : Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: _isUploadingImage
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 12),
                        Text('Subiendo imagen...'),
                      ],
                    )
                  : const Text(
                      'Arrastra y suelta imágenes aquí para subirlas',
                      style: TextStyle(color: Colors.black54),
                    ),
            ),
          );
        },
        onLeave: (data) {},
      ),
    );
  }

  Future<void> _deleteImageFromStorage(String url) async {
    try {
      final storage = FirebaseStorage.instance;
      final ref = storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      // Puede fallar si la URL no es de nuestro bucket o ya fue borrada
      debugPrint('No se pudo eliminar la imagen de storage: $e');
    }
  }

  Widget _buildOpeningHoursSection(BuildContext context, Place? currentPlace) {
    final days = [
      {'key': 'monday', 'label': 'Lunes'},
      {'key': 'tuesday', 'label': 'Martes'},
      {'key': 'wednesday', 'label': 'Miércoles'},
      {'key': 'thursday', 'label': 'Jueves'},
      {'key': 'friday', 'label': 'Viernes'},
      {'key': 'saturday', 'label': 'Sábado'},
      {'key': 'sunday', 'label': 'Domingo'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionTitle('Horarios de Apertura'),
        ...days.map((day) => _buildDaySchedule(day['key']!, day['label']!)),
      ],
    );
  }

  Widget _buildDaySchedule(String dayKey, String dayLabel) {
    final dayHours = _openingHours[dayKey] ??
        {
          'open': '09:00',
          'close': '18:00',
          'isOpen': 'true',
        };

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    dayLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Switch(
                  value: dayHours['isOpen'] == 'true',
                  onChanged: (value) {
                    setState(() {
                      _openingHours[dayKey] = {
                        ...dayHours,
                        'isOpen': value.toString(),
                      };
                    });
                  },
                ),
              ],
            ),
            if (dayHours['isOpen'] == 'true') ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: dayHours['open'],
                      decoration: const InputDecoration(
                        labelText: 'Apertura',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _openingHours[dayKey] = {
                            ...dayHours,
                            'open': value,
                          };
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: dayHours['close'],
                      decoration: const InputDecoration(
                        labelText: 'Cierre',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _openingHours[dayKey] = {
                            ...dayHours,
                            'close': value,
                          };
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context, Place? currentPlace) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionTitle('Estado'),
        SwitchListTile(
          title: const Text('Lugar Abierto'),
          subtitle: const Text('Indica si el lugar está actualmente abierto'),
          value: _isOpen,
          onChanged: (bool value) {
            setState(() {
              _isOpen = value;
            });
          },
        ),
      ],
    );
  }

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

          // Validar campos numéricos
          final averagePrice =
              double.tryParse(_averagePriceController.text) ?? 0.0;
          final latitude = double.tryParse(_latitudeController.text) ?? 0.0;
          final longitude = double.tryParse(_longitudeController.text) ?? 0.0;

          // Construct the Place object from form values
          final placeToSave = Place(
            id: widget.placeId ?? currentPlace?.id ?? '',
            name: _nameController.text,
            description: _descriptionController.text,
            address: _addressController.text,
            categoryId: _selectedCategory!.id,
            categoryName: _selectedCategory!.name,
            mainImage: _mainImageController.text,
            imageUrls: _imageUrls,
            latitude: latitude,
            longitude: longitude,
            rating: currentPlace?.rating ?? 0.0,
            isOpen: _isOpen,
            phone: _phoneController.text,
            website: _websiteController.text,
            menuUrl: _menuUrlController.text,
            averagePrice: averagePrice,
            priceLevel: _selectedPriceLevel,
            tags: _tags,
            openingHours: _openingHours,
            metadata: {
              ...currentPlace?.metadata ?? {},
              'ownerId': currentAdmin.uid, // Agregar ownerId en metadata
            },
            reviews: currentPlace?.reviews ?? [],
            schedules: currentPlace?.schedules ?? [],
            offers: currentPlace?.offers ?? [],
            categoryIcon: currentPlace?.categoryIcon ?? '',
            ownerIds: currentPlace?.ownerIds ?? [],
            createdBy: currentPlace?.createdBy ?? currentAdmin.uid,
            createdAt: currentPlace?.createdAt,
            lastUpdated: DateTime.now(),
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
