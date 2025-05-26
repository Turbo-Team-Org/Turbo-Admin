import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_admin/core/widgets/admin_scaffold.dart';
import 'package:turbo_admin/core/widgets/data_tables/reviews_data_table.dart';
import 'package:turbo_admin/features/reviews/cubit/reviews_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:core/core.dart'; // For ReviewStatus enum

class PlaceholderReviewsListPage extends StatelessWidget {
  const PlaceholderReviewsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<ReviewsCubit>()..loadReviews(),
      child: AdminScaffold(
        title: 'Reseñas',
        body: BlocBuilder<ReviewsCubit, ReviewsState>(
          builder: (context, state) {
            if (state is ReviewsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ReviewsLoaded) {
              return ReviewsDataTable(
                reviews: state.reviews,
                onModerate: (reviewId) => context.goNamed('moderateReview',
                    pathParameters: {'reviewId': reviewId}),
                onDelete: (reviewId) {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: const Text("Confirmar Eliminación"),
                            content: const Text(
                                "¿Seguro que quieres eliminar esta reseña?"),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancelar")),
                              TextButton(
                                  onPressed: () {
                                    context
                                        .read<ReviewsCubit>()
                                        .deleteReview(reviewId);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Eliminar",
                                      style: TextStyle(color: Colors.red)))
                            ],
                          ));
                },
                onUpdateStatus: (reviewId, newStatus) {
                  // Optional: Show a quick confirmation or handle errors if the cubit emits them
                  //  context.read<ReviewsCubit>().updateReviewStatus(reviewId, newStatus);
                },
                onRefresh: () => context.read<ReviewsCubit>().loadReviews(),
              );
            }
            if (state is ReviewsError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Lista de Reseñas'));
          },
        ),
      ),
    );
  }
}
