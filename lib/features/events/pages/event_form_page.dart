import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // For date/time picking and formatting
import 'package:turbo_admin/core/widgets/admin_page.dart';
import 'package:turbo_admin/features/events/cubit/event_form_cubit.dart';
import 'package:core/core.dart'; // For Event and Place models
import 'package:turbo_admin/features/auth/cubit/admin_auth_cubit.dart';

class EventFormPage extends StatefulWidget {
  final String? eventId;

  const EventFormPage({super.key, this.eventId});

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _imageUrlController;
  late TextEditingController _linkController;
  late TextEditingController _organizerNameController;
  late TextEditingController _organizerContactController;
  late TextEditingController _priceController;
  late TextEditingController _tagsController;

  Place? _selectedPlace;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  DateTime? _selectedEndDate;
  TimeOfDay? _selectedEndTime;
  EventType _selectedType = EventType.concert;
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    _imageUrlController = TextEditingController();
    _linkController = TextEditingController();
    _organizerNameController = TextEditingController();
    _organizerContactController = TextEditingController();
    _priceController = TextEditingController();
    _tagsController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    _linkController.dispose();
    _organizerNameController.dispose();
    _organizerContactController.dispose();
    _priceController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _initializeControllers(Event? event, List<Place> availablePlaces) {
    if (event != null) {
      _titleController.text = event.title;
      _descriptionController.text = event.description;
      _locationController.text = event.location;
      _imageUrlController.text = event.imageUrl;
      _linkController.text = event.link ?? '';
      _organizerNameController.text = event.organizerName ?? '';
      _organizerContactController.text = event.organizerContact ?? '';
      _priceController.text = event.price?.toString() ?? '';
      _tags = List<String>.from(event.tags);
      _tagsController.text = _tags.join(', ');
      _selectedDate = event.date;
      _selectedTime = TimeOfDay.fromDateTime(event.date);
      _selectedEndDate = event.endDate;
      _selectedEndTime =
          event.endDate != null ? TimeOfDay.fromDateTime(event.endDate!) : null;
      _selectedType = event.type;
      if (event.placeId != null && availablePlaces.isNotEmpty) {
        try {
          _selectedPlace =
              availablePlaces.firstWhere((p) => p.id == event.placeId);
        } catch (e) {
          _selectedPlace = null;
        }
      }
    } else {
      _titleController.clear();
      _descriptionController.clear();
      _locationController.clear();
      _imageUrlController.clear();
      _linkController.clear();
      _organizerNameController.clear();
      _organizerContactController.clear();
      _priceController.clear();
      _tagsController.clear();
      _tags = [];
      _selectedPlace = null;
      _selectedDate = null;
      _selectedTime = null;
      _selectedEndDate = null;
      _selectedEndTime = null;
      _selectedType = EventType.concert;
    }
  }

