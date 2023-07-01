import 'dart:developer';

void catchErrorLogger(e, stacktrace) {
  log(e.toString());
  log('Message: $e');
  log('Stacktrace: $stacktrace');
}
