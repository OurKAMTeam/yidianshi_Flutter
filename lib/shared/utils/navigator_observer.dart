import 'package:flutter/material.dart';
import 'logger.dart';

class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log.info("Pushed route: ${route.settings.name} (from: ${previousRoute?.settings.name})");
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log.info("Popped route: ${route.settings.name} (to: ${previousRoute?.settings.name})");
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log.info("Removed route: ${route.settings.name} (from: ${previousRoute?.settings.name})");
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    log.info("Replaced route: ${oldRoute?.settings.name} with ${newRoute?.settings.name}");
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
