import 'package:dio/dio.dart';
import 'package:to_do/core/api_end_points.dart';
import 'package:to_do/core/services/api_services.dart';

class CategoryService {
  //create cateory
  Future<Response> createCategory({required String category}) async {
    final response = await ApiServices.post(ApiEndpoints.createCategory, {
      "category": category,
    });
    return response;
  }

  //getAllCategory
  Future<Response> getAllCategory({
    required int page,
    required int limit,
  }) async {
    final response = await ApiServices.get(
      "${ApiEndpoints.getAllCategory}?page=$page&limit=$limit",
    );
    return response;
  }

  //delete Category
  Future<Response> deleteCategory({required int id}) async {
    final response = await ApiServices.delete(
      "${ApiEndpoints.deleteCategory}/$id",
    );
    return response;
  }
}
