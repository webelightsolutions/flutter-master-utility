// Dart imports:
import 'dart:io' show Platform;

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AppNetworkImage extends StatelessWidget {
  final String url;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final Widget Function(BuildContext, String, DownloadProgress)?
      progressIndicatorBuilder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder;
  final Widget Function(BuildContext, String)? placeholder;
  final BaseCacheManager? cacheManager;
  final Color? color;
  final BlendMode? colorBlendMode;
  final Map<String, String>? httpHeaders;
  final Alignment alignment;
  final String? cacheKey;
  final void Function(Object)? errorListener;
  final int? maxHeightDiskCache;
  final int? maxWidthDiskCache;
  final ImageRepeat repeat;
  final bool useOldImageOnUrlChange;
  final Curve fadeOutCurve;
  final Duration fadeOutDuration;
  final Curve fadeInCurve;
  final Duration fadeInDuration;
  final FilterQuality filterQuality;
  final int? memCacheWidth;
  final bool matchTextDirection;
  final Duration? placeholderFadeInDuration;
  final int? memCacheHeight;

  const AppNetworkImage({
    Key? key,
    this.fit,
    this.height,
    this.width,
    this.errorWidget,
    this.progressIndicatorBuilder,
    this.imageBuilder,
    this.placeholder,
    this.cacheManager,
    required this.url,
    this.color,
    this.colorBlendMode,
    this.httpHeaders,
    this.alignment = Alignment.center,
    this.cacheKey,
    this.errorListener,
    this.maxHeightDiskCache,
    this.maxWidthDiskCache,
    this.repeat = ImageRepeat.noRepeat,
    this.useOldImageOnUrlChange = false,
    this.fadeOutCurve = Curves.easeOut,
    this.fadeOutDuration = const Duration(milliseconds: 1000),
    this.fadeInCurve = Curves.easeIn,
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.filterQuality = FilterQuality.low,
    this.memCacheWidth,
    this.matchTextDirection = false,
    this.placeholderFadeInDuration,
    this.memCacheHeight,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      color: color,
      colorBlendMode: colorBlendMode,
      imageBuilder: imageBuilder,
      placeholder: placeholder,
      cacheManager: cacheManager,
      progressIndicatorBuilder: progressIndicatorBuilder ??
          (placeholder == null
              ? (_, __, ___) => _buildProgressIndicator(context)
              : null),
      fit: fit ?? BoxFit.cover,
      errorWidget: errorWidget ?? (context, url, error) => _onError(),
      httpHeaders: httpHeaders,
      alignment: alignment,
      cacheKey: cacheKey,
      errorListener: errorListener,
      maxHeightDiskCache: maxHeightDiskCache,
      maxWidthDiskCache: maxWidthDiskCache,
      repeat: repeat,
      useOldImageOnUrlChange: useOldImageOnUrlChange,
      fadeOutCurve: fadeOutCurve,
      fadeOutDuration: fadeOutDuration,
      fadeInCurve: fadeInCurve,
      fadeInDuration: fadeInDuration,
      filterQuality: filterQuality,
      memCacheWidth: memCacheWidth,
      matchTextDirection: matchTextDirection,
      placeholderFadeInDuration: placeholderFadeInDuration,
      memCacheHeight: memCacheHeight,
    );
  }

  Widget _buildProgressIndicator(context) {
    return Center(
      child: Platform.isAndroid
          ? CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            )
          : CupertinoActivityIndicator(
              color: Theme.of(context).primaryColor,
              ));
  }

  Widget _onError() {
    return const Icon(
      Icons.error,
      color: Colors.red,
    );
  }
}
