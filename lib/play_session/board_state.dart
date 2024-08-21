// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:flutter/foundation.dart';

enum GameCellType { wall, empty, tile }

class GameCell {
  final GameCellType cellType;

  GameCell({required this.cellType});

  @override
  String toString() {
    switch (cellType) {
      case GameCellType.wall:
        return 'W';
      case GameCellType.empty:
        return 'E';
      case GameCellType.tile:
        return 'T';
    }
  }
}

// 継承
class GameTile extends GameCell {
  final int value;

  GameTile({required this.value}) : super(cellType: GameCellType.tile);

  @override
  String toString() {
    return value.toString();
  }
}

class BoardState extends ChangeNotifier {
  static int pickRandomElement(List<int> array) {
    return array.removeAt((array.length * Random().nextDouble()).toInt());
  }

  static int move(List<GameCell> board, int tenP, int kyoriD) {
    return board[tenP + kyoriD].cellType == GameCellType.empty
        ? tenP
        : move(board, tenP + kyoriD, kyoriD);
  }

  late final List<GameCell> cellList;
  int remainingTiles;

  // tileのみ
  final int rows;
  final int cols;

  // wallとemptyとtile
  final int _width;
  final int _height;

  BoardState({required this.rows, required this.cols,required this.remainingTiles})
      : _width = cols + 4,
        _height = rows + 4 {
    List<int> tileValues =
        List.generate(rows * cols, (index) => 1 + (index ~/ 4));
    List<GameCell> tmpCellList = List.generate((_width) * (_height), (index) {
      int minDistance = [
        getX(index),
        getY(index),
        _width - 1 - getX(index),
        _height - 1 - getY(index)
      ].reduce(min);
      if (minDistance == 0) {
        return GameCell(cellType: GameCellType.wall);
      } else if (minDistance == 1) {
        return GameCell(cellType: GameCellType.empty);
      } else {
        return GameTile(value: pickRandomElement(tileValues));
      }
    });

    cellList = tmpCellList;
  }

  // 位置からx座標を取得
  int getX(int position) {
    return position % _width;
  }

  // 位置からy座標を取得
  int getY(int position) {
    return position ~/ _width;
  }

  // XY座標を配列のインデックスに変換
  int fromXY(int x, int y) {
    return x + y * _width;
  }

  int fromYX(int y, int x) {
    return fromXY(x, y);
  }

  bool isPassable(List<GameCell> board, int i0, int i1, int Function(int) getU,
      int Function(int) getV, int Function(int, int) getIndexFromCoordinates) {
    int kyoriD = getIndexFromCoordinates(1, 0);
    int maxU =
        max(getU(move(board, i0, -kyoriD)), getU(move(board, i1, -kyoriD)));
    int minU =
        min(getU(move(board, i0, kyoriD)), getU(move(board, i1, kyoriD)));
    int minV = min(getV(i0), getV(i1)) + 1;
    int maxV = max(getV(i0), getV(i1)) - 1;
    List<int> uRange = List.generate(
        max(0, (minU + 1 - maxU).ceil()), (index) => maxU + index);
    List<int> vRange = List.generate(
        max(0, (maxV + 1 - minV).ceil()), (index) => minV + index);
    return uRange.any((u) => vRange.every((v) =>
        board[getIndexFromCoordinates(u, v)].cellType == GameCellType.empty));
  }

  bool areTilesMatchable(List<GameCell> board, int p0, int p1) {
    return p0 != p1 &&
        board[p0].toString() == board[p1].toString() &&
        (isPassable(board, p0, p1, getX, getY, fromXY) ||
            isPassable(board, p0, p1, getY, getX, fromYX));
  }

  int updateState(List<GameCell> tmpCellList,int remainingTiles, int position) {
    List<int?> pair = [null, null];

    // 壁か空白なら何もしない
    if (tmpCellList[position].cellType != GameCellType.tile) {
      return remainingTiles;
    }

    // タップされたタイルの位置を取得
    if (pair[0] == null) {
      pair[0] = position;
    } else if (pair[1] == null) {
      pair[1] = position;
    } else {
      pair[0] = null;
      pair[1] = null;
    }

    // 間違ってたら戻す
    if (pair[0] != null && pair[1] != null) {
      if (!areTilesMatchable(tmpCellList, pair[0]!, pair[1]!)) {
        return remainingTiles;
      }
    }

    //  タイルが一致しているか判定
    if (pair[0] != null && pair[1] != null) {
      if (areTilesMatchable(cellList, pair[0]!, pair[1]!)) {
        // 一致していたらタイルを消して、残りのタイル数を減らす
        return state
          ..cellList = cellList
              .asMap()
              .map((index, value) => MapEntry(
                  index,
                  index == pair[0]! || index == pair[1]!
                      ? GameCell(cellType: GameCellType.empty)
                      : value))
              .values
              .toList()
          ..remainingTiles = state.remainingTiles - 2;
      }
    }
    return state;
  }

  List<int>? findMatchingPair(List<GameCell> board) {
    Map<int, List<int>> pairs = {};
    for (var MapEntry(key: key, value: value) in board.entries) {
  print('key:$key value:$value');
}
    return null;
    // for (int position = 0; position < board.length; position++) {
    //   if (board[position].cellType != GameCellType.tile) {
    //     continue;
    //   }
    //   if ()
      // if (pairs[board[position].toString()] == null) {
      //   pairs[board[position].toString()] = [position];
      //   continue;
      // }
      // for (int otherPosition in pairs[board[position].toString()]!) {
      //   if (areTilesMatchable(board, position, otherPosition)) {
      //     return [position, otherPosition];
      //   }
      // }
      // pairs[board[position].toString()]!.add(position);
    }
    return null;
  }

  bool isBoardSolved(BoardState state) {
    while(state.remainingTiles) {

    }
  }
//   const solveBoard = (state: BoardState): boolean => {
//     // 残り牌があるとき
//     while (state.remainingTiles) {
//         // マッチしてないやつ
//         const pair = findMatchingPair(state.board);
//         // マッチするやつがないとき
//         if (!pair) return false;
//         // マッチするやつがあるとき、全部消す
//         state = updateState(state, pair[0]);
//         state = updateState(state, pair[1]);
//     }
//     return true;
// };

// const findMatchingPair = (board: number[]): [number, number] | undefined => {
//     //
//     const pairs: { [key: number]: number[] } = {};
//     // オブジェクトをぐるぐるする
//     for (const [position, value] of board.entries()) {
//         // 空白か壁なら何もしない
//         if (value <= 0) continue;
//         // まだないなら追加
//         if (!pairs[value]) {
//             pairs[value] = [position];
//             continue;
//         }
//         // あったら
//         for (const otherPosition of pairs[value]) {
//             // 一致するか判定
//             if (areTilesMatchable(board, position, otherPosition)) {
//                 return [position, otherPosition];
//             }
//         }
//         // なかったらpairsに追加
//         pairs[value].push(position);
//     }
// };
}
