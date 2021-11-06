import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viddroid_flutter/cards/watchable_card.dart';
import 'package:viddroid_flutter/watchable/watchable.dart';
import 'package:viddroid_flutter/watchable/watchables.dart';

class WatchableList extends StatefulWidget {
  const WatchableList({Key? key}) : super(key: key);

  @override
  State<WatchableList> createState() => _WatchableListState();
}

class _WatchableListState extends State<WatchableList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: Watchables().watchables.length,
        itemBuilder: (context, i) {
          Watchable watchable = Watchables().watchables[i];
          return WatchableCard(
            watchable,
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                setState(() {
                  if (Watchables().contains(watchable)) {
                    Watchables().remove(watchable);
                  }
                });
                return true;
              }
              return false;
            },
            dismissColor: Colors.red,
          );
        });
  }
}
