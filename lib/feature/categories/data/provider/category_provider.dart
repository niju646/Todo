import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:to_do/core/api_end_points.dart';
import 'package:to_do/core/services/api_services.dart';
import 'package:to_do/core/storage/storage_service.dart';
import 'package:to_do/feature/categories/data/service/category_service.dart';
import 'package:to_do/feature/categories/model/category_model.dart';

final categoryProvider = StateNotifierProvider<CategoryNotifier, CategoryState>(
  (ref) => CategoryNotifier(),
);

class CategoryNotifier extends StateNotifier<CategoryState> {
  CategoryNotifier() : super(CategoryState());

  //create category
  Future<void> createCategory({required String category}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await ApiServices.post(ApiEndpoints.createCategory, {
        "category": category,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final categorymodel = CategoryModel.fromJson(response.data);

        state = state.copyWith(isLoading: false, categorymodel: categorymodel);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.data["message"] ?? "Something went wrong",
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  //get all category
  Future<void> fetchCategories({bool loadMore = false}) async {
    if (state.isLoading) return;
    if (loadMore && !state.hasMore) return; // nothing more to load

    final nextPage = loadMore ? state.currentPage + 1 : 1;
    const pageSize = 10;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await CategoryService().getAllCategory(
        page: nextPage,
        limit: pageSize,
      );

      log(response.toString());

      if (response.statusCode == 200) {
        final json = response.data;

        final List<Data> fetchedCategories = (json["data"] as List)
            .map((e) => Data.fromJson(e))
            .toList();
        //load todo in offline
        final updatedCategories = loadMore
            ? [...state.category, ...fetchedCategories]
            : fetchedCategories;
        await ThemeStorageService.instance.saveCategories(
          jsonEncode(updatedCategories.map((e) => e.toJson()).toList()),
        );

        state = state.copyWith(
          isLoading: false,
          category: loadMore
              ? [...state.category, ...fetchedCategories]
              : fetchedCategories,
          totalItems: json["totalItems"],
          totalPages: json["totalPages"],
          currentPage: json["currentPage"],
        );
      } else {
        final cachedTodos = ThemeStorageService.instance.getCategories();
        if (cachedTodos != null) {
          final List<Data> categories = (jsonDecode(cachedTodos) as List)
              .map((e) => Data.fromJson(e))
              .toList();
          state = state.copyWith(
            isLoading: false,
            category: categories,
            totalItems: categories.length,
            totalPages: 1,
            currentPage: 1,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            error: "Failed to fetch todos",
          );
        }
      }
    } catch (e) {
      final cachedCategory = ThemeStorageService.instance.getCategories();
      if (cachedCategory != null) {
        final List<Data> categories = (jsonDecode(cachedCategory) as List)
            .map((e) => Data.fromJson(e))
            .toList();
        state = state.copyWith(
          isLoading: false,
          category: categories,
          totalItems: categories.length,
          totalPages: 1,
          currentPage: 1,
        );
      } else {
        state = state.copyWith(isLoading: false, error: e.toString());
      }
    }
  }

  //delete category
  Future<void> deleteCategory({required int id}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await CategoryService().deleteCategory(id: id);
      if (response.statusCode == 200) {
        await fetchCategories();
        state = state.copyWith(isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "Failed to delete category",
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

class CategoryState {
  final bool isLoading;
  final List<Data> category;
  final CategoryModel? categorymodel;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pendingCount;
  final int totalCompletedCategories;
  final String? error;
  final Data? selectedCategory;

  CategoryState({
    this.isLoading = false,
    this.category = const [],
    this.categorymodel,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.error,
    this.selectedCategory,
    this.pendingCount = 0,
    this.totalCompletedCategories = 0,
  });

  CategoryState copyWith({
    bool? isLoading,
    List<Data>? category,
    CategoryModel? categorymodel,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    String? error,
    Data? selectedCategory,
    int? pendingCount,
    int? totalCompletedCategories,
  }) {
    return CategoryState(
      isLoading: isLoading ?? this.isLoading,
      category: category ?? this.category,
      categorymodel: categorymodel ?? this.categorymodel,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      error: error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      pendingCount: pendingCount ?? this.pendingCount,
      totalCompletedCategories:
          totalCompletedCategories ?? this.totalCompletedCategories,
    );
  }

  bool get hasMore => currentPage < totalPages;
}
