import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do/core/storage/storage_service.dart';

final authProvider = FutureProvider<bool>((ref) async {
  final token = ThemeStorageService.instance.getAccessToken();
  return token != null && token.isNotEmpty;
});
