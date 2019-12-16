import 'dart:async';

import 'package:mockito/mockito.dart';

import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'package:glob/glob.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:scene_alert/main.dart';
import 'package:scene_alert/globals.dart' as globals;
import 'package:scene_alert/history.dart';
import 'package:scene_alert/landing.dart';
import 'package:scene_alert/location.dart';
import 'package:scene_alert/login.dart';
import 'package:scene_alert/map.dart';
import 'package:scene_alert/markerDetail.dart';
import 'package:scene_alert/register.dart';
import 'package:scene_alert/report.dart';
import 'package:scene_alert/settings.dart';

class DiskAssetBundle extends CachingAssetBundle {
  static const _assetManifestDotJson = 'AssetManifest.json';

  /// Creates a [DiskAssetBundle] by loading [globs] of assets under `assets/`.
  static Future<AssetBundle> loadGlob(
    Iterable<String> globs, {
    String from = '../',
  }) async {
    final cache = <String, ByteData>{};
    for (final pattern in globs) {
      await for (final path in Glob(pattern).list(root: from)) {
        if (path is File) {
          final bytes = await path.readAsBytes();
          cache[path.path] = ByteData.view(bytes.buffer);
        }
      }
    }
    final manifest = <String, List<String>>{};
    cache.forEach((key, _) {
      manifest[key] = [key];
    });

    cache[_assetManifestDotJson] = ByteData.view(
      Uint8List.fromList(jsonEncode(manifest).codeUnits).buffer,
    );

    return DiskAssetBundle._(cache);
  }

  final Map<String, ByteData> _cache;

  DiskAssetBundle._(this._cache);

  @override
  Future<ByteData> load(String key) async {
    return _cache[key];
  }
}

class TestAssetBundle extends CachingAssetBundle {
  TestAssetBundle(Map<String, List<String>> assets) : _assets = assets {
    for (String assetList in assets.keys) {
      for (String asset in assets[assetList]) {
        _assetMap[asset] = bytesForFile(asset);
      }
    }
  }

  final Map<String, ByteData> _assetMap = <String, ByteData>{};
  final Map<String, List<String>> _assets;

  @override
  Future<ByteData> load(String key) {
    if (key == 'AssetManifest.json') {
      return Future<ByteData>.value(bytesForJsonLike(_assets));
    }
    return Future<ByteData>.value(_assetMap[key]);
  }
}

ByteData bytesForJsonLike(Map<String, dynamic> jsonLike) => ByteData.view(
    Uint8List.fromList(const Utf8Encoder().convert(json.encode(jsonLike)))
        .buffer);

ByteData bytesForFile(String path) => ByteData.view(
    Uint8List.fromList(File('../' + path).readAsBytesSync()).buffer);

void main() {

  final AssetBundle bundle = TestAssetBundle(<String, List<String>>{
    'images/blue_foreground.png': <String>['images/blue_foreground.png'],
  });

  //LiveTestWidgetsFlutterBinding();
  final Duration delay = Duration(seconds: 5);

  testWidgets('Login screen should appear', (tester) async {
    await tester.pumpWidget(new MyApp());
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Landing Page appears', (tester) async {
    await tester.pumpWidget(new LandingPage());
    expect(find.text('Scene Alert'), findsOneWidget);
  });

}
