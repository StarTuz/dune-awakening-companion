import 'dart:io';
import 'package:flutter/foundation.dart';
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
        debugPrint('Source file does not exist: $sourcePath');
        return null;
      }

      final bytes = await sourceFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        debugPrint('Failed to decode image');
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
      debugPrint('Error saving portrait: $e');
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
      debugPrint('Error deleting portrait: $e');
      return false;
    }
  }

  /// Process and save a journal entry screenshot into an app-managed directory
  /// so it can be bundled into ZIP backups. Aspect ratio is preserved and the
  /// image is downscaled (max 1280px wide) and re-encoded as JPEG to keep
  /// backups small. Returns the saved file path, or null if it failed.
  Future<String?> saveJournalImage(String sourcePath, String entryId) async {
    try {
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        debugPrint('Source file does not exist: $sourcePath');
        return null;
      }

      final bytes = await sourceFile.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) {
        debugPrint('Failed to decode image');
        return null;
      }

      // Downscale only if wider than the cap; keep aspect ratio.
      final processed = image.width > 1280
          ? img.copyResize(
              image,
              width: 1280,
              interpolation: img.Interpolation.cubic,
            )
          : image;

      final jpeg = img.encodeJpg(processed, quality: 85);

      final dir = await _getJournalImagesDirectory();
      if (dir == null) return null;

      final filePath = path.join(dir.path, '$entryId.jpg');
      await File(filePath).writeAsBytes(jpeg);

      return filePath;
    } catch (e) {
      debugPrint('Error saving journal image: $e');
      return null;
    }
  }

  /// Delete a journal entry screenshot.
  Future<bool> deleteJournalImage(String? imagePath) async {
    if (imagePath == null) return true;

    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
      return true;
    } catch (e) {
      debugPrint('Error deleting journal image: $e');
      return false;
    }
  }

  /// Get the app-managed journal images directory.
  Future<Directory?> _getJournalImagesDirectory() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final journalDir = Directory(path.join(appDir.path, 'journal_images'));

      if (!await journalDir.exists()) {
        await journalDir.create(recursive: true);
      }

      return journalDir;
    } catch (e) {
      debugPrint('Error getting journal images directory: $e');
      return null;
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
      debugPrint('Error getting portraits directory: $e');
      return null;
    }
  }

  /// Filename of the user's custom app emblem inside the emblem directory.
  static const emblemFilename = 'custom_emblem.png';

  /// Process and save a custom app emblem. Aspect ratio is preserved, the
  /// long edge is capped at 512px, and the result is re-encoded as PNG so
  /// transparency survives. Returns the saved file path, or null if failed.
  Future<String?> saveEmblem(String sourcePath) async {
    try {
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        debugPrint('Source file does not exist: $sourcePath');
        return null;
      }

      final bytes = await sourceFile.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) {
        debugPrint('Failed to decode image');
        return null;
      }

      final processed = image.width < 512 && image.height < 512
          ? image
          : img.copyResize(
              image,
              width: image.width >= image.height ? 512 : null,
              height: image.height > image.width ? 512 : null,
              interpolation: img.Interpolation.cubic,
            );

      final png = img.encodePng(processed);

      final dir = await _getEmblemDirectory();
      if (dir == null) return null;

      final filePath = path.join(dir.path, emblemFilename);
      await File(filePath).writeAsBytes(png);

      return filePath;
    } catch (e) {
      debugPrint('Error saving emblem: $e');
      return null;
    }
  }

  /// Delete the custom emblem so the bundled default shows again.
  Future<bool> deleteEmblem() async {
    try {
      final emblemPath = await getEmblemPath();
      if (emblemPath != null) {
        await File(emblemPath).delete();
      }
      return true;
    } catch (e) {
      debugPrint('Error deleting emblem: $e');
      return false;
    }
  }

  /// Path of the saved custom emblem, or null when none exists.
  Future<String?> getEmblemPath() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final filePath = path.join(appDir.path, 'emblem', emblemFilename);
      return await File(filePath).exists() ? filePath : null;
    } catch (e) {
      debugPrint('Error checking emblem path: $e');
      return null;
    }
  }

  /// Get the app-managed emblem directory.
  Future<Directory?> _getEmblemDirectory() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final emblemDir = Directory(path.join(appDir.path, 'emblem'));

      if (!await emblemDir.exists()) {
        await emblemDir.create(recursive: true);
      }

      return emblemDir;
    } catch (e) {
      debugPrint('Error getting emblem directory: $e');
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
        debugPrint('Image too large: ${bytes / (1024 * 1024)}MB');
        return false;
      }

      // Try to decode
      final imageBytes = await file.readAsBytes();
      final image = img.decodeImage(imageBytes);

      return image != null;
    } catch (e) {
      debugPrint('Error validating image: $e');
      return false;
    }
  }
}
