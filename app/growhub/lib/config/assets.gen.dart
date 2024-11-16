/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsIconsUiGen {
  const $AssetsIconsUiGen();

  /// File path: assets/icons-ui/bell.svg
  SvgGenImage get bell => const SvgGenImage('assets/icons-ui/bell.svg');

  /// File path: assets/icons-ui/calendar.svg
  SvgGenImage get calendar => const SvgGenImage('assets/icons-ui/calendar.svg');

  /// File path: assets/icons-ui/checkmark.svg
  SvgGenImage get checkmark =>
      const SvgGenImage('assets/icons-ui/checkmark.svg');

  /// File path: assets/icons-ui/leaf.svg
  SvgGenImage get leaf => const SvgGenImage('assets/icons-ui/leaf.svg');

  /// File path: assets/icons-ui/settings.svg
  SvgGenImage get settings => const SvgGenImage('assets/icons-ui/settings.svg');

  /// File path: assets/icons-ui/thermometer.svg
  SvgGenImage get thermometer =>
      const SvgGenImage('assets/icons-ui/thermometer.svg');

  /// File path: assets/icons-ui/user.svg
  SvgGenImage get user => const SvgGenImage('assets/icons-ui/user.svg');

  /// List of all assets
  List<SvgGenImage> get values =>
      [bell, calendar, checkmark, leaf, settings, thermometer, user];
}

class $AssetsKwiatkiGen {
  const $AssetsKwiatkiGen();

  /// File path: assets/kwiatki/cactus-svgrepo-com.svg
  SvgGenImage get cactusSvgrepoCom =>
      const SvgGenImage('assets/kwiatki/cactus-svgrepo-com.svg');

  /// File path: assets/kwiatki/daisy-svgrepo-com.svg
  SvgGenImage get daisySvgrepoCom =>
      const SvgGenImage('assets/kwiatki/daisy-svgrepo-com.svg');

  /// File path: assets/kwiatki/flower-rose-svgrepo-com.svg
  SvgGenImage get flowerRoseSvgrepoCom =>
      const SvgGenImage('assets/kwiatki/flower-rose-svgrepo-com.svg');

  /// File path: assets/kwiatki/flower-svgrepo-com1.svg
  SvgGenImage get flowerSvgrepoCom1 =>
      const SvgGenImage('assets/kwiatki/flower-svgrepo-com1.svg');

  /// File path: assets/kwiatki/flower-svgrepo-com2.svg
  SvgGenImage get flowerSvgrepoCom2 =>
      const SvgGenImage('assets/kwiatki/flower-svgrepo-com2.svg');

  /// File path: assets/kwiatki/plant-svgrepo-com.svg
  SvgGenImage get plantSvgrepoCom =>
      const SvgGenImage('assets/kwiatki/plant-svgrepo-com.svg');

  /// File path: assets/kwiatki/sprout-plant-svgrepo-com.svg
  SvgGenImage get sproutPlantSvgrepoCom =>
      const SvgGenImage('assets/kwiatki/sprout-plant-svgrepo-com.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        cactusSvgrepoCom,
        daisySvgrepoCom,
        flowerRoseSvgrepoCom,
        flowerSvgrepoCom1,
        flowerSvgrepoCom2,
        plantSvgrepoCom,
        sproutPlantSvgrepoCom
      ];
}

class Assets {
  Assets._();

  static const $AssetsIconsUiGen iconsUi = $AssetsIconsUiGen();
  static const $AssetsKwiatkiGen kwiatki = $AssetsKwiatkiGen();
}

class SvgGenImage {
  const SvgGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = false;

  const SvgGenImage.vec(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter: colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
