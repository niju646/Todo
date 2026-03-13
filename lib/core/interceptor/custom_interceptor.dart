import 'package:dio/dio.dart';
import 'package:to_do/core/api_end_points.dart';
import 'package:to_do/core/storage/storage_service.dart';
import 'package:to_do/core/utils/urls/base_urls.dart';

class CustomInterceptor extends Interceptor {
  final Dio dio = Dio(); // Separate Dio for refresh call
  bool _isRefreshing = false;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = ThemeStorageService.instance.getAccessToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      try {
        final refreshToken = ThemeStorageService.instance.getRefreshToken();

        if (refreshToken == null) {
          return handler.next(err);
        }

        final response = await dio.post(
          '${BaseUrls.todos}${ApiEndpoints.refreshToken}',
          data: {"refreshToken": refreshToken},
        );

        final newAccessToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken'];

        await ThemeStorageService.instance.saveToken(newAccessToken);
        if (newRefreshToken != null) {
          await ThemeStorageService.instance.saveRefreshToken(newRefreshToken);
        }

        _isRefreshing = false;

        // 🔁 Retry original request
        final requestOptions = err.requestOptions;

        requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

        final clonedResponse = await dio.fetch(requestOptions);

        return handler.resolve(clonedResponse);
      } catch (e) {
        _isRefreshing = false;
        await ThemeStorageService.instance.clearTokens();
        return handler.next(err);
      }
    }

    return handler.next(err);
  }
}
