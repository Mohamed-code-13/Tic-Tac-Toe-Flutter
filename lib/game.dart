import 'dart:math';

class Game {
  static int rows = 3, cols = 3;
  List<List<String>> _board = List.generate(
    rows,
    (index) => List.filled(3, ''),
  );
  String _player = 'X';
  String _winner = '';
  int _plays = 0;
  bool _gameOver = false;

  String getValue(int r, int c) {
    return _board[r][c];
  }

  void makeMove(int r, int c) {
    _board[r][c] = _player;
    if (_player == 'X') {
      _player = 'O';
    } else {
      _player = 'X';
    }
    _plays++;

    checkWinner();
  }

  void clearGame() {
    for (int r = 0; r < rows; ++r) {
      for (int c = 0; c < cols; ++c) {
        _board[r][c] = '';
      }
    }
    _player = 'X';
    _winner = '';
    _plays = 0;
    _gameOver = false;
  }

  String getPlayer() {
    return _player;
  }

  bool checkWinner() {
    if (_checkRows()) return true;

    if (_checkCols()) return true;

    if (_checkDiagonals()) return true;

    return false;
  }

  bool isGameOver() {
    return _gameOver || (_plays == 9);
  }

  String winnerMSG() {
    if (_winner != '') return "The Winner is $_winner";
    return "It's Draw.";
  }

  void autoMove() {
    List<int>? curr = _playAttack();
    if (curr != null) {
      makeMove(curr[0], curr[1]);
      return;
    }

    curr = _playDefense();
    if (curr != null) {
      makeMove(curr[0], curr[1]);
      return;
    }

    List<List<int>> importantPlaces = [
      [1, 1],
      [0, 0],
      [2, 2],
      [0, 2],
      [2, 0]
    ];
    for (List<int> i in importantPlaces) {
      if (getValue(i[0], i[1]) == '') {
        makeMove(i[0], i[1]);
        return;
      }
    }

    List<List<int>> emptyPlaces = _getEmptyPlaces();
    Random random = Random();

    int idx = random.nextInt(emptyPlaces.length);
    makeMove(emptyPlaces[idx][0], emptyPlaces[idx][1]);
  }

  bool _checkRows() {
    for (int r = 0; r < rows; ++r) {
      if (_board[r][0] == _board[r][1] &&
          _board[r][1] == _board[r][2] &&
          _board[r][0] != '') {
        _winner = _board[r][0];
        _gameOver = true;
        return true;
      }
    }
    return false;
  }

  bool _checkCols() {
    for (int c = 0; c < rows; ++c) {
      if (_board[0][c] == _board[1][c] &&
          _board[1][c] == _board[2][c] &&
          _board[0][c] != '') {
        _winner = _board[0][c];
        _gameOver = true;
        return true;
      }
    }
    return false;
  }

  bool _checkDiagonals() {
    if (_board[0][0] == _board[1][1] &&
        _board[1][1] == _board[2][2] &&
        _board[0][0] != '') {
      _winner = _board[0][0];
      _gameOver = true;
      return true;
    }

    if (_board[0][2] == _board[1][1] &&
        _board[1][1] == _board[2][0] &&
        _board[0][2] != '') {
      _winner = _board[0][2];
      _gameOver = true;
      return true;
    }

    return false;
  }

  List<List<int>> _getEmptyPlaces() {
    List<List<int>> empty = [];

    for (int r = 0; r < rows; ++r) {
      for (int c = 0; c < cols; ++c) {
        if (getValue(r, c) == '') empty.add([r, c]);
      }
    }

    return empty;
  }

  List<int>? _playAttack() {
    List<int>? curr;
    for (int r = 0; r < rows; ++r) {
      curr = _mustPlayRow(r, _player);
      if (curr != null) return curr;
    }

    for (int c = 0; c < cols; ++c) {
      curr = _mustPlayColumn(c, _player);
      if (curr != null) return curr;
    }

    curr = _mustPlayDiagonal(_player);
    if (curr != null) return curr;

    return null;
  }

  List<int>? _playDefense() {
    List<int>? curr;
    String player = (_player == 'X') ? 'O' : 'X';

    for (int r = 0; r < rows; ++r) {
      curr = _mustPlayRow(r, player);
      if (curr != null) return curr;
    }

    for (int c = 0; c < cols; ++c) {
      curr = _mustPlayColumn(c, player);
      if (curr != null) return curr;
    }

    curr = _mustPlayDiagonal(player);
    if (curr != null) return curr;

    return null;
  }

  List<int>? _mustPlayRow(int row, String player) {
    int count = 0;
    List<int> res = [row, -1];
    for (int c = 0; c < cols; ++c) {
      String val = getValue(row, c);
      if (val == player) {
        count++;
      } else if (val == '') {
        res[1] = c;
      }
    }
    if (count == 2 && res[1] != -1) return res;
    return null;
  }

  List<int>? _mustPlayColumn(int col, String player) {
    int count = 0;
    List<int> res = [-1, col];
    for (int r = 0; r < rows; ++r) {
      String val = getValue(r, col);
      if (val == player) {
        count++;
      } else if (val == '') {
        res[0] = r;
      }
    }
    if (count == 2 && res[0] != -1) return res;
    return null;
  }

  List<int>? _mustPlayDiagonal(String player) {
    int count = 0;
    List<int> res = [-1, -1];
    for (int i = 0; i < rows; ++i) {
      String val = getValue(i, i);
      if (val == player) {
        count++;
      } else if (val == '') {
        res = [i, i];
      }
    }

    if (count == 2 && res[0] != -1) return res;

    count = 0;
    res = [-1, -1];
    for (int i = 0; i < rows; ++i) {
      String val = getValue(i, rows - i - 1);
      if (val == player) {
        count++;
      } else if (val == '') {
        res = [i, rows - i - 1];
      }
    }

    if (count == 2 && res[0] != -1) return res;

    return null;
  }
}
