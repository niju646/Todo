class CreateTodo {
  String? message;
  Data? data;

  CreateTodo({this.message, this.data});

  factory CreateTodo.fromJson(Map<String, dynamic> json) => CreateTodo(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data {
  bool? status;
  int? id;
  String? title;
  String? description;
  DateTime? updatedAt;
  DateTime? createdAt;

  Data({
    this.status,
    this.id,
    this.title,
    this.description,
    this.updatedAt,
    this.createdAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"],
    id: json["id"],
    title: json["title"],
    description: json["description"],
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "id": id,
    "title": title,
    "description": description,
    "updatedAt": updatedAt?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
  };
}

//todo state
class GetTodosState {
  final bool isLoading;
  final List<Data> todos;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final String? error;

  GetTodosState({
    this.isLoading = false,
    this.todos = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.error,
  });

  GetTodosState copyWith({
    bool? isLoading,
    List<Data>? todos,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    String? error,
  }) {
    return GetTodosState(
      isLoading: isLoading ?? this.isLoading,
      todos: todos ?? this.todos,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      error: error,
    );
  }

  bool get hasMore => currentPage < totalPages;
}
