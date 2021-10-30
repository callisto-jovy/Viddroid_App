import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viddroid_flutter/watchable/watchable.dart';
import 'package:viddroid_flutter/watchable/watchables.dart';

class FavoriteBottomSheetDialog extends StatelessWidget {
  final Watchable watchable;

  FavoriteBottomSheetDialog({Key? key, required this.watchable}) : super(key: key);

  bool containsWatchable = false;

  @override
  Widget build(BuildContext context) {
    containsWatchable = Watchables().contains(watchable);
    return StatefulBuilder(
      builder: (context, setState) => SizedBox(
        height: 100,
        child: Column(
          children: [
            TextButton.icon(
              onPressed: () {
                updated(setState);
              },
              icon: const Icon(Icons.favorite),
              label: Text(containsWatchable ? 'Remove from favorites' : 'Add to favorites'),
            ),
            TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.bookmark),
                label: const Text('Add to bookmarks')),
          ],
        ),
      ),
    );
  }

  Future<void> updated(StateSetter updateState) async {
    updateState(() {
      bool contains = false;
      if (Watchables().contains(watchable)) {
        Watchables().remove(watchable);
      } else {
        Watchables().addWatchable(watchable);
        contains = true;
      }
      containsWatchable = contains;
    });
  }
}
