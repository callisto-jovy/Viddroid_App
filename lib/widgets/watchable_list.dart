import 'package:flutter/cupertino.dart';
import 'package:viddroid_flutter/cards/watchable_card.dart';
import 'package:viddroid_flutter/watchable/watchables.dart';

class WatchableList extends StatelessWidget {
  const WatchableList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: Watchables().watchables.length,
      itemBuilder: (context, i) {
        return WatchableCard(Watchables().watchables[i]);
      },
    );
  }
}
