import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:core/core.dart'; // For Event model
import 'package:intl/intl.dart'; // For date formatting

class EventsDataTable extends StatelessWidget {
  final List<Event> events;
  final VoidCallback? onRefresh;
  final Function(String eventId)? onEdit;
  final Function(String eventId)? onDelete;
  final Function(String eventId)? onView; // e.g., to navigate to an event details page

  const EventsDataTable({
    super.key,
    required this.events,
    this.onRefresh,
    this.onEdit,
    this.onDelete,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No events found.'),
            if (onRefresh != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  onPressed: onRefresh,
                ),
              ),
          ],
        ),
      );
    }

    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 900, // Adjusted for event data
      sortAscending: true,
      columns: const [
        DataColumn2(label: Text('Nombre del Evento'), size: ColumnSize.L),
        DataColumn2(label: Text('Lugar'), size: ColumnSize.M),
        DataColumn2(label: Text('Fecha'), size: ColumnSize.M),
        DataColumn2(label: Text('Hora'), size: ColumnSize.S),
        DataColumn2(label: Text('Estado'), size: ColumnSize.S), // e.g., upcoming, past, cancelled
        DataColumn2(label: Text('Acciones'), size: ColumnSize.M, fixedWidth: 150),
      ],
      rows: events.map((event) {
        // Assuming Event model has fields like:
        // String id;
        // String name;
        // String placeName; (or a Place object to get the name)
        // DateTime date;
        // EventStatus status; (enum: upcoming, past, cancelled)
        // String mainImage; (optional)

        String formattedDate = DateFormat('dd MMM yyyy').format(event.date);
        String formattedTime = DateFormat('hh:mm a').format(event.date); // Or event.time if separate

        return DataRow2(
          // onSelectChanged: onView != null ? (selected) { if (selected ?? false) onView!(event.id); } : null,
          cells: [
            DataCell(
              Row(
                children: [
                  if (event.mainImage != null && event.mainImage!.isNotEmpty)
                    CircleAvatar(
                      backgroundImage: NetworkImage(event.mainImage!),
                      radius: 16,
                      child: event.mainImage!.isEmpty ? const Icon(Icons.event, size: 16) : null,
                    )
                  else
                    const CircleAvatar(
                      radius: 16,
                      child: Icon(Icons.event, size: 16),
                    ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(event.name, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
            DataCell(Text(event.placeName ?? 'N/A')), // Assuming event.placeName or event.place.name
            DataCell(Text(formattedDate)),
            DataCell(Text(formattedTime)),
            DataCell(
              Chip(
                label: Text(event.status.name.toUpperCase()), // Assuming EventStatus is an enum with a 'name' property
                backgroundColor: _getStatusColor(event.status).withOpacity(0.1),
                labelStyle: TextStyle(color: _getStatusColor(event.status)),
              ),
            ),
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onView != null)
                    IconButton(
                      icon: const Icon(Icons.visibility_outlined, size: 20),
                      tooltip: 'View Event',
                      onPressed: () => onView!(event.id),
                    ),
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      tooltip: 'Edit Event',
                      onPressed: () => onEdit!(event.id),
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                      tooltip: 'Delete Event',
                      onPressed: () => onDelete!(event.id),
                    ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Color _getStatusColor(EventStatus status) {
    // Assuming EventStatus enum exists in core/core.dart
    switch (status) {
      case EventStatus.upcoming:
        return Colors.blue.shade700;
      case EventStatus.past:
        return Colors.grey.shade700;
      case EventStatus.cancelled:
        return Colors.red.shade700;
      default:
        return Colors.black;
    }
  }
}
