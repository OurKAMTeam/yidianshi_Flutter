// Copyright 2024 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:catcher_2/catcher_2.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

final log = TalkerFlutter.init();
final logDioAdapter = TalkerDioLogger(
  talker: log,
  settings: const TalkerDioLoggerSettings(
    printRequestHeaders: true,
    printResponseHeaders: true,
    printResponseMessage: true,
  ),
);

class PDACatcher2Logger extends Catcher2Logger {
  final Map<String, DateTime> _lastErrorTime = {};
  final Duration _errorThreshold = const Duration(milliseconds: 3000);

  void _logWithStack(String level, String message) {
    try {
      throw Exception();
    } catch (e, stack) {
      final key = '$message${stack.toString()}';
      final now = DateTime.now();
      final lastTime = _lastErrorTime[key];

      if (lastTime == null || now.difference(lastTime) > _errorThreshold) {
        _lastErrorTime[key] = now;
        log.logTyped(
          TalkerLog(
            '$message\nStack trace:\n$stack',
            title: 'Custom Catcher2 Logger | $level',
            logLevel: level == 'Error' ? LogLevel.error : LogLevel.info,
          ),
        );
      }
    }
  }

  @override
  void info(String message) {
    _logWithStack('Info', message);
  }

  @override
  void fine(String message) {
    _logWithStack('Fine', message);
  }

  @override
  void warning(String message) {
    _logWithStack('Warning', message);
  }

  @override
  void severe(String message) {
    _logWithStack('Severe', message);
  }
}
