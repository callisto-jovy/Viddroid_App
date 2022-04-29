import 'package:http/http.dart' as http;
import 'package:viddroid_flutter/connection/random_user_agent.dart';
import 'package:viddroid_flutter/provider/providers/movies_co.dart';
import 'package:viddroid_flutter/streamer/streamer.dart';
import 'package:viddroid_flutter/util/passable_url.dart';

class StreamSB extends Streamer with MoviesCoAPI {
  @override
  Future<PremadeRequestURL> resolveStreamURL(String? referral,
      {Map<String, String>? headers}) async {
    if (referral == null) {
      return Future.error('StreamSB referral is null');
    }

    referral = referral.replaceAll('/play/', '/d/');

    var response = await http.get(Uri.parse(referral), headers: headers);

    if (response.statusCode == 200) {
      RegExpMatch? onClickMatch = onClickRegex.firstMatch(response.body);
      if (onClickMatch != null) {
        String id = onClickMatch.group(1)!;
        String mode = onClickMatch.group(2)!;
        String hash = onClickMatch.group(3)!;

        String downloadURL = 'https://sbplay1.com/dl?op=download_orig&id=$id&mode=$mode&hash=$hash';

        await Future.delayed(const Duration(seconds: 5));

        var response = await http.get(Uri.parse(downloadURL),
            headers: {'Referrer': referral, 'User-Agent': getRandomUserAgent()});

        if (response.statusCode == 200) {
          RegExpMatch? directDownloadMatcher = directDownloadRegex.firstMatch(response.body);
          if (directDownloadMatcher != null) {
            return PremadeRequestURL(directDownloadMatcher.group(1)!,
                headers: {'Referrer': downloadURL});
          } else {
            return Future.error('direct download match failed');
          }
        } else {
          return Future.error('StreamSB download page returned with SC ${response.statusCode}');
        }
      } else {
        return Future.error('onClick match failed');
      }
    } else {
      return Future.error('StreamSB returned with SC ${response.statusCode}');
    }
  }
}
