import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart'; // For navigation
import 'package:turbo_admin/core/widgets/admin_page.dart';
import 'package:turbo_admin/features/places/cubit/place_form_cubit.dart';
import 'package:turbo_admin/features/places/cubit/place_form_state.dart';
import 'package:turbo_admin/features/auth/cubit/admin_auth_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:ui' as ui;

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

  // Hasta 3 URLs de imágenes adicionales
  List<TextEditingController> _imageUrlControllers =
      List.generate(3, (_) => TextEditingController());

  late GoogleMapController? _mapController;
  LatLng? _selectedLatLng;

  final String _googleMapsApiKey = 'AIzaSyAVutR13I58yvzsHjV5ZLtS9pHfe4cLsJ8';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<dynamic> _placePredictions = [];
  bool _isLocating = false;

  String _autocompleteInputId = 'autocomplete-input';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _websiteController = TextEditingController();
    _menuUrlController = TextEditingController();
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();
    _tagsController = TextEditingController();
    _mainImageController = TextEditingController();
    _imageUrlControllers = List.generate(3, (_) => TextEditingController());
    // Inicializar horarios por defecto
    _initializeDefaultOpeningHours();
    _mapController = null;
    _selectedLatLng = null;
    _getUserLocation();
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus) {
        setState(() {
          _placePredictions = [];
        });
      }
    });
    _autocompleteInputId =
        'autocomplete-input-${DateTime.now().millisecondsSinceEpoch}';
    // Registrar el viewType para el widget HTML solo una vez
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      _autocompleteInputId,
      (int viewId) {
        final input = html.InputElement()
          ..id = _autocompleteInputId
          ..placeholder = 'Buscar dirección...'
          ..style.width = '100%'
          ..style.height = '40px'
          ..style.fontSize = '16px';
        // Inicializar Google Places Autocomplete
        Future.delayed(const Duration(milliseconds: 100), () {
          js.context
              .callMethod('initPlacesAutocomplete', [_autocompleteInputId]);
        });
        return input;
      },
    );
    // Escuchar mensajes de selección
    html.window.onMessage.listen((event) {
      final data = event.data;
      if (data is Map && data['type'] == 'places_autocomplete_selected') {
        final lat = data['lat'];
        final lng = data['lng'];
        if (lat != null && lng != null) {
          final latLng =
              LatLng((lat as num).toDouble(), (lng as num).toDouble());
          setState(() {
            _selectedLatLng = latLng;
          });
          _moveCamera(latLng);
        }
      }
    });
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
    _latitudeController.dispose();
    _longitudeController.dispose();
    _tagsController.dispose();
    _mainImageController.dispose();
    for (final c in _imageUrlControllers) {
      c.dispose();
    }
    _searchController.dispose();
    _searchFocusNode.dispose();
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
      _latitudeController.text = place.latitude.toString();
      _longitudeController.text = place.longitude.toString();
      _selectedPriceLevel = place.priceLevel;
      _isOpen = place.isOpen;
      _tags = List<String>.from(place.tags);
      _tagsController.text = _tags.join(', ');
      // Inicializar los controladores de las 3 imágenes adicionales
      for (int i = 0; i < 3; i++) {
        if (place.imageUrls.length > i) {
          _imageUrlControllers[i].text = place.imageUrls[i];
        } else {
          _imageUrlControllers[i].clear();
        }
      }
      _mainImageController.text = place.mainImage;

      // Cargar horarios si existen
      if (place.openingHours.isNotEmpty) {
        _openingHours =
            Map<String, Map<String, String>>.from(place.openingHours);
      }

      final lat = place.latitude;
      final lng = place.longitude;

      _selectedLatLng =
          LatLng((lat as num).toDouble(), (lng as num).toDouble());
    }
  }

  void _clearControllers() {
    _nameController.clear();
    _descriptionController.clear();
    _addressController.clear();
    _phoneController.clear();
    _websiteController.clear();
    _menuUrlController.clear();
    _latitudeController.clear();
    _longitudeController.clear();
    _tagsController.clear();
    _mainImageController.clear();
    _selectedCategory = null;
    _selectedPriceLevel = 0;
    _isOpen = true;
    _tags = [];
    for (final c in _imageUrlControllers) {
      c.clear();
    }
    _initializeDefaultOpeningHours();
    _selectedLatLng = null;
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
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: HtmlElementView(viewType: _autocompleteInputId),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            SizedBox(
              height: 320,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target:
                      _selectedLatLng ?? const LatLng(19.432608, -99.133209),
                  zoom: 14,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                markers: _selectedLatLng != null
                    ? {
                        Marker(
                          markerId: const MarkerId('selected-location'),
                          position: _selectedLatLng!,
                        ),
                      }
                    : {},
                onTap: (latLng) {
                  setState(() {
                    _selectedLatLng = latLng;
                  });
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
              ),
            ),
            Positioned(
              top: 16,
              right: 12,
              child: FloatingActionButton(
                mini: true,
                heroTag: 'center_location',
                onPressed: _getUserLocation,
                child: const Icon(Icons.my_location),
                tooltip: 'Centrar en mi ubicación',
              ),
            ),
            if (_isLocating)
              const Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (_selectedLatLng != null)
          Builder(
            builder: (context) {
              final lat = _selectedLatLng?.latitude ?? 0.0;
              final lng = _selectedLatLng?.longitude ?? 0.0;
              return Text(
                  'Latitud: ${lat.toStringAsFixed(6)}, Longitud: ${lng.toStringAsFixed(6)}');
            },
          ),
        if (_selectedLatLng == null)
          const Text('Haz click en el mapa para seleccionar la ubicación.'),
      ],
    );
  }

  Widget _buildPricingSection(BuildContext context, Place? currentPlace) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionTitle('Precios'),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          value: _selectedPriceLevel,
          decoration: const InputDecoration(
              labelText: 'Nivel de Precio', border: OutlineInputBorder()),
          items: const [
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
        const SizedBox(height: 8),
        TextFormField(
          controller: _mainImageController,
          decoration: const InputDecoration(
              labelText: 'URL de la Imagen Principal',
              border: OutlineInputBorder(),
              hintText: 'https://...'),
          onChanged: (_) => setState(() {}),
        ),
        if (_mainImageController.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: Image.network(
                _mainImageController.text,
                height: 120,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 60),
              ),
            ),
          ),
        const SizedBox(height: 16),
        for (int i = 0; i < 3; i++) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextFormField(
              controller: _imageUrlControllers[i],
              decoration: InputDecoration(
                  labelText: 'URL de Imagen Adicional #${i + 1}',
                  border: const OutlineInputBorder(),
                  hintText: 'https://...'),
              onChanged: (_) => setState(() {}),
            ),
          ),
          if (_imageUrlControllers[i].text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Center(
                child: Image.network(
                  _imageUrlControllers[i].text,
                  height: 100,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 40),
                ),
              ),
            ),
        ],
        const Text('Puedes agregar hasta 3 imágenes adicionales.'),
      ],
    );
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

          if (_selectedLatLng == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Por favor selecciona la ubicación en el mapa.'),
                backgroundColor: Colors.orange,
              ),
            );
            return;
          }
          final latitude = _selectedLatLng!.latitude;
          final longitude = _selectedLatLng!.longitude;

          // Construir la lista de imágenes adicionales
          final imageUrls = _imageUrlControllers
              .map((c) => c.text)
              .where((url) => url.isNotEmpty)
              .toList();
          // Construct the Place object from form values
          final placeToSave = Place(
            id: widget.placeId ?? currentPlace?.id ?? '',
            name: _nameController.text,
            description: _descriptionController.text,
            address: _addressController.text,
            categoryId: _selectedCategory!.id,
            categoryName: _selectedCategory!.name,
            mainImage: _mainImageController.text,
            imageUrls: imageUrls,
            latitude: latitude,
            longitude: longitude,
            rating: currentPlace?.rating ?? 0.0,
            isOpen: _isOpen,
            phone: _phoneController.text,
            website: _websiteController.text,
            menuUrl: _menuUrlController.text,
            priceLevel: _selectedPriceLevel,
            tags: _tags,
            openingHours: _openingHours,
            metadata: {
              ...currentPlace?.metadata ?? {},
            },
            reviews: currentPlace?.reviews ?? [],
            offers: currentPlace?.offers ?? [],
            ownerIds: currentPlace?.ownerIds ?? [currentAdmin.uid],
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

  Future<void> _getUserLocation() async {
    setState(() => _isLocating = true);
    try {
      // Usar la API de geolocalización del navegador
      final position = await _getBrowserLocation();
      if (position != null) {
        final lat = position['lat'];
        final lng = position['lng'];
        if (lat != null && lng != null) {
          final latLng =
              LatLng((lat as num).toDouble(), (lng as num).toDouble());
          setState(() {
            _selectedLatLng = latLng;
          });
          _moveCamera(latLng);
        }
      }
    } catch (e) {
      // Si falla, no hacer nada (se queda en CDMX por defecto)
    } finally {
      setState(() => _isLocating = false);
    }
  }

  Future<Map<String, double>?> _getBrowserLocation() async {
    try {
      final completer = Completer<Map<String, double>?>();
      // ignore: undefined_prefixed_name
      html.window.navigator.geolocation.getCurrentPosition().then((pos) {
        final lat = pos.coords?.latitude;
        final lng = pos.coords?.longitude;
        completer.complete({
          'lat': lat != null ? lat.toDouble() : 0.0,
          'lng': lng != null ? lng.toDouble() : 0.0,
        });
      }).catchError((_) => completer.complete(null));
      return await completer.future;
    } catch (_) {
      return null;
    }
  }

  void _moveCamera(LatLng latLng) {
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    }
  }

  void _onSearchChanged() async {
    final input = _searchController.text;
    if (input.length < 3) {
      setState(() => _placePredictions = []);
      return;
    }
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$_googleMapsApiKey&language=es');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _placePredictions = data['predictions'] ?? [];
      });
    }
  }

  Future<void> _selectPrediction(dynamic prediction) async {
    final placeId = prediction['place_id'];
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_googleMapsApiKey&language=es');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final location = data['result']['geometry']['location'];
      final latLng = LatLng(location['lat'], location['lng']);
      setState(() {
        _selectedLatLng = latLng;
        _searchController.text = data['result']['formatted_address'] ?? '';
        _placePredictions = [];
      });
      _moveCamera(latLng);
    }
  }
}
