import 'package:flutter/material.dart';

class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Logic when a new route is pushed onto the navigator stack
    print('New route pushed: ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Logic when a route is popped from the navigator stack
    print('Route popped: ${route.settings.name}');
  }

  // Add more override methods as needed
}
