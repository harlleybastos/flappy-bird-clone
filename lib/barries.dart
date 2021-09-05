import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final barrierX;
  final barrierWidth;
  final barrierHeight;
  final size;
  final bool isThisBottomBarrier;
  const MyBarrier(
      {Key? key,
      this.size,
      this.barrierX,
      this.barrierWidth,
      this.barrierHeight,
      required this.isThisBottomBarrier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * barrierX + barrierWidth) / (2 - barrierWidth),
          isThisBottomBarrier ? 1 : -1),
      height: size,
      child: Container(
        color: Colors.green,
        width: MediaQuery.of(context).size.width * barrierWidth / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * barrierHeight / 2,
      ),
    );
  }
}
