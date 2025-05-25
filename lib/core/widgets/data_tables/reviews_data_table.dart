import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:core/core.dart'; // For Review model, ReviewStatus
import 'package:intl/intl.dart'; // For date formatting

class ReviewsDataTable extends StatelessWidget {
  final List<Review> reviews;
  final VoidCallback? onRefresh;
  final Function(String reviewId)? onModerate; // To open moderation page/dialog
  final Function(String reviewId)? onDelete;
  final Function(String reviewId, ReviewStatus newStatus)? onUpdateStatus;


  const ReviewsDataTable({
    super.key,
    required this.reviews,
    this.onRefresh,
    this.onModerate,
    this.onDelete,
    this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No reviews found.'),
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
      minWidth: 1000, // Adjusted for review data
      sortAscending: true, 
      columns: const [
        DataColumn2(label: Text('Usuario'), size: ColumnSize.M),
        DataColumn2(label: Text('Lugar/Evento'), size: ColumnSize.L),
        DataColumn2(label: Text('Rating'), numeric: true, size: ColumnSize.S),
        DataColumn2(label: Text('Comentario'), size: ColumnSize.L),
        DataColumn2(label: Text('Fecha'), size: ColumnSize.M),
        DataColumn2(label: Text('Estado'), size: ColumnSize.M),
        DataColumn2(label: Text('Acciones'), size: ColumnSize.M, fixedWidth: 180),
      ],
      rows: reviews.map((review) {
        // Assuming Review model has fields like:
        // String id;
        // String userId;
        // String userName; (or User object)
        // String placeId; (or eventId)
        // String placeName; (or eventName, or a targetName field)
        // double rating;
        // String comment;
        // DateTime createdAt;
        // ReviewStatus status;

        String formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(review.createdAt);
        
        return DataRow2(
          cells: [
            DataCell(
                Text(review.userName ?? review.userId, overflow: TextOverflow.ellipsis)), // Display userName or userId
            DataCell(
                Text(review.targetName ?? 'N/A', overflow: TextOverflow.ellipsis)), // Assuming targetName holds Place/Event name
            DataCell(Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                SizedBox(width: 4),
                Text(review.rating.toStringAsFixed(1)),
              ],
            )),
            DataCell(Text(review.comment ?? '', overflow: TextOverflow.ellipsis, maxLines: 2)),
            DataCell(Text(formattedDate)),
            DataCell(
              Chip(
                label: Text(review.status.name.toUpperCase(), style: TextStyle(fontSize: 10)),
                backgroundColor: _getStatusColor(review.status, context).withOpacity(0.1),
                labelStyle: TextStyle(color: _getStatusColor(review.status, context)),
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              ),
            ),
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onModerate != null)
                    IconButton(
                      icon: const Icon(Icons.rate_review_outlined, size: 20),
                      tooltip: 'Moderar Reseña',
                      onPressed: () => onModerate!(review.id),
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                      tooltip: 'Eliminar Reseña',
                      onPressed: () => onDelete!(review.id),
                    ),
                  // Quick status change buttons
                  if (onUpdateStatus != null && review.status == ReviewStatus.pending)
                    IconButton(
                      icon: Icon(Icons.check_circle_outline, color: Colors.green.shade600, size: 20),
                      tooltip: 'Aprobar',
                      onPressed: () => onUpdateStatus!(review.id, ReviewStatus.approved),
                    ),
                  if (onUpdateStatus != null && review.status == ReviewStatus.pending)
                     IconButton(
                      icon: Icon(Icons.highlight_off_outlined, color: Colors.orange.shade700, size: 20),
                      tooltip: 'Rechazar',
                      onPressed: () => onUpdateStatus!(review.id, ReviewStatus.rejected),
                    ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Color _getStatusColor(ReviewStatus status, BuildContext context) {
    // Assuming ReviewStatus enum (pending, approved, rejected) exists in core/core.dart
    switch (status) {
      case ReviewStatus.pending:
        return Colors.orange.shade700;
      case ReviewStatus.approved:
        return Colors.green.shade700;
      case ReviewStatus.rejected:
        return Colors.red.shade700;
      default:
        return Theme.of(context).textTheme.bodySmall?.color ?? Colors.black;
    }
  }
}
