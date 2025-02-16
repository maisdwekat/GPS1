import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'data.dart';


class LineAreaPointPage extends StatelessWidget {
  LineAreaPointPage({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Line and Area Mark'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 350,
                height: 300,
                child: Chart(
                  data: complexGroupData,
                  variables: {
                    'date': Variable(
                      accessor: (Map map) => map['date'] as String,
                      scale: OrdinalScale(tickCount: 5, inflate: false),
                    ),
                    'points': Variable(
                      accessor: (Map map) => map['numberOfVisits'] as num,
                    ),
                    'visits': Variable(
                      accessor: (Map map) => map['numberOfInvestors'] as num,
                    ),
                    'numberOfRequstInvesment': Variable(
                      accessor: (Map map) => map['numberOfRequstInvesment'] as num,
                    ),
                    'name': Variable(
                      accessor: (Map map) => map['name'] as String,
                    ),


                  },
                  coord: RectCoord(horizontalRange: [0.01, 0.99]),
                  marks: [
                    LineMark(
                      position:
                      Varset('date') * Varset('visits') / Varset('name'),
                      shape: ShapeEncode(value: BasicLineShape(smooth: true)),
                      size: SizeEncode(value: 0.9),
                      color: ColorEncode(
                        variable: 'name',
                        values: Defaults.colors10,
                        updaters: {
                          'groupMouse': {
                            false: (color) => color.withAlpha(100)
                          },
                          'groupTouch': {
                            false: (color) => color.withAlpha(100)
                          },
                        },
                      ),
                    ),
                    PointMark(
                      color: ColorEncode(
                        variable: 'name',
                        values: Defaults.colors10,
                        updaters: {
                          'groupMouse': {
                            false: (color) => color.withAlpha(100)
                          },
                          'groupTouch': {
                            false: (color) => color.withAlpha(100)
                          },
                        },
                      ),
                    ),
                  ],
                  axes: [
                    Defaults.horizontalAxis,
                    Defaults.verticalAxis,
                  ],
                  selections: {
                    'tooltipMouse': PointSelection(on: {
                      GestureType.hover,
                    }, devices: {
                      PointerDeviceKind.mouse
                    }),
                    'groupMouse': PointSelection(
                        on: {
                          GestureType.hover,
                        },
                        variable: 'name',
                        devices: {PointerDeviceKind.mouse}),
                    'tooltipTouch': PointSelection(on: {
                      GestureType.scaleUpdate,
                      GestureType.tapDown,
                      GestureType.longPressMoveUpdate
                    }, devices: {
                      PointerDeviceKind.touch
                    }),
                    'groupTouch': PointSelection(
                        on: {
                          GestureType.scaleUpdate,
                          GestureType.tapDown,
                          GestureType.longPressMoveUpdate
                        },
                        variable: 'name',
                        devices: {PointerDeviceKind.touch}),
                  },
                  tooltip: TooltipGuide(
                    selections: {'tooltipTouch', 'tooltipMouse'},
                    followPointer: [true, true],
                    align: Alignment.topLeft,
                    mark: 0,
                    variables: [
                      'date',
                      'name',
                      'points',
                    ],
                  ),
                  crosshair: CrosshairGuide(
                    selections: {'tooltipTouch', 'tooltipMouse'},
                    styles: [
                      PaintStyle(strokeColor: const Color(0xffbfbfbf)),
                      PaintStyle(strokeColor: const Color(0x00bfbfbf)),
                    ],
                    followPointer: [true, false],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 5),
                child: const Text(
                  'River chart',
                  style: TextStyle(fontSize: 20),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}