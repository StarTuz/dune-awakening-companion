import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageService {
  /// Process and save a character portrait
  /// Returns the saved file path, or null if failed
  Future<String?> savePortrait(String sourcePath, String characterId) async {
    try {
      // Read source image
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        print('Source file does not exist: $sourcePath');
        return null;
      }

      final bytes = await sourceFile.readAsBytes();
      final image = img.decodeImage(bytes);
      
      if (image == null) {
        print('Failed to decode image');
        return null;
      }

      // Resize to 512x512 (square)
      final resized = img.copyResize(
        image,
        width: 512,
        height: 512,
        interpolation: img.Interpolation.cubic,
      );

      // Convert to JPEG with quality 85
      final jpeg = img.encodeJpg(resized, quality: 85);

      // Get portraits directory
      final dir = await _getPortraitsDirectory();
      if (dir == null) return null;

      // Save file
      final filename = '$characterId.jpg';
      final filePath = path.join(dir.path, filename);
      final outputFile = File(filePath);
      await outputFile.writeAsBytes(jpeg);

      return filePath;
    } catch (e) {
      print('Error saving portrait: $e');
      return null;
    }
  }

  /// Delete a character portrait
  Future<bool> deletePortrait(String? portraitPath) async {
    if (portraitPath == null) return true;

    try {
      final file = File(portraitPath);
      if (await file.exists()) {
        await file.delete();
      }
      return true;
    } catch (e) {
      print('Error deleting portrait: $e');
      return false;
    }
  }

  /// Get portraits directory
  Future<Directory?> _getPortraitsDirectory() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final portraitsDir = Directory(path.join(appDir.path, 'portraits'));
      
      if (!await portraitsDir.exists()) {
        await portraitsDir.create(recursive: true);
      }
      
      return portraitsDir;
    } catch (e) {
      print('Error getting portraits directory: $e');
      return null;
    }
  }

  /// Validate image file
  Future<bool> isValidImage(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return false;

      // Check file size (max 2MB)
      final bytes = await file.length();
      if (bytes > 2 * 1024 * 1024) {
        print('Image too large: ${bytes / (1024 * 1024)}MB');
        return false;
      }

      // Try to decode
      final imageBytes = await file.readAsBytes();
      final image = img.decodeImage(imageBytes);
      
      return image != null;
    } catch (e) {
      print('Error validating image: $e');
      return false;
    }
  }
}
