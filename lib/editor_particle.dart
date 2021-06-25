part of './editor.dart';

class _EditorParticleInspector extends StatefulWidget {
  final Cell activeCell;
  final Function onCopy;
  final Function onDelete;

  _EditorParticleInspector({
    required this.activeCell,
    required this.onCopy,
    required this.onDelete,
  });

  @override
  __EditorParticleInspectorState createState() =>
      __EditorParticleInspectorState();
}

class __EditorParticleInspectorState extends State<_EditorParticleInspector> {
  @override
  Widget build(BuildContext context) {
    return GridView(
      children: [
        _renderBirthRate(),
        _renderLifeTime(),
        _renderLifeTimeRange(),
        _renderVelocity(),
        _renderVelocityRange(),
        Container(),
        _renderAccelerationX(),
        _renderAccelerationY(),
        Container(),
        _renderAlphaSpeed(),
        _renderAlphaRange(),
        Container(),
        _renderScale(),
        _renderScaleSpeed(),
        _renderScaleRange(),
        _renderEmissionLongitude(),
        _renderEmissionLongitudeRange(),
        Container(),
        _renderSpin(),
        _renderSpinRange(),
        Container(),
        _renderCellContent(),
        _renderCopy(),
        _renderRemove(),
      ],
      padding: EdgeInsets.only(left: 10, right: 10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        childAspectRatio: 2.0,
      ),
    );
  }

  Widget _renderCellContent() {
    return Align(
      alignment: Alignment(0.0, -0.5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: MaterialButton(
          onPressed: () async {
            final nextContent = await showDialog(
              context: context,
              builder: (context) {
                return _EditorContent(cell: widget.activeCell);
              },
            );
            if (nextContent is ui.Image) {
              widget.activeCell.contents = nextContent;
            }
          },
          height: 44,
          minWidth: 220,
          child: Text('修改粒子纹理'),
        ),
      ),
    );
  }

  Widget _renderCopy() {
    return Align(
      alignment: Alignment(0.0, -0.5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: MaterialButton(
          onPressed: () {
            widget.onCopy();
          },
          height: 44,
          minWidth: 220,
          child: Text('拷贝粒子'),
        ),
      ),
    );
  }

