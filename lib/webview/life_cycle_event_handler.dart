import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback? resumeCallBack;
  final AsyncCallback? suspendingCallBack;
  final AsyncCallback? pausedCallBack;

  LifecycleEventHandler(
      {this.resumeCallBack, this.suspendingCallBack, this.pausedCallBack});

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (resumeCallBack != null) {
          await resumeCallBack!();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        if (pausedCallBack != null) {
          await pausedCallBack!();
        }
        break;
      case AppLifecycleState.detached:
        if (suspendingCallBack != null) {
          await suspendingCallBack!();
        }
        break;
    }
  }
}
