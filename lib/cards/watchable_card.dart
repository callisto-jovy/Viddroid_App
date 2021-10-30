import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viddroid_flutter/cards/general_purpose_card.dart';
import 'package:viddroid_flutter/pages/movie_detail_page.dart';
import 'package:viddroid_flutter/pages/tv_detail_page.dart';
import 'package:viddroid_flutter/tasks/request_metadata_task.dart';
import 'package:viddroid_flutter/watchable/watchable.dart';

class WatchableCard extends StatefulWidget {
  final Watchable _watchable;

  const WatchableCard(this._watchable, {Key? key}) : super(key: key);

  @override
  WatchableCardState createState() => WatchableCardState();
}

class WatchableCardState extends State<WatchableCard> {
  @override
  void initState() {
    super.initState();
    requestTVData();
  }

  void requestTVData() async {
    if (widget._watchable is TVShow && (widget._watchable as TVShow).getSeasons.isEmpty) {
      TheMovieDBTVDetailsRequestTask().call(widget._watchable as TVShow);
    }
  }

  @override
  void dispose() {
    super.dispose();
    //TODO: Implement check
    if (widget._watchable is TVShow) {
      (widget._watchable as TVShow).getSeasons.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GeneralPurposeCard(
        title: widget._watchable.title,
        description: widget._watchable.description,
        lowerCaption: (widget._watchable is TVShow) ? 'TV-Show' : 'Movie',
        imageURL: widget._watchable.getCardImage(),
        imageWidth: 100,
        imageHeight: 150,
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return widget._watchable is TVShow
                  ? TVShowDetailPage(widget._watchable as TVShow)
                  : MovieDetailPage(widget._watchable as Movie);
            })));
  }
}
