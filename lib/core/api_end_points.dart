/// API Endpoints (relative paths only)
class ApiEndpoints {
  static const String getTodo = "/create";
  static const String getAllTodo = "/getAll";
  static const String getAllTodosForUser = "/getAllTodosForUser";
  static const String deleteTodo = "/delete";
  static const String updateTodo = "/update";
  static const String getTodoById = "/getById";
  static const String updateStatus = "/updateStatus";
  static const String login = "/public/login";
  static const String signup = "/public/signup";
  static const String logout = "/public/logout";
  static const String totalTodo = "/totalTodos";
  static const String totalCompletedTodos = "/totalCompletedTodos";
  static const String pendingCount = "/pendingCount";
  static const String refreshToken = "/public/refreshToken";

  //categories
  static const String createCategory = "/createCategory";
  static const String getAllCategory = "/getAllCategories";
  static const String deleteCategory = "/deleteCategory";
}
