import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'dart:developer' as developer;

class CustomLogger {
  static void enableLogger() {
    final log = Logger('logger');

    Logger.root.level = kDebugMode
        ? Level.ALL
        : Level.INFO; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      developer.log(
        record.message,
        error: record.error,
        level: record.level.value,
        name: '${record.level.name.padRight(7, ' ')} ${record.loggerName}',
        sequenceNumber: record.sequenceNumber,
        stackTrace: record.stackTrace,
        time: record.time,
        zone: record.zone,
      );
    });

    if (kDebugMode) {
      log.finest('Logging logger ${Level.FINEST.value} "Finest"');
      log.finer('Logging logger ${Level.FINER.value} "Finer"');
      log.fine('Logging logger ${Level.FINE.value} "Fine"');
      log.config('Logging logger ${Level.CONFIG.value} "Config"');
      log.info('Logging logger ${Level.INFO.value} "Info"');
      log.warning('Logging logger ${Level.WARNING.value} "Warning"');
      log.severe('Logging logger ${Level.SEVERE.value} "Severe"');
      log.shout('Logging logger ${Level.SHOUT.value} "Shout"');
      log.log(const Level('CUSTOM', 1600), 'Logging logger 1600 "custom"');
    }
  }
}
