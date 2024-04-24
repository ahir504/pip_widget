import 'package:flutter/material.dart';
import 'package:pip_widget/pip_widget.dart';
import 'package:pip_widget_example/screens/NonPiPScreen.dart';
import 'package:pip_widget_example/screens/PiPScreen.dart';
PipWidget pipWidget = PipWidget();
List<String>? newArgs;
void main(List<String> args) {
  newArgs = args;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
   const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  List<Route<dynamic>> onGenerateInitialRoutes(String initialRouteName) {
    List<Route<dynamic>> pageStack = [];
    switch(initialRouteName){
      case "/":
          pageStack.add(MaterialPageRoute(builder: (_) => const NonPiPScreen()));
          break;
      case "/pipScreen":
          pageStack.add(MaterialPageRoute(builder: (_) => PiPScreen(args: newArgs!)));
          break;
    }
    return pageStack;
  }

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch(settings.name){
      case "/":
        return MaterialPageRoute(builder: (_) => const NonPiPScreen());
      case "/pipScreen":
        return MaterialPageRoute(builder: (_) => PiPScreen(args: newArgs));
      default:
        return MaterialPageRoute(builder: (_) => const NonPiPScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PiP Widget Example',
      navigatorKey: navigatorKey,
      onGenerateInitialRoutes: onGenerateInitialRoutes,
      onGenerateRoute: onGenerateRoute,
      theme: ThemeData(primaryColor: Colors.deepPurpleAccent),
    );
  }
}
