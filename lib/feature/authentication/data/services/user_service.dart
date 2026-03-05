import 'package:dio/dio.dart';
import 'package:to_do/core/api_end_points.dart';
import 'package:to_do/core/services/api_services.dart';

class UserService {
  //login
  Future<Response> login({
    required String email,
    required String password,
  }) async {
    final response = await ApiServices.post(ApiEndpoints.login, {
      "email": email,
      "password": password,
    });
    return response;
  }

  //signup
  Future<Response> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await ApiServices.post(ApiEndpoints.signup, {
      "name": name,
      "email": email,
      "password": password,
    });
    return response;
  }

  //logout
  Future<Response> logout({required String token}) async {
    final response = await ApiServices.post(ApiEndpoints.logout, {
      "token": token,
    });
    return response;
  }
}
