import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:turbo_admin/core/widgets/admin_scaffold.dart';
import 'package:turbo_admin/features/reviews/cubit/review_moderation_cubit.dart';
import 'package:core/core.dart'; // For Review model, ReviewStatus

class ReviewModerationPage extends StatefulWidget {
  final String reviewId;

  const ReviewModerationPage({super.key, required this.reviewId});

  @override
  State<ReviewModerationPage> createState() => _ReviewModerationPageState();
}

class _ReviewModerationPageState extends State<ReviewModerationPage> {
  String? _rejectionReason; // For optional rejection reason input

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<ReviewModerationCubit>()
        ..loadReviewForModeration(widget.reviewId),
      child: AdminScaffold(
        title: 'Moderar Reseña',
        body: BlocConsumer<ReviewModerationCubit, ReviewModerationState>(
          listener: (context, state) {
            if (state is ReviewModerationActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green),
              );
              // Optionally pop or navigate back to the reviews list
              if (context.canPop()) context.pop();
              // Potentially trigger a refresh of the ReviewsCubit list if still visible
            } else if (state is ReviewModerationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Error: ${state.message}'),
                    backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            if (state is ReviewModerationLoading ||
                state is ReviewModerationInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ReviewModerationLoaded) {
              final review = state.review;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildReviewDetails(context, review),
                    const SizedBox(height: 24),
                    if (review.status ==
                        ReviewStatus.pending) // Show actions only if pending
                      _buildModerationActions(context, review),
                    if (review.status != ReviewStatus.pending)
                      Text(
                          "Esta reseña ya ha sido moderada: ${review.status.name.toUpperCase()}",
                          style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: Icon(Icons.arrow_back),
                      label: Text("Volver a la lista"),
                      onPressed: () =>
                          context.pop(), // Or context.go('/reviews')
                    )
                  ],
                ),
              );
            }
            if (state is ReviewModerationActionSuccess) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 50),
                  SizedBox(height: 10),
                  Text(state.message),
                  SizedBox(height: 10),
                  ElevatedButton(
                      child: Text("Ok"),
                      onPressed: () {
                        if (context.canPop()) context.pop();
                      })
                ],
              ));
            }

            return const Center(child: Text('Error al cargar la reseña.'));
          },
        ),
      ),
    );
  }

  Widget _buildReviewDetails(BuildContext context, Review review) {
    final theme = Theme.of(context).textTheme;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Detalles de la Reseña', style: theme.titleLarge),
            const Divider(),
            _buildDetailRow('ID Reseña:', review.id, theme),
            _buildDetailRow(
                'Usuario:', '${review.userName} (ID: ${review.userId})', theme),
            _buildDetailRow('Lugar/Evento:', review.comment ?? 'N/A',
                theme), // Assuming targetName exists
            _buildDetailRow(
                'Rating:',
                List.generate(
                    5,
                    (index) => Icon(
                          index < review.rating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        )).toList(),
                theme),
            _buildDetailRow(
                'Comentario:', review.comment ?? 'Sin comentario.', theme,
                isMultiline: true),
            _buildDetailRow('Fecha:',
                DateFormat('dd MMM yyyy, hh:mm a').format(review.date), theme),
            _buildDetailRow(
                'Estado Actual:', review.status.name.toUpperCase(), theme,
                chipColor: _getStatusColor(review.status, context)),
            if (review.status == ReviewStatus.rejected &&
                review.comment != null &&
                review.comment!.isNotEmpty)
              _buildDetailRow('Motivo Rechazo:', review.comment!, theme,
                  isMultiline: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value, TextTheme theme,
      {bool isMultiline = false, Color? chipColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
              width: 120,
              child: Text(label,
                  style:
                      theme.titleSmall?.copyWith(fontWeight: FontWeight.bold))),
          Expanded(
            child: value is List<Widget>
                ? Row(children: value)
                : (chipColor != null
                    ? Chip(
                        label: Text(value.toString()),
                        backgroundColor: chipColor.withOpacity(0.2),
                        labelStyle: TextStyle(color: chipColor))
                    : Text(value.toString(), style: theme.bodyMedium)),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ReviewStatus status, BuildContext context) {
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

  Widget _buildModerationActions(BuildContext context, Review review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Acciones de Moderación',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Aprobar'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                //    context.read<ReviewModerationCubit>().(review.id);
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.highlight_off_outlined),
              label: const Text('Rechazar'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () => _showRejectionDialog(context, review.id),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Center(
          child: TextButton.icon(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            label: const Text('Eliminar Reseña Permanentemente',
                style: TextStyle(color: Colors.redAccent)),
            onPressed: () => _confirmDeleteDialog(context, review.id),
          ),
        ),
      ],
    );
  }

  Future<void> _showRejectionDialog(
      BuildContext contextCubit, String reviewId) async {
    // contextCubit is the BuildContext that has access to ReviewModerationCubit
    return showDialog<void>(
      context: contextCubit,
      builder: (BuildContext dialogContext) {
        _rejectionReason = null; // Reset before showing dialog
        final reasonController = TextEditingController();
        return AlertDialog(
          title: const Text('Rechazar Reseña'),
          content: TextField(
            controller: reasonController,
            decoration: const InputDecoration(
                hintText: "Motivo del rechazo (opcional)"),
            onChanged: (value) =>
                _rejectionReason = value, // Storing locally for now
            maxLines: 2,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Confirmar Rechazo'),
              onPressed: () {
                //  contextCubit.read<ReviewModerationCubit>().rejectReview(reviewId, reason: _rejectionReason);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDeleteDialog(
      BuildContext contextCubit, String reviewId) async {
    showDialog<void>(
      context: contextCubit,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text(
              '¿Estás seguro de que quieres eliminar esta reseña permanentemente? Esta acción no se puede deshacer.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
              onPressed: () {
                contextCubit
                    .read<ReviewModerationCubit>()
                    .deleteReview(reviewId);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
