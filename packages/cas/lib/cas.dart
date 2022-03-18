import 'dart:async';

import 'package:cas/gdpr_consent.type.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';

enum CasPriceAccuracy{
  FLOOR,
  BID,
  UNDISCLOSED
}

enum CasAdType{
  Banner,
  Interstitial,
  Rewarded,
  Native,
  None,
}

class Cas {
  static const MethodChannel _channel = const MethodChannel('cas');

  static Function(bool success, String? error)? _onInitializationListener;
  static late Function(String eventName) _logger;
  static Map<String, Map<String, Function>> _callbacks = {};

  static Future<dynamic> _platformCallHandler(MethodCall call) async {
    print('CALLHANDLER: ' + call.method);
    switch (call.method) {
      case 'logger':
        _logger(call.arguments);
        break;
      case 'onInitializationListener':
        if (_onInitializationListener != null) {
          _onInitializationListener!(call.arguments[0], call.arguments[1]);
        }
        break;
      case 'onShown':
        var type;
        switch (call.arguments[1]) {
          case 'banner': type = CasAdType.Banner; break;
          case 'inter': type = CasAdType.Interstitial; break;
          case 'reward': type = CasAdType.Rewarded; break;
          case 'nativ': type = CasAdType.Native; break;
          case 'none': type = CasAdType.None; break;
        }
        var priceAccuracy;
        switch (call.arguments[3]) {
          case 0: priceAccuracy = CasPriceAccuracy.FLOOR; break;
          case 1: priceAccuracy = CasPriceAccuracy.BID; break;
          case 2: priceAccuracy = CasPriceAccuracy.UNDISCLOSED; break;
        }
        _callbacks[call.arguments[0]]!['onShown']!(type,call.arguments[2],priceAccuracy,call.arguments[4],call.arguments[5],call.arguments[6],call.arguments[7],call.arguments[8]);
        break;
      case 'onShowFailed':
        _callbacks[call.arguments[0]]!['onShowFailed']!(call.arguments[1]);
        break;
      case 'onClicked':
        _callbacks[call.arguments]!['onClicked']!();
        break;
      case 'onComplete':
        _callbacks[call.arguments]!['onComplete']!();
        break;
      case 'onClosed':
        _callbacks[call.arguments]!['onClosed']!();
        break;
      default:
        print('Unknowm method ${call.method}');
        throw MissingPluginException();
    }
  }

  static Future<Unit> initialize({bool? isTestBuild = true, Function(bool success, String? error)? onInitializationListener, String? userId, required Function(String eventName) logger}) async {
    _onInitializationListener = onInitializationListener;
    _logger = logger;
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _channel.setMethodCallHandler(_platformCallHandler);
    await _channel.invokeMethod('Initialize', {'appPackage': packageInfo.packageName, 'managerID': '1471041594', 'isTestBuild': isTestBuild, 'userID': userId});
    return unit;
  }

  static Future<void> setUserConsent(GdprConsent consent) async {
    await _channel.invokeMethod('SetUserGdprConsent', {'consent': consent.index});
  }

  static Future<void> showInterstitialAd(
      String placement,
      {
        required Function(CasAdType type, String network, CasPriceAccuracy priceAccuracy, double cpm, String status, String error, String versionInfo, String identifier) onShown,
        required Function(String error) onShowFailed,
        required Function() onClicked,
        required Function() onComplete,
        required Function() onClosed,
      }

  ) async {
    _callbacks[placement] = {
      'onShown': onShown,
      'onShowFailed': onShowFailed,
      'onClicked': onClicked,
      'onComplete': onComplete,
      'onClosed': onClosed,
    };
    await _channel.invokeMethod('ShowInterstitialAd', {'placement': placement});
  }

  static Future<void> showRewardedVideoAd(
      String placement,
      {
        required Function(CasAdType type, String network, CasPriceAccuracy priceAccuracy, double cpm, String status, String error, String versionInfo, String identifier) onShown,
        required Function(String error) onShowFailed,
        required Function() onClicked,
        required Function() onComplete,
        required Function() onClosed,
      }
    ) async {
    _callbacks[placement] = {
      'onShown': onShown,
      'onShowFailed': onShowFailed,
      'onClicked': onClicked,
      'onComplete': onComplete,
      'onClosed': onClosed,
    };
    await _channel.invokeMethod('ShowRewardedVideoAd', {'placement': placement});
  }

  static Future<bool> isAdReadyInterstitial() async {
    return await _channel.invokeMethod('isAdReadyInterstitial');
  }

  static Future<bool> isAdReadyRewarded() async {
    return await _channel.invokeMethod('isAdReadyRewarded');
  }

  static Future<void> validateIntegration() async {
    await _channel.invokeMethod('validateIntegration');
  }
}
