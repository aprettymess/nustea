import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:nustea/core/constants/constants.dart';
import 'package:nustea/core/config/cached_network_config.dart';

/// A utility class for handling cached network images with better error handling
class CachedImageUtils {
  /// Creates a CachedNetworkImageProvider with optimized settings for profile images
  static CachedNetworkImageProvider profileImageProvider(String url,
      {int size = 128}) {
    final provider = CachedNetworkImageProvider(
      url,
      maxHeight: size,
      maxWidth: size,
      cacheManager: kIsWeb ? null : CachedNetworkConfig.profileCacheManager,
      errorListener: (exception) {
        debugPrint('Error loading profile image: $exception');
      },
    );
    return provider;
  }

  /// Creates a CircleAvatar with a cached network image, handling errors gracefully
  static Widget profileAvatar({
    required String imageUrl,
    double radius = 32,
    Widget? errorWidget,
  }) {
    // If URL is empty or default, show placeholder
    if (imageUrl.isEmpty || imageUrl == Constants.avatarDefault) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: const AssetImage('assets/images/logo.png'),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundImage: CachedNetworkImageProvider(
        imageUrl,
        maxHeight: (radius * 4).toInt(),
        maxWidth: (radius * 4).toInt(),
        cacheManager: kIsWeb ? null : CachedNetworkConfig.profileCacheManager,
      ),
      onBackgroundImageError: (exception, stackTrace) {
        debugPrint('Error loading avatar: $exception');
      },
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  /// Creates a CachedNetworkImage with optimal settings and error handling
  static Widget cachedImage({
    required String imageUrl,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return CachedNetworkImage(
      cacheManager: kIsWeb ? null : CachedNetworkConfig.profileCacheManager,
      imageUrl: imageUrl,
      fit: fit,
      placeholder: (context, url) =>
          placeholder ?? const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) =>
          errorWidget ?? const Icon(Icons.error),
      memCacheHeight: 800,
      memCacheWidth: 800,
      maxHeightDiskCache: 800,
      maxWidthDiskCache: 800,
    );
  }
}
