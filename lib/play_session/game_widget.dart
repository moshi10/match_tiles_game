// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:basic/play_session/board_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_internals/level_state.dart';
import '../level_selection/levels.dart';

/// This widget defines the game UI itself, without things like the settings
/// button or the back button.
class GameWidget extends StatelessWidget {
  const GameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final level = context.watch<GameLevel>();
    final levelState = context.watch<LevelState>();
    final boardState = context.watch<BoardState>();
    List<GameCell> visibleCellList = boardState.cellList
        .where((cell) => cell.cellType != GameCellType.wall)
        .toList();
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (boardState.cols + 2),
      ),
      itemCount: (boardState.rows + 2) * (boardState.cols + 2),
      itemBuilder: (context, index) {
        int row = index ~/ (boardState.cols + 2);
        int col = index % (boardState.cols + 2);
        return GestureDetector(
          onTap: () {},
          child: GridTile(
            child: Container(
              alignment: Alignment.center,
              decoration: visibleCellList[index].toString() == 'E'
                  ? null
                  : BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: row == 0 ||
                              row == (boardState.rows + 1) ||
                              col == 0 ||
                              col == (boardState.cols + 1)
                          ? null
                          : Colors.white),
              child: Text(
                visibleCellList[index].toString() == 'E'
                    ? ''
                    : visibleCellList[index].toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