  Future<void> _pickDate(BuildContext context, {bool isEnd = false}) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isEnd
          ? (_selectedEndDate ?? _selectedDate ?? DateTime.now())
          : (_selectedDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        if (isEnd) {
          _selectedEndDate = pickedDate;
        } else {
          _selectedDate = pickedDate;
        }
      });
    }
  }

  Future<void> _pickTime(BuildContext context, {bool isEnd = false}) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isEnd
          ? (_selectedEndTime ?? TimeOfDay.now())
          : (_selectedTime ?? TimeOfDay.now()),
    );
    if (pickedTime != null) {
      setState(() {
        if (isEnd) {
          _selectedEndTime = pickedTime;
        } else {
          _selectedTime = pickedTime;
        }
      });
    }
  }

  DateTime? _combineDateAndTime(DateTime? date, TimeOfDay? time) {
    if (date == null || time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetIt.instance<EventFormCubit>()..loadForm(eventId: widget.eventId),
      child: AdminPage(
        body: BlocConsumer<EventFormCubit, EventFormState>(
          listener: (context, state) {
            if (state is EventFormSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Evento guardado exitosamente'),
                    backgroundColor: Colors.green),
              );
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/events');
              }
            } else if (state is EventFormError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Error: ${state.message}'),
                    backgroundColor: Colors.red),
              );
            } else if (state is EventFormLoaded) {
              _initializeControllers(state.event, state.places);
            }
          },
          builder: (context, state) {
            if (state is EventFormLoading || state is EventFormInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is EventFormLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildSectionTitle('Información del Evento'),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                            labelText: 'Nombre del Evento',
                            border: OutlineInputBorder()),
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Ingresa un nombre'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            labelText: 'Descripción',
                            border: OutlineInputBorder()),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                            labelText: 'Ubicación (dirección)',
                            border: OutlineInputBorder()),
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Ingresa la ubicación'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildDateTimeSection(context),
                      const SizedBox(height: 16),
                      _buildEndDateTimeSection(context),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _imageUrlController,
                        decoration: const InputDecoration(
                            labelText: 'URL de la Imagen',
                            border: OutlineInputBorder()),
                      ),
                      if (_imageUrlController.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: Image.network(
                              _imageUrlController.text,
                              height: 120,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 60),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _linkController,
                        decoration: const InputDecoration(
                            labelText: 'Enlace (opcional)',
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _organizerNameController,
                        decoration: const InputDecoration(
                            labelText: 'Nombre del Organizador',
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _organizerContactController,
                        decoration: const InputDecoration(
                            labelText: 'Contacto del Organizador',
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(
                            labelText: 'Precio', border: OutlineInputBorder()),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                      const SizedBox(height: 16),
                      _buildTagsSection(context),
                      const SizedBox(height: 16),
                      _buildTypeSection(context),
                      const SizedBox(height: 32),
                      _buildSaveButton(context, state.event),
                    ],
                  ),
                ),
              );
            }
            if (state is EventFormSaving) {
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }

  Widget _buildDateTimeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionTitle('Fecha y Hora de Inicio'),
        Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () => _pickDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                      labelText: 'Fecha de Inicio',
                      border: OutlineInputBorder()),
                  child: Text(_selectedDate != null
                      ? DateFormat('dd MMM yyyy').format(_selectedDate!)
                      : 'No seleccionada'),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () => _pickTime(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                      labelText: 'Hora de Inicio',
                      border: OutlineInputBorder()),
                  child: Text(_selectedTime != null
                      ? _selectedTime!.format(context)
                      : 'No seleccionada'),
                ),
              ),
            ),
          ],
        ),
        if (_selectedDate == null || _selectedTime == null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('Fecha y hora de inicio son requeridas.',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.error, fontSize: 12)),
          )
      ],
    );
  }

  Widget _buildEndDateTimeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionTitle('Fecha y Hora de Fin (opcional)'),
        Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () => _pickDate(context, isEnd: true),
                child: InputDecorator(
                  decoration: const InputDecoration(
                      labelText: 'Fecha de Fin', border: OutlineInputBorder()),
                  child: Text(_selectedEndDate != null
                      ? DateFormat('dd MMM yyyy').format(_selectedEndDate!)
                      : 'No seleccionada'),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () => _pickTime(context, isEnd: true),
                child: InputDecorator(
                  decoration: const InputDecoration(
                      labelText: 'Hora de Fin', border: OutlineInputBorder()),
                  child: Text(_selectedEndTime != null
                      ? _selectedEndTime!.format(context)
                      : 'No seleccionada'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTagsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionTitle('Etiquetas'),
        TextFormField(
          controller: _tagsController,
          decoration: const InputDecoration(
            labelText: 'Etiquetas (separadas por comas)',
            border: OutlineInputBorder(),
            hintText: 'Ej: música, fiesta, familiar',
          ),
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

  Widget _buildTypeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionTitle('Tipo de Evento'),
        DropdownButtonFormField<EventType>(
          value: _selectedType,
          decoration: const InputDecoration(
              labelText: 'Tipo', border: OutlineInputBorder()),
          items: EventType.values.map((EventType type) {
            return DropdownMenuItem<EventType>(
              value: type,
              child: Text(type.name.toUpperCase()),
            );
          }).toList(),
          onChanged: (EventType? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedType = newValue;
              });
            }
          },
          validator: (value) => value == null ? 'Tipo es requerido' : null,
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, Event? currentEvent) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.save),
      label: const Text('Guardar Evento'),
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
      onPressed: () {
        if (_formKey.currentState!.validate() &&
            _selectedDate != null &&
            _selectedTime != null) {
          final DateTime eventDateTime =
              _combineDateAndTime(_selectedDate, _selectedTime)!;
          final DateTime? eventEndDateTime =
              _combineDateAndTime(_selectedEndDate, _selectedEndTime);
          final double? price = double.tryParse(_priceController.text);

          final adminAuthCubit = GetIt.instance<AdminAuthCubit>();
          final currentAdmin = adminAuthCubit.currentAdminUser;
          String? placeId;
          if (currentAdmin != null && currentAdmin.ownedPlaceIds.isNotEmpty) {
            placeId = currentAdmin.ownedPlaceIds.first;
          } else {
            placeId = null;
          }

          if (placeId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'No tienes un lugar asignado. No se puede guardar el evento.'),
                  backgroundColor: Colors.red),
            );
            return;
          }

          final eventToSave = Event(
            id: widget.eventId ?? currentEvent?.id ?? '',
            title: _titleController.text,
            description: _descriptionController.text,
            date: eventDateTime,
            location: _locationController.text,
            imageUrl: _imageUrlController.text,
            type: _selectedType,
            placeId: placeId,
            price: price,
            tags: _tags,
            organizerName: _organizerNameController.text.isNotEmpty
                ? _organizerNameController.text
                : null,
            organizerContact: _organizerContactController.text.isNotEmpty
                ? _organizerContactController.text
                : null,
            endDate: eventEndDateTime,
            link: _linkController.text.isNotEmpty ? _linkController.text : null,
            createdBy: currentEvent?.createdBy ?? '',
            createdAt: currentEvent?.createdAt,
            lastUpdatedBy: currentAdmin?.uid,
            lastUpdatedAt: DateTime.now(),
          );

          context.read<EventFormCubit>().saveEvent(eventToSave);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Por favor corrige los errores e ingresa toda la información requerida.'),
                backgroundColor: Colors.orangeAccent),
          );
        }
      },
    );
  }
}