  Widget _renderRemove() {
    return Align(
      alignment: Alignment(0.0, -0.5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
        child: MaterialButton(
          onPressed: () async {
            final result = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text('要删除该粒子吗？'),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('确认', style: TextStyle(color: Colors.red)),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text('取消'),
                    )
                  ],
                );
              },
            );
            if (result == true) {
              widget.onDelete();
            }
          },
          height: 44,
          minWidth: 220,
          child: Text(
            '删除粒子',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Column _renderBirthRate() {
    return Column(
      children: [
        Container(
          height: 32,
          alignment: Alignment.bottomLeft,
          child: Text(
            'BirthRate - 粒子生成速率',
            style: TextStyle(
              fontSize: 11,
              color: Color.fromARGB(255, 34, 34, 34),
            ),
            maxLines: 1,
          ),
        ),
        TextField(
          controller: TextEditingController(
            text: widget.activeCell.birthRate.toString(),
          ),
          onSubmitted: (value) {
            setState(() {
              widget.activeCell.birthRate = double.tryParse(value) ?? 0.0;
            });
          },
        ),
      ],
    );
  }

  Column _renderLifeTime() {
    return Column(
      children: [
        Container(
          height: 32,
          alignment: Alignment.bottomLeft,
          child: Text(
            'LifeTime - 存活时间',
            style: TextStyle(
              fontSize: 11,
              color: Color.fromARGB(255, 34, 34, 34),
            ),
            maxLines: 1,
          ),
        ),
        TextField(
          controller: TextEditingController(
            text: widget.activeCell.lifttime.toString(),
          ),
          onSubmitted: (value) {
            setState(() {
              widget.activeCell.lifttime = double.tryParse(value) ?? 0.0;
            });
          },
        ),
      ],
    );
  }

  Column _renderLifeTimeRange() {
    return Column(
      children: [
        Container(
          height: 32,
          alignment: Alignment.bottomLeft,
          child: Text(
            'LifeTime Range - 存活时间变化范围',
            style: TextStyle(
              fontSize: 11,
              color: Color.fromARGB(255, 34, 34, 34),
            ),
            maxLines: 1,
          ),
        ),
        TextField(
          controller: TextEditingController(
            text: widget.activeCell.lifttimeRange.toString(),
          ),
          onSubmitted: (value) {
            setState(() {
              widget.activeCell.lifttimeRange = double.tryParse(value) ?? 0.0;
            });
          },
        ),
      ],
    );
  }

  Column _renderVelocity() {
    return Column(
      children: [
        Container(
          height: 32,
          alignment: Alignment.bottomLeft,
          child: Text(
            'Velocity - 初始速度',
            style: TextStyle(
              fontSize: 11,
              color: Color.fromARGB(255, 34, 34, 34),
            ),
            maxLines: 1,
          ),
        ),
        TextField(
          controller: TextEditingController(
            text: widget.activeCell.velocity.toString(),
          ),
          onSubmitted: (value) {
            setState(() {
              widget.activeCell.velocity = double.tryParse(value) ?? 0.0;
            });
          },
        ),
      ],
    );
  }

  Column _renderVelocityRange() {
    return Column(
      children: [
        Container(
          height: 32,
          alignment: Alignment.bottomLeft,
          child: Text(
            'Velocity Range - 初始速度变化范围',
            style: TextStyle(
              fontSize: 11,
              color: Color.fromARGB(255, 34, 34, 34),
            ),
            maxLines: 1,
          ),
        ),
        TextField(
          controller: TextEditingController(
            text: widget.activeCell.velocityRange.toString(),
          ),
          onSubmitted: (value) {
            setState(() {
              widget.activeCell.velocityRange = double.tryParse(value) ?? 0.0;
            });
          },
        ),
      ],
    );
  }

  Column _renderAccelerationX() {
    return Column(
      children: [
        Container(
          height: 32,
          alignment: Alignment.bottomLeft,
          child: Text(
            'Acceleration, X - 加速度 X 轴',
            style: TextStyle(
              fontSize: 11,
              color: Color.fromARGB(255, 34, 34, 34),
            ),
            maxLines: 1,
          ),
        ),
        TextField(
          controller: TextEditingController(
            text: widget.activeCell.acceleration.dx.toString(),
          ),
          onSubmitted: (value) {
            setState(() {
              widget.activeCell.acceleration = Offset(
                  double.tryParse(value) ?? 0.0,
                  widget.activeCell.acceleration.dy);
            });
          },
        ),
      ],
    );
  }

  Column _renderAccelerationY() {
    return Column(
      children: [
        Container(
          height: 32,
          alignment: Alignment.bottomLeft,
          child: Text(
            'Acceleration, Y - 加速度 Y 轴',
            style: TextStyle(
              fontSize: 11,
              color: Color.fromARGB(255, 34, 34, 34),
            ),
            maxLines: 1,
          ),
        ),
        TextField(
          controller: TextEditingController(
            text: widget.activeCell.acceleration.dy.toString(),
          ),
          onSubmitted: (value) {
            setState(() {
              widget.activeCell.acceleration = Offset(
                widget.activeCell.acceleration.dx,
                double.tryParse(value) ?? 0.0,
              );
            });
          },
        ),
      ],
    );
  }

  Column _renderAlphaSpeed() {
    return Column(
      children: [
        Container(
          height: 32,
          alignment: Alignment.bottomLeft,
          child: Text(
            'Alpha Speed - 不透明度变化速度',
            style: TextStyle(
              fontSize: 11,
              color: Color.fromARGB(255, 34, 34, 34),
            ),
            maxLines: 1,
          ),
        ),
        TextField(
          controller: TextEditingController(
            text: widget.activeCell.alphaSpeed.toString(),
          ),
          onSubmitted: (value) {
            setState(() {
              widget.activeCell.alphaSpeed = double.tryParse(value) ?? 0.0;
            });
          },
        ),
      ],
    );
  }

  Column _renderAlphaRange() {
    return Column(
      children: [
        Container(
          height: 32,
          alignment: Alignment.bottomLeft,
          child: Text(
            'Alpha Range - 不透明度变化范围',
            style: TextStyle(
              fontSize: 11,
              color: Color.fromARGB(255, 34, 34, 34),
            ),
            maxLines: 1,
          ),
        ),
        TextField(
          controller: TextEditingController(
            text: widget.activeCell.alphaRange.toString(),
          ),
          onSubmitted: (value) {
            setState(() {
              widget.activeCell.alphaRange = double.tryParse(value) ?? 0.0;
            });
          },
        ),
      ],
    );
  }

  Column _renderScale() {
    return Column(
      children: [
        Container(
          height: 32,
          alignment: Alignment.bottomLeft,
          child: Text(
            'Scale - 初始缩放',
            style: TextStyle(
              fontSize: 11,
              color: Color.fromARGB(255, 34, 34, 34),
            ),
            maxLines: 1,
          ),
        ),
        TextField(
          controller: TextEditingController(
            text: widget.activeCell.scale.toString(),
          ),
          onSubmitted: (value) {
            setState(() {
              widget.activeCell.scale = double.tryParse(value) ?? 0.0;
            });
          },
        ),
      ],
    );
  }

  Column _renderScaleSpeed() {
    return Column(
      children: [
        Container(
          height: 32,
          alignment: Alignment.bottomLeft,
          child: Text(
            'Scale Speed - 缩放增长速度',
            style: TextStyle(
              fontSize: 11,
              color: Color.fromARGB(255, 34, 34, 34),
            ),
            maxLines: 1,
          ),
        ),
        TextField(
          controller: TextEditingController(
            text: widget.activeCell.scaleSpeed.toString(),
          ),
          onSubmitted: (value) {
            setState(() {
              widget.activeCell.scaleSpeed = double.tryParse(value) ?? 0.0;
            });
          },
        ),
      ],
    );
  }

  Column _renderScaleRange() {
    return Column(
      children: [
        Container(
          height: 32,
          alignment: Alignment.bottomLeft,
          child: Text(
            'Scale Range - 缩放变化范围',
            style: TextStyle(
              fontSize: 11,
              color: Color.fromARGB(255, 34, 34, 34),
            ),
            maxLines: 1,
          ),
        ),
        TextField(
          controller: TextEditingController(
            text: widget.activeCell.scaleRange.toString(),
          ),
          onSubmitted: (value) {
            setState(() {
              widget.activeCell.scaleRange = double.tryParse(value) ?? 0.0;
            });
          },
        ),
      ],
    );
  }

  Column _renderEmissionLongitude() {
    return Column(
      children: [
        Container(
          height: 32,
          alignment: Alignment.bottomLeft,
          child: Text(
            'Emission Longitude - 发射角(度)',
            style: TextStyle(
              fontSize: 11,
              color: Color.fromARGB(255, 34, 34, 34),
            ),
            maxLines: 1,
          ),
        ),
        TextField(
          controller: TextEditingController(
            text: (widget.activeCell.emissionLongitude * 180.0 / pi).toString(),
          ),
          onSubmitted: (value) {
            setState(() {
              widget.activeCell.emissionLongitude =
                  (double.tryParse(value) ?? 0.0) * pi / 180.0;
            });
          },
        ),
      ],
    );
  }

  Column _renderEmissionLongitudeRange() {
    return Column(
      children: [
        Container(
          height: 32,
          alignment: Alignment.bottomLeft,
          child: Text(
            'Emission Range - 发射角变化范围',
            style: TextStyle(
              fontSize: 11,
              color: Color.fromARGB(255, 34, 34, 34),
            ),
            maxLines: 1,
          ),
        ),
        TextField(
          controller: TextEditingController(
            text: (widget.activeCell.emissionRange * 180.0 / pi).toString(),
          ),
          onSubmitted: (value) {
            setState(() {
              widget.activeCell.emissionRange =
                  (double.tryParse(value) ?? 0.0) * pi / 180.0;
            });
          },
        ),
      ],
    );
  }

  Column _renderSpin() {
    return Column(
      children: [
        Container(
          height: 32,
          alignment: Alignment.bottomLeft,
          child: Text(
            'Spin - 旋转速度(度)',
            style: TextStyle(
              fontSize: 11,
              color: Color.fromARGB(255, 34, 34, 34),
            ),
            maxLines: 1,
          ),
        ),
        TextField(
          controller: TextEditingController(
            text: (widget.activeCell.spin * 180.0 / pi).toString(),
          ),
          onSubmitted: (value) {
            setState(() {
              widget.activeCell.spin =
                  (double.tryParse(value) ?? 0.0) * pi / 180.0;
            });
          },
        ),
      ],
    );
  }

  Column _renderSpinRange() {
    return Column(
      children: [
        Container(
          height: 32,
          alignment: Alignment.bottomLeft,
          child: Text(
            'Spin Range - 旋转速度变化范围',
            style: TextStyle(
              fontSize: 11,
              color: Color.fromARGB(255, 34, 34, 34),
            ),
            maxLines: 1,
          ),
        ),
        TextField(
          controller: TextEditingController(
            text: (widget.activeCell.spinRange * 180.0 / pi).toString(),
          ),
          onSubmitted: (value) {
            setState(() {
              widget.activeCell.spinRange =
                  (double.tryParse(value) ?? 0.0) * pi / 180.0;
            });
          },
        ),
      ],
    );
  }
}
