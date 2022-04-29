import 'package:viddroid_flutter/util/passable_url.dart';

abstract class Streamer {
  Future<PremadeRequestURL> resolveStreamURL(final String? referral,
      {Map<String, String>? headers});
}
