part of './editor.dart';

class _EditorEmitterInspector extends StatefulWidget {
  final LafItem model;
  final Emitter activeEmitter;
  final Function onDelete;

  _EditorEmitterInspector({
    required this.model,
    required this.activeEmitter,
    required this.onDelete,
  });

  @override
  __EditorEmitterInspectorState createState() =>
      __EditorEmitterInspectorState();
}

class __EditorEmitterInspectorState extends State<_EditorEmitterInspector> {
  @override
  Widget build(BuildContext context) {
    return GridView(
      children: [
        _renderPositionX(),
        _renderPositionY(),
        Container(),
        _renderSizeW(),
        _renderSizeH(),
        Container(),
        _renderShape(),
        _renderMode(),
        Container(),
        _renderBirthRate(),
        Container(),
        Container(),
        Container(),
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

  Column _renderPositionX() {
    return Column(
      children: [
        Container(
          height: 32,
          alignment: Alignment.bottomLeft,
          child: Text(
            'Position X - 位置 X',
            style: TextStyle(
              fontSize: 11,
              color: Color.fromARGB(255, 34, 34, 34),
            ),
            maxLines: 1,
          ),
        ),
        TextField(
          controller: TextEditingController(
            text: widget.activeEmitter.emitterPosition.dx.toString(),
          ),
          onSubmitted: (value) {
            setState(() {
              widget.activeEmitter.emitterPosition = Offset(
                double.tryParse(value) ?? 0.0,
                widget.activeEmitter.emitterPosition.dy,
              );
            });
          },
        ),
      ],
    );
  }

  Column _renderSizeW() {
    return Column(
      children: [
        Container(
          height: 32,
          alignment: Alignment.bottomLeft,
          child: Text(
            'Size Width - 发射区域（宽）',
            style: TextStyle(
              fontSize: 11,
              color: Color.fromARGB(255, 34, 34, 34),
            ),
            maxLines: 1,
          ),
        ),
        TextField(
          controller: TextEditingController(
            text: widget.activeEmitter.emitterSize.width.toString(),
          ),
          onSubmitted: (value) {
            setState(() {
              widget.activeEmitter.emitterSize = Size(
                double.tryParse(value) ?? 0.0,
                widget.activeEmitter.emitterSize.height,
              );
            });
          },
        ),
      ],
    );
  }

  Column _renderSizeH() {
    return Column(
      children: [
        Container(
          height: 32,
          alignment: Alignment.bottomLeft,
          child: Text(
            'Size Height - 发射区域（高）',
            style: TextStyle(
              fontSize: 11,
              color: Color.fromARGB(255, 34, 34, 34),
            ),
            maxLines: 1,
          ),
        ),
        TextField(
          controller: TextEditingController(
            text: widget.activeEmitter.emitterSize.height.toString(),
          ),
          onSubmitted: (value) {
            setState(() {
              widget.activeEmitter.emitterSize = Size(
                widget.activeEmitter.emitterSize.width,
                double.tryParse(value) ?? 0.0,
              );
            });
          },
        ),
      ],
    );
  }

  Column _renderPositionY() {
    return Column(
      children: [
        Container(
          height: 32,
          alignment: Alignment.bottomLeft,
          child: Text(
            'Position X - 位置 Y',
            style: TextStyle(
              fontSize: 11,
              color: Color.fromARGB(255, 34, 34, 34),
            ),
            maxLines: 1,
          ),
        ),
        TextField(
          controller: TextEditingController(
            text: widget.activeEmitter.emitterPosition.dy.toString(),
          ),
          onSubmitted: (value) {
            setState(() {
              widget.activeEmitter.emitterPosition = Offset(
                widget.activeEmitter.emitterPosition.dx,
                double.tryParse(value) ?? 0.0,
              );
            });
          },
        ),
      ],
    );
  }

  Column _renderShape() {
    return Column(
      children: [
        Container(
          height: 32,
          alignment: Alignment.bottomLeft,
          child: Text(
            'Shape - 区域形状',
            style: TextStyle(
              fontSize: 11,
              color: Color.fromARGB(255, 34, 34, 34),
            ),
            maxLines: 1,
          ),
        ),
        DropdownButton(
          itemHeight: 56,
          items: EmitterShape.values
              .map((e) => DropdownMenuItem(
                    child: Text(e.toString().replaceAll('EmitterShape.', '')),
                    value: e,
                  ))
              .toList(),
          value: widget.activeEmitter.emitterShape,
          isExpanded: true,
          onChanged: (value) {
            setState(() {
              widget.activeEmitter.emitterShape = value as EmitterShape;
            });
          },
        )
      ],
    );
  }

  Column _renderMode() {
    return Column(
      children: [
        Container(
          height: 32,
          alignment: Alignment.bottomLeft,
          child: Text(
            'Mode - 发射方式',
            style: TextStyle(
              fontSize: 11,
              color: Color.fromARGB(255, 34, 34, 34),
            ),
            maxLines: 1,
          ),
        ),
        DropdownButton(
          itemHeight: 56,
          items: EmitterMode.values
              .map((e) => DropdownMenuItem(
                    child: Text(e.toString().replaceAll('EmitterMode.', '')),
                    value: e,
                  ))
              .toList(),
          value: widget.activeEmitter.emitterMode,
          isExpanded: true,
          onChanged: (value) {
            setState(() {
              widget.activeEmitter.emitterMode = value as EmitterMode;
            });
          },
        )
      ],
    );
  }

  Column _renderBirthRate() {
    return Column(
      children: [
        Container(
          height: 32,
          alignment: Alignment.bottomLeft,
          child: Text(
            'Birth Rate - 粒子生成速率',
            style: TextStyle(
              fontSize: 11,
              color: Color.fromARGB(255, 34, 34, 34),
            ),
            maxLines: 1,
          ),
        ),
        TextField(
          controller: TextEditingController(
            text: widget.activeEmitter.birthRate.toString(),
          ),
          onSubmitted: (value) {
            setState(() {
              widget.activeEmitter.birthRate = double.tryParse(value) ?? 0.0;
            });
          },
        ),
      ],
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
                  content: Text('要删除该发射器吗？'),
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
            '删除发射器',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
