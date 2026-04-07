import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';

void dprint(dynamic value, {String tag = ''}) {
  if (kDebugMode) {
    try {
      var decodedJSON = json.decode(value.toString()) as Map<String, dynamic>;
      log(
        '$tag: ${const JsonEncoder.withIndent('    ').convert(decodedJSON)}\n',
      );
    } catch (_) {
      if (value is Map) {
        log('$tag: ${const JsonEncoder.withIndent('    ').convert(value)}\n');
      } else {
        log('$tag: $value\n');
      }
    }
  }
}
