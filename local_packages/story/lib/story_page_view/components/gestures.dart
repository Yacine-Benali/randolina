import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story/story_page_view/story_page_view.dart';

import '../story_stack_controller.dart';

class Gestures extends StatelessWidget {
  const Gestures({
    Key? key,
    required this.animationController,
    required this.indicatorAnimationController,
  }) : super(key: key);

  final AnimationController? animationController;
  final ValueNotifier<IndicatorAnimationCommand> indicatorAnimationController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                animationController!.forward(from: 0);
                context.read<StoryStackController>().decrement();
              },
              onLongPress: () {
                indicatorAnimationController.value =
                    IndicatorAnimationCommand.pause;
                animationController!.stop();
              },
              onLongPressUp: () {
                indicatorAnimationController.value =
                    IndicatorAnimationCommand.resume;
                animationController!.forward();
              },
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                context.read<StoryStackController>().increment(
                      restartAnimation: () =>
                          animationController!.forward(from: 0),
                      completeAnimation: () => animationController!.value = 1,
                    );
              },
              onLongPress: () {
                indicatorAnimationController.value =
                    IndicatorAnimationCommand.pause;
                animationController!.stop();
              },
              onLongPressUp: () {
                indicatorAnimationController.value =
                    IndicatorAnimationCommand.resume;
                animationController!.forward();
              },
            ),
          ),
        ),
      ],
    );
  }
}
