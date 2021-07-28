import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

final logger = Logger('SiteInfoService');

void initRootLogger() {
  // only enable logging for debug mode
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
  } else {
    Logger.root.level = Level.OFF;
  }
  hierarchicalLoggingEnabled = true;

  // specify the levels for lower level loggers, if deswired
  // Logger('SiteInfoService').level = Level.ALL;

  Logger.root.onRecord.listen((record) {
    if (!kDebugMode) {
      return;
    }

    var start = '\x1b[90m';
    const end = '\x1b[0m';
    const white = '\x1b[37m';
    // colors: https://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html
    switch (record.level.name) {
      case 'INFO':
        start = '\u001b[32m';
        break;
      case 'WARNING':
        start = '\x1b[93m';
        break;
      case 'SEVERE':
        start = '\u001b[31m';
        break;
      case 'SHOUT':
        start = '\u001b[31m';
        break;
    }

    final message =
        '$white${record.time}:$end$start${record.level.name}: ${record.message}$end';
    developer.log(
      message,
      name: record.loggerName.padRight(25),
      level: record.level.value,
      time: record.time,
    );
  });
}

void exampleLogs(Logger logger) {
  logger.finest('example finest log entry');
  logger.finer('example finer log entry');
  logger.fine('example fine log entry');
  logger.info('example info log entry');
  logger.warning('example warning log entry');
  logger.severe('example severe log entry');
  logger.shout('example shout log entry');
}
