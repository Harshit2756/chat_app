import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HImageWidget extends StatelessWidget {
  final String? source;
  final Uint8List? bytes;
  final double? height;
  final double? width;
  final BoxDecoration? boxDecoration;
  final Color? tint;
  final BoxFit? fit;
  final Widget? placeholder;
  final bool isCircular;

  const HImageWidget({
    this.source,
    this.bytes,
    this.width,
    this.height,
    this.tint,
    this.fit = BoxFit.cover,
    super.key,
    this.placeholder,
    this.boxDecoration,
    this.isCircular = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = _isValidSource()
        ? _isSvg(source!)
            ? Container(
                decoration: boxDecoration ?? const BoxDecoration(),
                width: width,
                height: height,
                child: _isNetworkImage(source!)
                    ? SvgPicture.network(
                        source!,
                        fit: fit ?? BoxFit.cover,
                        colorFilter: _getColorFilter(),
                        placeholderBuilder: (_) => _getPlaceholder(),
                        semanticsLabel: 'SVG Image',
                      )
                    : SvgPicture.asset(
                        source!,
                        fit: fit ?? BoxFit.cover,
                        colorFilter: _getColorFilter(),
                        placeholderBuilder: (_) => _getPlaceholder(),
                        semanticsLabel: 'SVG Image',
                      ),
              )
            : _isNetworkImage(source!)
                ? Image.network(
                    source!,
                    height: height,
                    width: width,
                    fit: fit,
                    loadingBuilder: (_, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _getPlaceholder();
                    },
                    errorBuilder: (_, __, ___) => placeholder ?? _getPlaceholder(),
                  )
                : Image.asset(source!, height: height, width: width, fit: fit, color: tint)
        : _isValidBytes()
            ? Image.memory(bytes!, height: height, width: width, fit: fit, color: tint)
            : _getPlaceholder();

    if (isCircular) {
      return ClipOval(
        child: SizedBox(
          width: width,
          height: height,
          child: imageWidget,
        ),
      );
    }

    return imageWidget;
  }

  /// Returns a color filter if imageTint is provided
  ColorFilter? _getColorFilter() {
    return tint != null ? ColorFilter.mode(tint!, BlendMode.srcIn) : null;
  }

  /// Returns the placeholder widget
  Widget _getPlaceholder() {
    Widget placeholderWidget = placeholder ??
        ColoredBox(
          color: Colors.grey[300]!,
          child: SizedBox(
            width: width,
            height: height,
            child: const Icon(Icons.person, size: 40, color: Colors.black87),
          ),
        );

    return isCircular
        ? ClipOval(
            child: SizedBox(
              width: width,
              height: height,
              child: placeholderWidget,
            ),
          )
        : placeholderWidget;
  }

  /// Determines if the source is a network URL
  bool _isNetworkImage(String input) {
    return input.toLowerCase().startsWith("http") || input.toLowerCase().startsWith("https");
  }

  /// Checks if the given `source` is an SVG
  bool _isSvg(String input) {
    return input.toLowerCase().contains(".svg");
  }

  /// Checks if the `bytes` are valid
  bool _isValidBytes() => bytes != null && bytes!.isNotEmpty;

  /// Checks if the given `source` is a valid string
  bool _isValidSource() => source?.isNotEmpty == true;
}
