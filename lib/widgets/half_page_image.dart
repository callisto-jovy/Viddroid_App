import 'package:flutter/cupertino.dart';

class HalfPageImage extends StatelessWidget {
  final String tag;
  final String? imageURL;

  const HalfPageImage({Key? key, required this.tag, required this.imageURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Container(
        height: WidgetsBinding.instance!.window.physicalSize.height / 6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(imageURL ??
                'https://www.themoviedb.org/assets/2/apple-touch-icon-cfba7699efe7a742de25c28e08c38525f19381d31087c69e89d6bcb8e3c0ddfa.png'),
          ),
        ),
      ),
    );
  }
}
