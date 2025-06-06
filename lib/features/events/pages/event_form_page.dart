import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // For date/time picking and formatting
import 'package:turbo_admin/core/widgets/admin_page.dart';
import 'package:turbo_admin/features/events/cubit/event_form_cubit.dart';
import 'package:core/core.dart'; // For Event and Place models

class EventFormPage extends StatelessWidget {
  final String? eventId;

  const EventFormPage({super.key, this.eventId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetIt.instance<EventFormCubit>()..loadForm(eventId: eventId),
      child: AdminPage(
        body: BlocBuilder<EventFormCubit, EventFormState>(
          builder: (context, state) {
            if (state is EventFormLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EventFormLoaded) {
              return const Center(
                child: Text('Formulario de evento (placeholder)'),
              );
            } else if (state is EventFormError) {
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
                      'Error cargando formulario',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context
                          .read<EventFormCubit>()
                          .loadForm(eventId: eventId),
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
      ),
    );
  }
}


// class EventFormPage extends StatefulWidget {
//   final String? eventId;

//   const EventFormPage({super.key, this.eventId});

//   @override
//   State<EventFormPage> createState() => _EventFormPageState();
// }

// class _EventFormPageState extends State<EventFormPage> {
//   final _formKey = GlobalKey<FormState>();

//   late TextEditingController _nameController;
//   late TextEditingController _descriptionController;
//   // late TextEditingController _venueDetailsController; // e.g. specific room or area

//   Place? _selectedPlace;
//   DateTime? _selectedDate;
//   TimeOfDay? _selectedTime;
//   EventType _selectedStatus = EventType.concert; // Default status

//   // Add controllers for other Event fields as needed (e.g., ticketPrice, capacity)

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController();
//     _descriptionController = TextEditingController();
//     // _venueDetailsController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _descriptionController.dispose();
//     // _venueDetailsController.dispose();
//     super.dispose();
//   }

//   void _initializeControllers(Event? event, List<Place> availablePlaces) {
//     if (event != null) {
//       _nameController.text = event.title;
//       _descriptionController.text = event.description ?? '';
//       // _venueDetailsController.text = event.venueDetails ?? '';
//       _selectedDate = event.date;
//       _selectedTime = TimeOfDay.fromDateTime(event.date);
//       _selectedStatus = event.type;

//       if (event.placeId != null && availablePlaces.isNotEmpty) {
//         try {
//           _selectedPlace =
//               availablePlaces.firstWhere((p) => p.id == event.placeId);
//         } catch (e) {
//           _selectedPlace = null; // Place not found in the list
//         }
//       }
//     } else {
//       // Reset for new form
//       _nameController.clear();
//       _descriptionController.clear();
//       // _venueDetailsController.clear();
//       _selectedPlace = null;
//       _selectedDate = null;
//       _selectedTime = null;
//       _selectedStatus = EventType.concert;
//     }
//   }

//   Future<void> _pickDate(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (pickedDate != null && pickedDate != _selectedDate) {
//       setState(() {
//         _selectedDate = pickedDate;
//       });
//     }
//   }

//   Future<void> _pickTime(BuildContext context) async {
//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: _selectedTime ?? TimeOfDay.now(),
//     );
//     if (pickedTime != null && pickedTime != _selectedTime) {
//       setState(() {
//         _selectedTime = pickedTime;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) =>
//           GetIt.instance<EventFormCubit>()..loadForm(eventId: widget.eventId),
//       child: AdminScaffold(
//         title: widget.eventId == null ? 'Crear Evento' : 'Editar Evento',
//         body: BlocConsumer<EventFormCubit, EventFormState>(
//           listener: (context, state) {
//             if (state is EventFormSuccess) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                     content: Text('Evento guardado exitosamente'),
//                     backgroundColor: Colors.green),
//               );
//               if (context.canPop()) {
//                 context.pop();
//               } else {
//                 context.go('/events'); // Fallback route
//               }
//             } else if (state is EventFormError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                     content: Text('Error: ${state.message}'),
//                     backgroundColor: Colors.red),
//               );
//             } else if (state is EventFormLoaded) {
//               _initializeControllers(state.event, state.places);
//             }
//           },
//           builder: (context, state) {
//             if (state is EventFormLoading || state is EventFormInitial) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (state is EventFormLoaded) {
//               return SingleChildScrollView(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       _buildBasicInfoSection(context),
//                       const SizedBox(height: 24),
//                       _buildPlaceSelection(context, state.places),
//                       const SizedBox(height: 24),
//                       _buildDateTimeSelection(context),
//                       const SizedBox(height: 24),
//                       _buildStatusSelection(context),
//                       const SizedBox(height: 32),
//                       _buildSaveButton(context, state.event),
//                     ],
//                   ),
//                 ),
//               );
//             }
//             if (state is EventFormSaving) {
//               return const Center(
//                   child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 10),
//                   Text("Guardando...")
//                 ],
//               ));
//             }
//             return const Center(
//                 child: Text('Error al cargar datos del formulario.'));
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0),
//       child: Text(title, style: Theme.of(context).textTheme.titleLarge),
//     );
//   }

//   Widget _buildBasicInfoSection(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         _buildSectionTitle('Información del Evento'),
//         TextFormField(
//           controller: _nameController,
//           decoration: const InputDecoration(
//               labelText: 'Nombre del Evento', border: OutlineInputBorder()),
//           validator: (value) =>
//               (value == null || value.isEmpty) ? 'Ingresa un nombre' : null,
//         ),
//         const SizedBox(height: 16),
//         TextFormField(
//           controller: _descriptionController,
//           decoration: const InputDecoration(
//               labelText: 'Descripción', border: OutlineInputBorder()),
//           maxLines: 3,
//         ),
//         // const SizedBox(height: 16),
//         // TextFormField(
//         //   controller: _venueDetailsController,
//         //   decoration: const InputDecoration(labelText: 'Detalles del Lugar (Ej: Salón A)', border: OutlineInputBorder()),
//         // ),
//       ],
//     );
//   }

//   Widget _buildPlaceSelection(BuildContext context, List<Place> places) {
//     // Ensure _selectedPlace is valid if editing
//     if (widget.eventId != null && _selectedPlace == null && places.isNotEmpty) {
//       final currentEvent =
//           (context.read<EventFormCubit>().state as EventFormLoaded).event;
//       if (currentEvent != null && currentEvent.placeId != null) {
//         try {
//           _selectedPlace =
//               places.firstWhere((p) => p.id == currentEvent.placeId);
//         } catch (e) {/* Place not in list */}
//       }
//     }
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         _buildSectionTitle('Lugar del Evento'),
//         if (places.isEmpty)
//           const Text('No hay lugares disponibles. Crea un lugar primero.')
//         else
//           DropdownButtonFormField<Place>(
//             value: _selectedPlace,
//             decoration: const InputDecoration(
//                 labelText: 'Selecciona un Lugar', border: OutlineInputBorder()),
//             items: places.map((Place place) {
//               return DropdownMenuItem<Place>(
//                 value: place,
//                 child: Text(place.name),
//               );
//             }).toList(),
//             onChanged: (Place? newValue) {
//               setState(() {
//                 _selectedPlace = newValue;
//               });
//             },
//             validator: (value) => value == null ? 'Lugar es requerido' : null,
//           ),
//       ],
//     );
//   }

//   Widget _buildDateTimeSelection(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         _buildSectionTitle('Fecha y Hora'),
//         Row(
//           children: <Widget>[
//             Expanded(
//               child: InkWell(
//                 onTap: () => _pickDate(context),
//                 child: InputDecorator(
//                   decoration: const InputDecoration(
//                       labelText: 'Fecha del Evento',
//                       border: OutlineInputBorder()),
//                   child: Text(_selectedDate != null
//                       ? DateFormat('dd MMM yyyy').format(_selectedDate!)
//                       : 'No seleccionada'),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: InkWell(
//                 onTap: () => _pickTime(context),
//                 child: InputDecorator(
//                   decoration: const InputDecoration(
//                       labelText: 'Hora del Evento',
//                       border: OutlineInputBorder()),
//                   child: Text(_selectedTime != null
//                       ? _selectedTime!.format(context)
//                       : 'No seleccionada'),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         if (_selectedDate == null || _selectedTime == null)
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Text('Fecha y hora son requeridas.',
//                 style: TextStyle(
//                     color: Theme.of(context).colorScheme.error, fontSize: 12)),
//           )
//       ],
//     );
//   }

//   Widget _buildStatusSelection(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         _buildSectionTitle('Estado del Evento'),
//         DropdownButtonFormField<EventType>(
//           value: _selectedStatus,
//           decoration: const InputDecoration(
//               labelText: 'Estado', border: OutlineInputBorder()),
//           items: EventType.values.map((EventType status) {
//             return DropdownMenuItem<EventType>(
//               value: status,
//               child: Text(status.name.toUpperCase()), // Assuming enum has .name
//             );
//           }).toList(),
//           onChanged: (EventType? newValue) {
//             if (newValue != null) {
//               setState(() {
//                 _selectedStatus = newValue;
//               });
//             }
//           },
//           validator: (value) => value == null ? 'Estado es requerido' : null,
//         ),
//       ],
//     );
//   }

//   Widget _buildSaveButton(BuildContext context, Event? currentEvent) {
//     return ElevatedButton.icon(
//       icon: const Icon(Icons.save),
//       label: const Text('Guardar Evento'),
//       style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
//       onPressed: () {
//         if (_formKey.currentState!.validate() &&
//             _selectedDate != null &&
//             _selectedTime != null &&
//             _selectedPlace != null) {
//           final DateTime eventDateTime = DateTime(
//             _selectedDate!.year,
//             _selectedDate!.month,
//             _selectedDate!.day,
//             _selectedTime!.hour,
//             _selectedTime!.minute,
//           );

//           // Construct Event object based on your core.Event model
//           final eventToSave = Event(
//             id: widget.eventId ?? currentEvent?.id ?? '',
//             title: _nameController.text,
//             description: _descriptionController.text,
//             date: eventDateTime,
//             placeId: _selectedPlace!.id,
//             location: _selectedPlace!.metadata['address'] ??
//                 '', // Store for convenience if needed
//             type: _selectedStatus,

//             // --- Defaults/current values for other required fields from Event model ---
//             // These must match your Event model definition in turbo_core
//             imageUrl: currentEvent?.imageUrl ??
//                 '', // Placeholder, image handling is complex
//             price: currentEvent?.price ?? 0.0,
//             tags: currentEvent?.tags ?? [],
//             organizerName: currentEvent?.organizerName ?? '',
//             // venueDetails: _venueDetailsController.text, // if you add this field
//           );

//           context.read<EventFormCubit>().saveEvent(eventToSave);
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//                 content: Text(
//                     'Por favor corrige los errores e ingresa toda la información requerida.'),
//                 backgroundColor: Colors.orangeAccent),
//           );
//         }
//       },
//     );
//   }
// }

