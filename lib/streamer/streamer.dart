import 'package:viddroid_flutter/util/passable_url.dart';

abstract class Streamer {
  Future<PassableURL> resolveStreamURL(final String? referral, {Map<String, String>? headers});
}
