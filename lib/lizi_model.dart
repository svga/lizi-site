import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:lizi/lizi.dart';

class LiziModel {
  final List<Emitter> emitters = [];

  static LiziModel blankModel() {
    final model = LiziModel();
    model.emitters.add(blankEmitter());
    return model;
  }

  static Emitter blankEmitter() {
    final emitter = Emitter();
    emitter.birthRate = 4;
    emitter.emitterPosition = Offset(375.0 / 2.0, 568.0 / 2.0);
    final cell = Cell.circle(
      radius: 10,
      paint: Paint()
        ..shader = RadialGradient(
          colors: [
            Color(0xffffffff),
            Color(0x00ffffff),
          ],
        ).createShader(Rect.fromCircle(center: Offset(10, 10), radius: 10)),
    );
    cell.birthRate = 5;
    cell.lifttime = 10;
    cell.lifttimeRange = 0.5;
    cell.velocity = 80;
    cell.velocityRange = 80;
    cell.alphaSpeed = -0.5;
    cell.alphaRange = 0.5;
    cell.acceleration = Offset(0.0, -20.0);
    cell.scale = 0.2;
    cell.scaleSpeed = 0.6;
    cell.scaleRange = 2.0;
    cell.emissionLongitude = pi * 1.5;
    cell.emissionRange = pi * 1.0;
    cell.spin = pi * 3;
    cell.spinRange = pi;
    emitter.cells.add(cell);
    return emitter;
  }

  static Cell copyCell(Cell cell) {
    final copiedCell = Cell(Random().nextDouble().toString());
    copiedCell.birthRate = cell.birthRate;
    copiedCell.contents = cell.contents;
    copiedCell.lifttime = cell.lifttime;
    copiedCell.lifttimeRange = cell.lifttimeRange;
    copiedCell.velocity = cell.velocity;
    copiedCell.velocityRange = cell.velocityRange;
    copiedCell.alphaSpeed = cell.alphaSpeed;
    copiedCell.alphaRange = cell.alphaRange;
    copiedCell.acceleration = cell.acceleration;
    copiedCell.scale = cell.scale;
    copiedCell.scaleSpeed = cell.scaleSpeed;
    copiedCell.scaleRange = cell.scaleRange;
    copiedCell.emissionLongitude = cell.emissionLongitude;
    copiedCell.emissionRange = cell.emissionRange;
    copiedCell.spin = cell.spin;
    copiedCell.spinRange = cell.spinRange;
    return copiedCell;
  }
}
