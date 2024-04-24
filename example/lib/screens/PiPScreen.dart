import 'package:flutter/material.dart';
import 'package:pip_widget/pip_widget.dart';
import 'package:pip_widget_example/main.dart';

class PiPScreen extends StatefulWidget {
  final List<String>? args;

  const PiPScreen({this.args, super.key});

  @override
  State<PiPScreen> createState() => _PiPScreenState();
}

class _PiPScreenState extends State<PiPScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _enablePiP();
    }
    super.didChangeAppLifecycleState(state);
  }

  _enablePiP() {
    pipWidget.enterPIP(aspectRatio: const Rational.vertical());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            pipWidget.onBackPressed();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text("PiP Widget Example"),
      ),
      body: PopScope(
        canPop: true,
        onPopInvoked: (_) {
          pipWidget.onBackPressed();
        },
        child: PiPWidgetSwitcher(
          pipWidget: pipWidget,
          childWhenDisabled: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("PiP is not active"),
                const SizedBox(height: 20,),
                Text(widget.args!.toString()),
                const SizedBox(height: 20,),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      onPressed: () => _enablePiP,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.picture_in_picture),
                          SizedBox(width: 20,),
                          Text("Enter in PiP"),
                        ],
                      )),
                )
              ],
            ),
          ),
          childWhenEnabled: Center(
            child: Column(
              children: [
                const Text("PiP is active"),
                Text(widget.args!.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
