import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:pip_widget/src/platform_interface.dart';

import '../pip_widget.dart';

class MethodChannelPiPWidget extends PiPWidgetPlatform{

  final methodChannel = const MethodChannel('com.intileo.pip_widget');

  @override
  Future<bool> launchPIPActivity({required String initialRouteName, List<String>? arguments}) async {
   return await methodChannel.invokeMethod('start_pip_activity',{
     "initialRouteName" : initialRouteName,
     "arguments" : arguments
   });
  }

  @override
  Future<bool> enterPIP({
    Rational aspectRatio = const Rational.landscape(),
    Rectangle<int>? sourceRectHint,
  }) async {
    return await methodChannel.invokeMethod('enterPIP',
      {
        ...aspectRatio.toMap(),
        if (sourceRectHint != null)
          'sourceRectHintLTRB': [
            sourceRectHint.left,
            sourceRectHint.top,
            sourceRectHint.right,
            sourceRectHint.bottom,
          ],
      },);
  }

  @override
  Future<PiPWidgetStatus> inPipAlready() async  {
    final bool? inPipAlready = await methodChannel.invokeMethod('inPipAlready');
    return inPipAlready ?? false ? PiPWidgetStatus.enabled : PiPWidgetStatus.disabled;
  }

  @override
  Future<bool> isPipAvailable() async {
    final bool? pipAvailable =await methodChannel.invokeMethod('pipAvailable');
    return  pipAvailable ?? false;
  }

  @override
  Future<bool> onBackPressed() async  {
    return await methodChannel.invokeMethod('onBackPressed');
  }
}