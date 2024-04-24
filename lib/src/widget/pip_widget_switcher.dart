part of pip_widget;


class PiPWidgetSwitcher extends StatefulWidget {
  final PipWidget? pipWidget;
  final Widget childWhenEnabled;
  final Widget childWhenDisabled;

  const PiPWidgetSwitcher(
      {Key? key,
      required this.childWhenEnabled,
      required this.childWhenDisabled,
      this.pipWidget})
      : super(key: key);

  @override
  State<PiPWidgetSwitcher> createState() => _PiPWidgetSwitcherState();
}

class _PiPWidgetSwitcherState extends State<PiPWidgetSwitcher> {
  late final PipWidget _pipWidget = widget.pipWidget ?? PipWidget();

  @override
  void dispose() {
    if (widget.pipWidget == null) {
      _pipWidget.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder(
  stream : _pipWidget.pipStatus$,
      builder: (context, snapshot) =>
          snapshot.data == PiPWidgetStatus.enabled
              ? widget.childWhenEnabled
              : widget.childWhenDisabled);
}
