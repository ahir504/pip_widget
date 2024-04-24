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
    if(state == AppLifecycleState.inactive){
      pipWidget.enterPIP(aspectRatio: const Rational.vertical());
    }
    super.didChangeAppLifecycleState(state);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            pipWidget.onBackPressed();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text("PiP Widget Example"),
      ),
      body: PopScope(
        canPop: true,
        onPopInvoked: (_){
          pipWidget.onBackPressed();
        },
        child: PiPWidgetSwitcher(
          pipWidget: pipWidget,
          childWhenDisabled: Center(
            child: Column(
              children: [
                const Text("PiP is not active"),
                Text(widget.args!.toString()),
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
