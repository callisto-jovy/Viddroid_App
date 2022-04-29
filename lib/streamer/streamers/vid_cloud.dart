import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:viddroid_flutter/connection/random_user_agent.dart';
import 'package:viddroid_flutter/streamer/streamer.dart';
import 'package:viddroid_flutter/streamer/streamers.dart';
import 'package:viddroid_flutter/util/basic_util.dart';
import 'package:viddroid_flutter/util/passable_url.dart';

class VidCloud extends Streamer {
  @override
  Future<PremadeRequestURL> resolveStreamURL(String? referral,
      {Map<String, String>? headers}) async {
    if (referral == null) {
      return Future.error('Vidcloud referral is null');
    }

    referral = referral.replaceAll(RegExp(r'streaming\.php|load\.php'), 'download');

    var resp = await http.get(Uri.parse(referral), headers: {'user-agent': getRandomUserAgent()});
    if (resp.statusCode == 200) {
      var document = parse(resp.body);

      List<Element> downloadElements = document
          .querySelectorAll('.dowload > a')
          .where((element) => element.attributes['href'] != null)
          .toList();

      Element? bestStream;
      int max = 0;

      for (Element element in downloadElements) {
        String textReplaced = element.text.replaceAll(RegExp(r'[^0-9]+'), '');

        if (textReplaced.isEmpty) continue;

        int e = int.parse(textReplaced);

        if (e >= max && element.text.isNotEmpty) {
          max = e;
          bestStream = element;
        }
      }

      if (bestStream == null) {
        for (Element element in downloadElements) {
          String stripped = element.text.substring(element.text.indexOf(' ')).trim();

          for (Streamers s in Streamers.values) {
            if (s.name.equalsIgnoreCase(stripped)) {
              return s.streamer!
                  .resolveStreamURL(element.attributes['href']!, headers: {'Referrer': referral});
            }
          }
        }
      } else {
        return PremadeRequestURL(bestStream.attributes['href']!, headers: {
          'User-Agent': getRandomUserAgent(),
        });
      }
    } else {
      return Future.error('Vidcloud responded with SC ${resp.statusCode}');
    }
    return Future.error('Vidcloud failed');
  }
}
