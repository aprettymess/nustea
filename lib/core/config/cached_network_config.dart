import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Configuration for cached network images
class CachedNetworkConfig {
  static const String key = 'nustea_optimized_cache';

  /// Initialize cache configuration for the app
  static void initialize() {
    // Configure Flutter's built-in image cache
    PaintingBinding.instance.imageCache.maximumSize =
        200; // Increase image cache size

    // Configure cached_network_image package
    CachedNetworkImage.logLevel = CacheManagerLogLevel.none; // Reduce logs
  }

  /// Custom cache manager with optimized settings for profile images
  static CacheManager? get profileCacheManager {
    if (kIsWeb) {
      // Web platform doesn't support the path_provider plugin used by CacheManager
      return null;
    }

    return CacheManager(
      Config(
        key,
        stalePeriod: const Duration(days: 7), // Keep images in cache for 7 days
        maxNrOfCacheObjects: 200, // Store up to 200 images
        repo: JsonCacheInfoRepository(databaseName: key),
        fileService: HttpFileService(),
      ),
    );
  }
}
