import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viddroid_flutter/cards/general_purpose_card.dart';
import 'package:viddroid_flutter/pages/movie_detail_page.dart';
import 'package:viddroid_flutter/pages/tv_detail_page.dart';
import 'package:viddroid_flutter/tasks/request_metadata_task.dart';
import 'package:viddroid_flutter/watchable/watchable.dart';

class WatchableCard extends StatelessWidget {
  final Watchable _watchable;

  const WatchableCard(this._watchable, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GeneralPurposeCard(
        title: _watchable.title,
        description: _watchable.description,
        lowerCaption: (_watchable is TVShow) ? 'TV-Show' : 'Movie',
        imageURL: _watchable.getCardImage(),
        imageWidth: 100,
        imageHeight: 150,
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return _watchable is TVShow
                  ? TVShowDetailPage(_watchable as TVShow)
                  : MovieDetailPage(_watchable as Movie);
            })));
  }
}
