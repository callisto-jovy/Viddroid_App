import 'dart:convert';

import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:js_packer/js_packer.dart';
import 'package:viddroid_flutter/connection/random_user_agent.dart';
import 'package:viddroid_flutter/provider/providers/movies_co.dart';
import 'package:viddroid_flutter/util/passable_url.dart';

import '../streamer.dart';

class Gomo extends Streamer with MoviesCoAPI {

  @override
  Future<PassableURL> resolveStreamURL(String? referral, {Map<String, String>? headers}) async {
    if (referral == null) {
      return Future.error('Gomo referral is null');
    }

    headers ??= {};
    headers['User-Agent'] = getRandomUserAgent();

    var response = await http.get(Uri.parse(referral), headers: headers);

    if (response.statusCode == 200) {
      var tcMatch = tcExpr.firstMatch(response.body);
      var tokenMatch = tokenRegex.firstMatch(response.body);
      var funcMatch = functionRegex.hasMatch(response.body);

      if (tcMatch != null && tokenMatch != null && funcMatch) {
        String tcGroup = tcMatch.group(1)!;
        String tokenGroup = tokenMatch.group(0)!;

        var sliceMatch = sliceRegex.firstMatch(response.body);
        var rndNumbMatch = rndNumRegex.firstMatch(response.body);

        if (sliceMatch != null) {
          String sliceStart = sliceMatch.group(1)!;
          String sliceEnd = sliceMatch.group(2)!;

          String xToken = tcGroup
                  .substring(int.parse(sliceStart), int.parse(sliceEnd))
                  .split("")
                  .reversed
                  .join("") +
              (rndNumbMatch != null ? (rndNumbMatch.groups([1, 2]).join('')) : "");

          var decodingAPIResp = await http.post(Uri.parse(decodingAPI), body: {
            'tokenCode': tcGroup,
            '_token': tokenGroup
          }, headers: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'User-Agent': getRandomUserAgent(),
            'x-token': xToken,
            'Referrer': referral,
          });

          if (decodingAPIResp.statusCode == 200) {
            var array = jsonDecode(decodingAPIResp.body);
            for (int i = 0; i < array.length; i++) {
              String arrayReferral = array[i];

              if (arrayReferral.startsWith('https://gomo')) {
                var redirectResp = await http.get(Uri.parse(arrayReferral), headers: {
                  'User-Agent': getRandomUserAgent(),
                });

                if (redirectResp.statusCode == 200) {
                  var document = parse(redirectResp.body);

                  String? e = document
                      .getElementsByTagName('script')
                      .where((element) => element.innerHtml.startsWith('eval'))
                      .map((e) => e.innerHtml)
                      .first;

                  if (e.isNotEmpty) {
                    JSPacker jsPacker = JSPacker(e);
                    String? unpacked = jsPacker.unpack();
                    if (unpacked != null) {
                      var sourceMatch = sourceRegex.firstMatch(unpacked);
                      if (sourceMatch != null && sourceMatch.group(0) != null) {
                        return PassableURL(sourceMatch.group(0)!, headers: {
                          'Referrer': arrayReferral,
                        });
                      }
                    }
                  }
                } else {
                  Future.error('Redirect failed with status code ${redirectResp.statusCode}');
                }
              }
            }
          } else {
            return Future.error('Decoding API not available');
          }
        } else {
          Future.error('Slice match null');
        }
      } else {
        return Future.error('Regex failed');
      }
    } else {
      return Future.error('Referral returned statues code ${response.statusCode}');
    }
    return Future.error('Response failed');
  }
}
