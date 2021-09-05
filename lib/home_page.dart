import 'dart:async';

import 'package:flappy_bird_clone/barries.dart';
import 'package:flappy_bird_clone/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -4.9; // how strong the gravity is
  double velocity = 3.5; // how strong the jump is
  bool gameHasStarted = false;
  double birdWidth = 0.1;
  double birdHeight = 0.1;
  int score = 0;
  int bestScore = 0;

  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      height = gravity * time * time + velocity * time;
      setState(() {
        birdY = initialPos - height;
      });

      if (birdIsDead()) {
        timer.cancel();
        _showDialog();
      }
      moveMap();
      time += 0.01;
    });
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
    });
  }

  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        barrierX[i] -= 0.005;
      });

      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
        score += 1;
      }
    }
  }

  void resetGame() {
    if (score >= bestScore) bestScore = score;
    Navigator.pop(context);
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = birdY;
      height = 0;
      time = 0;
      gravity = -4.9;
      velocity = 3.5;
      gameHasStarted = false;
      birdWidth = 0.1;
      birdHeight = 0.1;
      barrierX = [2, 2 + 1.5];
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            title: Center(
              child: Text(
                "G A M E O V E R",
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: Colors.white,
                    child: Text(
                      "PLAY AGAIN",
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  bool birdIsDead() {
    if (birdY < -1 || birdY > 1) {
      return true;
    }
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i][0] ||
              birdY + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : startGame,
      child: Scaffold(
          body: Column(children: [
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.blue,
            child: Center(
              child: Stack(children: [
                MyBird(
                  birdY: birdY,
                  birdHeight: birdHeight,
                  birdWidth: birdWidth,
                ),
                Container(
                  alignment: Alignment(0, -0.5),
                  child: Text(
                    gameHasStarted ? "" : "T A P  T O  S T A R T",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                MyBarrier(
                  barrierX: barrierX[0],
                  barrierWidth: barrierWidth,
                  barrierHeight: barrierHeight[0][0],
                  isThisBottomBarrier: false,
                ),
                MyBarrier(
                  barrierX: barrierX[0],
                  barrierWidth: barrierWidth,
                  barrierHeight: barrierHeight[0][1],
                  isThisBottomBarrier: true,
                ),
                MyBarrier(
                  barrierX: barrierX[1],
                  barrierWidth: barrierWidth,
                  barrierHeight: barrierHeight[1][0],
                  isThisBottomBarrier: false,
                ),
                MyBarrier(
                  barrierX: barrierX[1],
                  barrierWidth: barrierWidth,
                  barrierHeight: barrierHeight[1][1],
                  isThisBottomBarrier: true,
                ),
              ]),
            ),
          ),
        ),
        Container(
          height: 15,
          color: Colors.green,
        ),
        Expanded(
          child: Container(
              color: Colors.brown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Text(
                              'BEST SCORE:',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              bestScore.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            ),
                          ),
                        ]),
                  ),
                ],
              )),
        ),
      ])),
    );
  }
}
