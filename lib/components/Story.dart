import 'package:flutter/material.dart';
import "package:story_view/story_view.dart";

class StoryBoard extends StatefulWidget {
  final String image;
  const StoryBoard({super.key, required this.image});

  @override
  State<StoryBoard> createState() => _StoryBoardState();
}

class _StoryBoardState extends State<StoryBoard> {
  final controller = StoryController();

  @override
  Widget build(BuildContext context) {
    List<StoryItem> storyItems = [
      StoryItem.pageImage(controller: controller, url: widget.image),
      // StoryItem.pageVideo(controller: controller)
    ]; // your list of stories

    return StoryView(
        storyItems: storyItems,
        controller: controller, // pass controller here too
        repeat: true, // should the stories be slid forever
        onStoryShow: (s) {},
        onComplete: () {},
        onVerticalSwipeComplete: (direction) {
          if (direction == Direction.down) {
            Navigator.pop(context);
          }
        } // To disable vertical swipe gestures, ignore this parameter.
        // Preferrably for inline story view.
        );
  }
}
