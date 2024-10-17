import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  final String? url;

  final BoxFit? fit;
  final double? width;
  final double? height;

  final String? placeholder;
  final Size? sizeServer;
  final bool isScale;
  final bool isZoom;

  final ImageWidgetBuilder? imageBuilder;

  final ProgressIndicatorBuilder? progressIndicatorBuilder;
  final LoadingErrorWidgetBuilder? errorWidget;
  final Duration? placeholderFadeInDuration;
  final Duration? fadeOutDuration;
  final Curve fadeOutCurve;
  final Duration fadeInDuration;
  final Curve fadeInCurve;
  final Alignment alignment;
  final ImageRepeat repeat;
  final bool matchTextDirection;
  final bool? isShowAppBar;
  final Map<String, String>? httpHeaders;
  final bool useOldImageOnUrlChange;
  final Color? color;
  final BlendMode? colorBlendMode;
  final FilterQuality filterQuality;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final String? cacheKey;
  final String? hero;

  const AppImage(
    this.url, {
    super.key,
    this.hero,
    this.sizeServer,
    this.isScale = false,
    this.isZoom = false,
    this.fit,
    this.width,
    this.height,
    this.placeholder,
    this.httpHeaders,
    this.imageBuilder,
    this.progressIndicatorBuilder,
    this.errorWidget,
    this.fadeOutDuration = const Duration(milliseconds: 300),
    this.fadeOutCurve = Curves.easeOut,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.fadeInCurve = Curves.easeIn,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.useOldImageOnUrlChange = false,
    this.color,
    this.filterQuality = FilterQuality.low,
    this.colorBlendMode,
    this.placeholderFadeInDuration,
    this.memCacheWidth,
    this.memCacheHeight,
    this.cacheKey,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.isShowAppBar = true,
  });

  Widget get _placeholderWidget => Image.asset(
        placeholder ?? 'assets/images/placeholder.png',
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey.shade200,
            padding: const EdgeInsets.all(16),
            child: const Icon(Icons.image),
          );
        },
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
        matchTextDirection: matchTextDirection,
        color: color,
        filterQuality: filterQuality,
        colorBlendMode: colorBlendMode,
      );

  @override
  Widget build(BuildContext context) {
    String imageUrl = url ?? '';

    if (imageUrl.isEmpty) {
      return _placeholderWidget;
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: fit,
      placeholder: (context, url) {
        return _placeholderWidget;
      },
      errorWidget: errorWidget ??
          (context, url, error) {
            return _placeholderWidget;
          },
      httpHeaders: httpHeaders,
      imageBuilder: imageBuilder,
      progressIndicatorBuilder: progressIndicatorBuilder,
      fadeOutDuration: fadeOutDuration,
      fadeOutCurve: fadeOutCurve,
      fadeInDuration: fadeInDuration,
      fadeInCurve: fadeInCurve,
      alignment: alignment,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      useOldImageOnUrlChange: useOldImageOnUrlChange,
      color: color,
      filterQuality: filterQuality,
      colorBlendMode: colorBlendMode,
      placeholderFadeInDuration: placeholderFadeInDuration,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      cacheKey: cacheKey,
      maxWidthDiskCache: maxWidthDiskCache,
      maxHeightDiskCache: maxHeightDiskCache,
    );
  }
}
