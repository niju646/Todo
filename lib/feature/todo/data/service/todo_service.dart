import 'package:dio/dio.dart';
import 'package:to_do/core/api_end_points.dart';
import 'package:to_do/core/services/api_services.dart';

class TodoService {
  //create todos
  Future<Response> createTodo({
    required String title,
    required String description,
  }) async {
    final response = await ApiServices.post(ApiEndpoints.getTodo, {
      "title": title,
      "description": description,
    });
    return response;
  }

  //get all todos
  Future<Response> getTodo({required int page, required int limit}) async {
    final response = await ApiServices.get(
      "${ApiEndpoints.getAllTodo}?page=$page&limit=$limit",
    );
    return response;
  }

  //get todo by id
  Future<Response> getTodoById({required int id}) async {
    final response = await ApiServices.get("${ApiEndpoints.getTodoById}/$id");
    return response;
  }

  //delete todo
  Future<Response> deleteTodo({required int id}) async {
    final response = await ApiServices.delete("${ApiEndpoints.deleteTodo}/$id");
    return response;
  }

  //update todo
  Future<Response> updateTodo({
    required int id,
    required String title,
    required String description,
  }) async {
    final response = await ApiServices.put("${ApiEndpoints.updateTodo}/$id", {
      "title": title,
      "description": description,
    });
    return response;
  }

  //update status
  Future<Response> updateStatus({required int id, required bool status}) async {
    final response = await ApiServices.put("${ApiEndpoints.updateStatus}/$id", {
      "status": status,
    });
    return response;
  }

  //total todo
  Future<Response> totalTodo() async {
    final response = await ApiServices.get(ApiEndpoints.totalTodo);
    return response;
  }

  //total completed todo
  Future<Response> totalCompletedTodo() async {
    final response = await ApiServices.get(ApiEndpoints.totalCompletedTodos);
    return response;
  }

  Future<Response> pendingCount() async {
    final response = await ApiServices.get(ApiEndpoints.pendingCount);
    return response;
  }
}
