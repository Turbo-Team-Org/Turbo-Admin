import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:core/core.dart'; // For Category model

class CategoriesDataTable extends StatelessWidget {
  final List<Category> categories;
  final VoidCallback? onRefresh;
  final Function(String categoryId)? onEdit;
  final Function(String categoryId)? onDelete;
  // Add other callbacks if needed, e.g., onViewDetails

  const CategoriesDataTable({
    super.key,
    required this.categories,
    this.onRefresh,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No categories found.'),
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
      minWidth: 600, // Adjusted for category data
      sortAscending: true,
      columns: const [
        DataColumn2(label: Text('Icono'), size: ColumnSize.S, fixedWidth: 80),
        DataColumn2(label: Text('Nombre de Categoría'), size: ColumnSize.L),
        DataColumn2(label: Text('Descripción'), size: ColumnSize.M),
        // DataColumn2(label: Text('Parent ID'), size: ColumnSize.S), // If showing parent category
        DataColumn2(label: Text('Slug'), size: ColumnSize.M),
        DataColumn2(
            label: Text('Acciones'), size: ColumnSize.S, fixedWidth: 120),
      ],
      rows: categories.map((category) {
        // Assuming Category model has fields like:
        // String id;
        // String name;
        // String description;
        // String iconUrl; (or similar for icon representation)
        // String slug;
        // String? parentId;

        return DataRow2(
          cells: [
            DataCell(
              category.icon != null && category.icon.isNotEmpty
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(category.icon),
                      radius: 16,
                      child: category.icon.isEmpty
                          ? const Icon(Icons.category_outlined, size: 16)
                          : null,
                    )
                  : const CircleAvatar(
                      radius: 16,
                      child: Icon(Icons.category_outlined, size: 16),
                    ),
            ),
            DataCell(
              Text(category.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis),
            ),
            DataCell(Text(category.description ?? '',
                overflow: TextOverflow.ellipsis)),
            // DataCell(Text(category.parentId ?? 'N/A')),
            DataCell(
                Text(category.imageUrl ?? '', overflow: TextOverflow.ellipsis)),
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      tooltip: 'Edit Category',
                      onPressed: () => onEdit!(category.id),
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          size: 20, color: Colors.redAccent),
                      tooltip: 'Delete Category',
                      onPressed: () => onDelete!(category.id),
                    ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
