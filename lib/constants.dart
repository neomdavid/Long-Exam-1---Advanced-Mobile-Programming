// ignore_for_file: constant_identifier_names
import 'package:flutter_dotenv/flutter_dotenv.dart';

String get host {
  try {
    return dotenv.env['HOST'] ?? 'http://10.0.2.2:5000';
  } catch (e) {
    print('DotEnv not initialized, using fallback host: $e');
    return 'http://10.0.2.2:5000';
  }
}
