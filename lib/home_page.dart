import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'game.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _twoPlayersMode = false;
  String result = "";
  Game game = Game();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text("Tic Tac Toe"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: (MediaQuery.of(context).orientation == Orientation.portrait)
            ? _portraitMode(context)
            : _landscapeMode(context),
      ),
    );
  }

  Column _portraitMode(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(height: 15),
        SwitchMode(),
        const SizedBox(height: 15),
        Text(
          "${game.getPlayer()}'s Turn",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 38),
        ),
        const SizedBox(height: 15),
        _buildGrid(),
        const SizedBox(height: 15),
        Text(
          result,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 38),
        ),
        const SizedBox(height: 15),
        RepeatButton(context),
        const SizedBox(height: 15),
      ],
    );
  }

  Row _landscapeMode(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SwitchMode(),
            Text(
              "${game.getPlayer()}'s Turn",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 38),
            ),
            Text(
              result,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 38),
            ),
            RepeatButton(context),
          ],
        ),
        _buildGrid(),
      ],
    );
  }

  Widget _buildGrid() {
    int rows = 3, cols = 3;

    return Expanded(
      child: GridView.count(
        crossAxisCount: cols,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 1.0,
        children: List.generate(
          rows * cols,
          (index) => _buildItems(context, index),
        ),
      ),
    );
  }

  Widget _buildItems(BuildContext context, int index) {
    int width = 3;
    int row = (index / width).floor(), col = index % width;
    String val = game.getValue(row, col);

    return GestureDetector(
      onTap: () {
        if (game.getValue(row, col) != '' || game.isGameOver()) return;

        setState(() {
          game.makeMove(row, col);

          if (game.isGameOver()) {
            result = game.winnerMSG();

            _CustomToast("Game Over.", 22);
          } else if (!_twoPlayersMode) {
            game.autoMove();
            if (game.isGameOver()) {
              result = game.winnerMSG();

              _CustomToast("Game Over.", 22);
            }
          }
        });
      },
      child: GridTile(
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).shadowColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: (val != '') ? 1.0 : 0.0,
            child: Center(
                child: Text(
              val,
              style: TextStyle(
                  color: (val == 'X')
                      ? Theme.of(context).splashColor
                      : Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 55),
            )),
          ),
        ),
      ),
    );
  }

  FlutterSwitch SwitchMode() {
    return FlutterSwitch(
      activeText: "Two Players Mode",
      inactiveText: "Computer Mode",
      valueFontSize: 26.0,
      width: 300,
      height: 60,
      borderRadius: 26,
      showOnOff: true,
      value: _twoPlayersMode,
      onToggle: (val) => setState(() {
        _twoPlayersMode = val;
      }),
    );
  }

  Widget RepeatButton(BuildContext ctx) {
    return ElevatedButton.icon(
      onPressed: () {
        _CustomToast("Starting new game.", 20);
        setState(() {
          game.clearGame();
          result = '';
        });
      },
      icon: const Icon(Icons.replay),
      label: const Text("Repeat the game"),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Theme.of(ctx).splashColor),
      ),
    );
  }

  ToastFuture _CustomToast(String title, double size) {
    return showToast(
      title,
      textStyle: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.center,
      animDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 2),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
    ;
  }
}
