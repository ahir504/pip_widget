
import 'dart:math';

import 'package:pip_widget/src/method_channel.dart';
import 'package:pip_widget/src/pip_status.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../pip_widget.dart';

abstract class PiPWidgetPlatform extends PlatformInterface {
  PiPWidgetPlatform() : super(token: _token);

  static final Object _token = Object();

  static PiPWidgetPlatform _instance = MethodChannelPiPWidget();


  static PiPWidgetPlatform get instance => _instance;


  static set instance (PiPWidgetPlatform instance){
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> launchPIPActivity({required String initialRouteName, List<String>? arguments}){
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> enterPIP({
    Rational aspectRatio = const Rational.landscape(),
    Rectangle<int>? sourceRectHint,
  }){
    throw UnimplementedError('enterPIP() has not been implemented.');
  }

  Future<PiPWidgetStatus> inPipAlready(){
    throw UnimplementedError("inPipAlready() has not been implemented.");
  }

  Future<bool> isPipAvailable(){
    throw UnimplementedError("isPipAvailable() has not been implemented.");
  }

  Future<bool> onBackPressed(){
    throw UnimplementedError("onBackPressed() has not been implemented.");
  }

}