import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/image_service.dart';

final imageServiceProvider = Provider<ImageService>((ref) {
  return ImageService();
});
