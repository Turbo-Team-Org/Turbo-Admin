import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:core/core.dart'; // For the Place model

// Ensure this import path is correct based on your project structure
// and how Place model is exported from turbo_core.
// For example, if Place is in 'package:core/models/place.dart', use that.

class PlacesDataTable extends StatelessWidget {
  final List<Place> places; // Place comes from turbo_core
  final VoidCallback? onRefresh;
  final Function(String placeId)? onEdit; // Changed to pass placeId
  final Function(String placeId)? onDelete; // Changed to pass placeId

  const PlacesDataTable({
    super.key,
    required this.places,
    this.onRefresh,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // It's good practice to handle empty or null places list
    if (places.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No places found.'),
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
      minWidth:
          800, // Minimum width for the table to ensure all columns are visible
      sortAscending: true, // Default sort order
      // sortColumnIndex: _sortColumnIndex, // Add stateful logic for sorting if needed
      columns: const [
        DataColumn2(label: Text('Nombre'), size: ColumnSize.L),
        DataColumn2(label: Text('Categoría'), size: ColumnSize.M),
        DataColumn2(
            label: Text('Rating'),
            numeric: true,
            size: ColumnSize.S), // numeric for alignment
        DataColumn2(label: Text('Estado'), size: ColumnSize.S),
        DataColumn2(
            label: Text('Acciones'),
            size: ColumnSize.M,
            fixedWidth: 120), // Fixed width for actions
      ],
      rows: places.map((place) {
        // Assuming Place model has these fields:
        // String id;
        // String mainImage; (URL)
        // String name;
        // String address;
        // String categoryName; (or a Category object from which name can be derived)
        // double rating;
        // bool isOpen; (or some status enum)

        return DataRow2(
          cells: [
            DataCell(
              Row(
                children: [
                  CircleAvatar(
                    // Handle potential errors with NetworkImage, e.g., show placeholder
                    backgroundImage: place.mainImage.isNotEmpty
                        ? NetworkImage(place.mainImage)
                        : null, // Or a placeholder AssetImage
                    radius: 16,
                    child: place.mainImage.isEmpty
                        ? const Icon(Icons.business,
                            size: 16) // Placeholder icon
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    // Use Expanded to prevent overflow if names are long
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(place.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis),
                        Text(place.address,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            DataCell(
              Chip(
                label: Text(place
                    .categoryName), // Assuming categoryName is directly available
                backgroundColor: Colors.blue.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              ),
            ),
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(place.rating.toStringAsFixed(1)),
                ],
              ),
            ),
            DataCell(
              Chip(
                label: Text(place.isOpen ? 'Abierto' : 'Cerrado'),
                backgroundColor: place.isOpen
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                labelStyle: TextStyle(
                    color: place.isOpen
                        ? Colors.green.shade700
                        : Colors.red.shade700),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              ),
            ),
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    tooltip: 'Edit Place',
                    onPressed: onEdit != null ? () => onEdit!(place.id) : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        size: 20, color: Colors.redAccent),
                    tooltip: 'Delete Place',
                    onPressed:
                        onDelete != null ? () => onDelete!(place.id) : null,
                  ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
      //TODO add pagination
      // Optional: Add footer with pagination controls if using Paginator controller from data_table_2
      // bottomPaginator: PaginatorController(),
      // Paginator can be configured with PaginatorController to handle page changes.
      // This would typically interact with the PlacesCubit to load paged data.
    );
  }
}
