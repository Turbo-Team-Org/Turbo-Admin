import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:core/core.dart'; // For Category model, CategoryRepository, CategoryService

// --- CategoryForm States ---
abstract class CategoryFormState {}

class CategoryFormInitial extends CategoryFormState {}

class CategoryFormLoading extends CategoryFormState {}

// State when category data is loaded for editing, or for a new form
class CategoryFormLoaded extends CategoryFormState {
  final Category? category; // null for create, Category for edit
  // Potentially parent categories if you have nested categories
  // final List<Category> parentCategories; 

  CategoryFormLoaded({
    this.category,
    // this.parentCategories = const [],
  });
}

class CategoryFormSaving extends CategoryFormState {}

class CategoryFormSuccess extends CategoryFormState {
  final bool isNewCategory;
  CategoryFormSuccess({required this.isNewCategory});
}

class CategoryFormError extends CategoryFormState {
  final String message;
  CategoryFormError(this.message);
}

// --- CategoryForm Cubit ---
class CategoryFormCubit extends Cubit<CategoryFormState> {
  final CategoryRepository _categoryRepository;
  final CategoryService _categoryService;

  CategoryFormCubit({
    CategoryRepository? categoryRepository,
    CategoryService? categoryService,
  }) : _categoryRepository = categoryRepository ?? GetIt.instance<CategoryRepository>(),
       _categoryService = categoryService ?? GetIt.instance<CategoryService>(),
       super(CategoryFormInitial());

  Future<void> loadForm({String? categoryId}) async {
    emit(CategoryFormLoading());
    try {
      Category? category;
      if (categoryId != null && categoryId.isNotEmpty) {
        category = await _categoryRepository.getCategoryById(categoryId);
      }
      // Load parent categories if needed for a dropdown
      // final parentCategories = await _categoryRepository.getCategories(type: CategoryType.parent);
      emit(CategoryFormLoaded(
        category: category,
        // parentCategories: parentCategories,
      ));
    } catch (e) {
      emit(CategoryFormError(e.toString()));
    }
  }

  Future<void> saveCategory(Category category) async {
    emit(CategoryFormSaving());
    try {
      bool isNewCategory = category.id.isEmpty;
      if (isNewCategory) {
        // Ensure category.id is handled by service or repository if it's auto-generated
        await _categoryService.addCategory(category);
      } else {
        await _categoryService.updateCategory(category);
      }
      emit(CategoryFormSuccess(isNewCategory: isNewCategory));
    } catch (e) {
      emit(CategoryFormError('Error al guardar categoría: ${e.toString()}'));
    }
  }
}
