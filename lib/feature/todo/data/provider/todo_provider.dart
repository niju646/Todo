import 'package:flutter_riverpod/legacy.dart';
import 'package:to_do/core/api_end_points.dart';
import 'package:to_do/core/services/api_services.dart';
import 'package:to_do/feature/todo/data/service/todo_service.dart';
import 'package:to_do/feature/todo/model/todo_model.dart';

final todoProvider = StateNotifierProvider<TodoNotifier, TodoState>(
  (ref) => TodoNotifier(),
);

class TodoNotifier extends StateNotifier<TodoState> {
  TodoNotifier() : super(TodoState());

  /// CREATE
  Future<void> createTodo({
    required String title,
    required String description,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await ApiServices.post(ApiEndpoints.getTodo, {
        "title": title,
        "description": description,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final createdTodo = CreateTodo.fromJson(response.data);
        await fetchTodos();
        state = state.copyWith(isLoading: false, createdTodo: createdTodo);
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

  /// FETCH TODOS
  /// [loadMore] = true → fetches the next page and appends to the list
  /// [loadMore] = false → resets to page 1 (fresh fetch)
  Future<void> fetchTodos({bool loadMore = false}) async {
    if (state.isLoading) return;
    if (loadMore && !state.hasMore) return; // nothing more to load

    final nextPage = loadMore ? state.currentPage + 1 : 1;
    const pageSize = 10;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await TodoService().getTodo(
        page: nextPage,
        limit: pageSize,
      );

      if (response.statusCode == 200) {
        final json = response.data;

        final List<Data> fetchedTodos = (json["data"] as List)
            .map((e) => Data.fromJson(e))
            .toList();

        state = state.copyWith(
          isLoading: false,
          todos: loadMore ? [...state.todos, ...fetchedTodos] : fetchedTodos,
          totalItems: json["totalItems"],
          totalPages: json["totalPages"],
          currentPage: json["currentPage"],
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "Failed to fetch todos",
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  //delete todo
  Future<void> deleteTodo({required int id}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await TodoService().deleteTodo(id: id);
      if (response.statusCode == 200) {
        // Re-fetch same number of items currently shown (stay on page 1 but keep count)
        await fetchTodos();
        state = state.copyWith(isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "Failed to delete todo",
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  //get todo by id
  Future<void> getTodoById({required int id}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await TodoService().getTodoById(id: id);
      if (response.statusCode == 200) {
        final json = response.data;

        final rawData = json["data"];
        if (rawData == null || rawData is! Map<String, dynamic>) {
          // Silently stop loading — don't set an error that bleeds into other screens
          state = state.copyWith(isLoading: false);
          return;
        }

        final todo = Data.fromJson(rawData);
        state = state.copyWith(isLoading: false, selectedTodo: todo);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  //update todo
  Future<void> updateTodo({
    required int id,
    required String title,
    required String description,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await TodoService().updateTodo(
        id: id,
        title: title,
        description: description,
      );
      if (response.statusCode == 200) {
        await fetchTodos();
        state = state.copyWith(isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "Failed to update todo",
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  //update status
  Future<void> updateStatus({required int id, required bool status}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await TodoService().updateStatus(id: id, status: status);
      if (response.statusCode == 200) {
        await fetchTodos();
        state = state.copyWith(isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "Failed to update status",
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// REFRESH
  Future<void> refresh() async {
    await fetchTodos();
  }

  //total todo
  Future<void> totalTodo() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await TodoService().totalTodo();
      if (response.statusCode == 200) {
        final total = response.data["data"];
        state = state.copyWith(isLoading: false, totalItems: total);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "Failed to get total todo",
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  //total completed todo
  Future<void> totalCompletedTodos() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await TodoService().totalCompletedTodo();
      if (response.statusCode == 200) {
        final total = response.data["data"];
        state = state.copyWith(isLoading: false, totalCompletedTodos: total);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "Failed to get total todo",
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  //total pendingCount todo
  Future<void> pendingCount() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await TodoService().pendingCount();
      if (response.statusCode == 200) {
        final total = response.data["data"];
        state = state.copyWith(isLoading: false, pendingCount: total);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "Failed to get total todo",
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

class TodoState {
  final bool isLoading;
  final List<Data> todos;
  final CreateTodo? createdTodo;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pendingCount;
  final int totalCompletedTodos;
  final String? error;
  final Data? selectedTodo;

  TodoState({
    this.isLoading = false,
    this.todos = const [],
    this.createdTodo,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.error,
    this.selectedTodo,
    this.pendingCount = 0,
    this.totalCompletedTodos = 0,
  });

  TodoState copyWith({
    bool? isLoading,
    List<Data>? todos,
    CreateTodo? createdTodo,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    String? error,
    Data? selectedTodo,
    int? pendingCount,
    int? totalCompletedTodos,
  }) {
    return TodoState(
      isLoading: isLoading ?? this.isLoading,
      todos: todos ?? this.todos,
      createdTodo: createdTodo ?? this.createdTodo,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      error: error,
      selectedTodo: selectedTodo ?? this.selectedTodo,
      pendingCount: pendingCount ?? this.pendingCount,
      totalCompletedTodos: totalCompletedTodos ?? this.totalCompletedTodos,
    );
  }

  bool get hasMore => currentPage < totalPages;
}
