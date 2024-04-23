part of pip_widget;

class PipWidget {
  final Duration? _probeInterval;
  Timer? _timer;
  final _controller = StreamController<PiPWidgetStatus>();
  Stream<PiPWidgetStatus>? _stream;


  PipWidget({
    Duration probeInterval = const Duration(milliseconds: 100),
  }) : _probeInterval = probeInterval;


  Future<bool> launchPIPActivity({required String initialRouteName, List<String>? arguments}) async {
    return await PiPWidgetPlatform.instance.launchPIPActivity(initialRouteName: initialRouteName, arguments: arguments);
  }

  Stream<PiPWidgetStatus> get pipStatus$ {
    _timer ??= Timer.periodic(
      _probeInterval!,
          (_) async => _controller.add(await pipStatus),
    );
    _stream ??= _controller.stream.asBroadcastStream();
    return _stream!.distinct();
  }

  Future<PiPWidgetStatus> get pipStatus async {
    if(! await isPipAvailable){
      return PiPWidgetStatus.unavailable;
    }
    return PiPWidgetPlatform.instance.inPipAlready();
  }

  Future<bool> get isPipAvailable async {
  return await PiPWidgetPlatform.instance.isPipAvailable();
  }

  Future<bool> enterPIP({
    Rational aspectRatio = const Rational.landscape(),
    Rectangle<int>? sourceRectHint,
  }) async {
    if (!aspectRatio.fitsInAndroidRequirements) {
      throw RationalNotMatchingAndroidRequirementsException(aspectRatio);
    }
    return await PiPWidgetPlatform.instance.enterPIP(aspectRatio: aspectRatio, sourceRectHint: sourceRectHint);
  }

  Future<bool> onBackPressed() async {
    return await PiPWidgetPlatform.instance.onBackPressed();
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }

}


/// Represents rational in [numerator]/[denominator] notation.
class Rational {
  final int numerator;
  final int denominator;
  double get aspectRatio => numerator / denominator;

  const Rational(this.numerator, this.denominator);

  const Rational.square()
      : numerator = 1,
        denominator = 1;

  const Rational.landscape()
      : numerator = 16,
        denominator = 9;

  const Rational.vertical()
      : numerator = 9,
        denominator = 16;

  @override
  String toString() =>
      'Rational(numerator: $numerator, denominator: $denominator)';

  Map<String, dynamic> toMap() => {
    'numerator': numerator,
    'denominator': denominator,
  };
}

/// Extension for [Rational] to confirm whether Android aspect ration
/// requirements are met or not.
extension on Rational {
  /// Checks whether given [Rational] instance fits into Android requirements
  /// or not.
  ///
  /// Android docs specified boundaries as inclusive.
  bool get fitsInAndroidRequirements {
    final aspectRatio = numerator / denominator;
    const min = 1 / 2.39;
    const max = 2.39;
    return (min <= aspectRatio) && (aspectRatio <= max);
  }
}

/// Provides details about Android requirements and compares current
/// [rational] value to those.
class RationalNotMatchingAndroidRequirementsException implements Exception {
  final Rational rational;

  RationalNotMatchingAndroidRequirementsException(this.rational);

  @override
  String toString() => 'RationalNotMatchingAndroidRequirementsException('
      '${rational.numerator}/${rational.denominator} does not fit into '
      'Android-supported aspect ratios. Boundaries: '
      'min: 1/2.39, max: 2.39/1. '
      ')';
}
