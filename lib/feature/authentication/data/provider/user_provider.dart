import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:to_do/core/storage/storage_service.dart';
import 'package:to_do/feature/authentication/data/services/user_service.dart';
import 'package:to_do/feature/authentication/model/user_model.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserState>(
  (ref) => UserNotifier(UserService()),
);

class UserState {
  final bool isLoading;
  final String? error;
  final UserModel? user;

  UserState({this.isLoading = false, this.error, this.user});

  UserState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
    UserModel? user,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      user: user ?? this.user,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  final UserService _userService;

  UserNotifier(this._userService) : super(UserState());

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final response = await _userService.login(
        email: email,
        password: password,
      );
      log(response.data.toString());
      log(response.statusCode.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        // final userJson = response.data['user'];
        final userJson = Map<String, dynamic>.from(response.data['user']);

        userJson.remove("password");

        final user = UserModel.fromJson(userJson);
        final accessToken = response.data["accessToken"];
        final refreshToken = response.data["refreshToken"];

        await ThemeStorageService.instance.saveToken(accessToken);
        await ThemeStorageService.instance.saveRefreshToken(refreshToken);
        await ThemeStorageService.instance.saveUserData(
          jsonEncode(user.toJson()),
        );

        log("AccessToken: ${ThemeStorageService.instance.getAccessToken()}");
        log("RefreshToken: ${ThemeStorageService.instance.getRefreshToken()}");
        state = state.copyWith(isLoading: false, user: user);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.data["message"] ?? "Login failed",
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  //signup
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final response = await _userService.signup(
        name: name,
        email: email,
        password: password,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("signup successfull");
        // state = state.copyWith(isLoading: false);
        state = UserState();
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.data["message"] ?? "Signup failed",
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void loadUserFromStorage() {
    final userString = ThemeStorageService.instance.getUserData();

    if (userString != null) {
      final userMap = jsonDecode(userString);
      final user = UserModel.fromJson(userMap);

      state = state.copyWith(user: user);
    }
  }

  //logout
  Future<void> logout() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final response = await _userService.logout(
        token: ThemeStorageService.instance.getAccessToken()!,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        await ThemeStorageService.instance.clearTokens();

        // await ThemeStorageService.instance.clearUserData();
        state = UserState();
        log("logout successfull");
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.data["message"] ?? "Logout failed",
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
