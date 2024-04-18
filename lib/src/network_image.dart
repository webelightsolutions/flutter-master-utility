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
