import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:core/core.dart'; // For Category model, CategoryRepository, CategoryService

// --- Categories States ---
abstract class CategoriesState {}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<Category> categories;
  // Add pagination fields if categories can be numerous
  // final int totalCount;
  // final int currentPage;

  CategoriesLoaded({
    required this.categories,
    // required this.totalCount,
    // required this.currentPage,
  });
}

class CategoriesError extends CategoriesState {
  final String message;
  CategoriesError(this.message);
}

// --- Categories Cubit ---
class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoryRepository _categoryRepository;
  final CategoryService _categoryService;

  CategoriesCubit({
    CategoryRepository? categoryRepository,
    CategoryService? categoryService,
  }) : _categoryRepository = categoryRepository ?? GetIt.instance<CategoryRepository>(),
       _categoryService = categoryService ?? GetIt.instance<CategoryService>(),
       super(CategoriesInitial());

  Future<void> loadCategories({int page = 1 /* if paginated */}) async {
    emit(CategoriesLoading());
    try {
      // Assuming CategoryRepository.getCategories() returns all categories
      // If paginated, it should accept page/limit parameters
      final categories = await _categoryRepository.getCategories();
      emit(CategoriesLoaded(
        categories: categories,
        // totalCount: categories.length, // Or from paginated result
        // currentPage: page,
      ));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    // Consider the current state to provide better UX, e.g., show a small loading indicator
    // or temporarily disable the delete button for the specific item.
    try {
      await _categoryService.deleteCategory(categoryId);
      // Refresh the list after deletion
      await loadCategories(); 
    } catch (e) {
      // If the list was previously loaded, you might want to show the error
      // without losing the currently displayed data.
      if (state is CategoriesLoaded) {
        final currentCategories = (state as CategoriesLoaded).categories;
        emit(CategoriesError('Error al eliminar categoría: ${e.toString()}'));
        emit(CategoriesLoaded(categories: currentCategories)); // Re-emit current data
      } else {
        emit(CategoriesError('Error al eliminar categoría: ${e.toString()}'));
      }
    }
  }
}
