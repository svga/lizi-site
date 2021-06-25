part of './editor.dart';

class _HexColor {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

class _EditorContent extends StatefulWidget {
  final Cell cell;

  const _EditorContent({Key? key, required this.cell}) : super(key: key);

  @override
  __EditorContentState createState() => __EditorContentState();
}

class __EditorContentState extends State<_EditorContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ui.Image? nextContent;
  String? nextContentBase64;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Widget _renderBody() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _renderPreviewer(),
        SizedBox(width: 12),
        Expanded(
          child: _renderGenerator(),
        )
      ],
    );
  }

  Widget _renderPreviewer() {
    return Column(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              color: Colors.black,
              child: (() {
                if (nextContentBase64 != null) {
                  return Image.memory(
                    base64.decode(nextContentBase64!),
                    fit: BoxFit.scaleDown,
                  );
                } else if (widget.cell.contentsBytes != null) {
                  return Image.memory(
                    widget.cell.contentsBytes!,
                    fit: BoxFit.scaleDown,
                  );
                }
              })(),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          '当前纹理',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        )
      ],
    );
  }

  Widget _renderGenerator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TabBar(
          tabs: [
            Tab(text: '上传图片'),
            Tab(text: '制作纹理'),
          ],
          isScrollable: true,
          labelColor: Theme.of(context).primaryColor,
          indicatorColor: Theme.of(context).primaryColor,
          controller: _tabController,
        ),
        Expanded(
          child: TabBarView(
            children: [
              _renderFileUploader(),
              _renderOnlineDesigner(),
            ],
            controller: _tabController,
          ),
        )
      ],
    );
  }

  Widget _renderFileUploader() {
    return Container();
  }

  Widget _renderOnlineDesigner() {
    return _OnlineDesigner(
      onGenerated: (value) async {
        final data = await value.toByteData(format: ui.ImageByteFormat.png);
        if (data != null) {
          setState(() {
            nextContent = value;
            nextContentBase64 = base64.encode(data.buffer.asUint8List());
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('修改粒子纹理'),
      actionsPadding: EdgeInsets.only(right: 12, bottom: 12),
      content: Container(
        height: 300,
        width: 600,
        child: _renderBody(),
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop(nextContent);
          },
          child: Text(
            '提交',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            '取消',
          ),
        ),
      ],
    );
  }
}

class _OnlineDesigner extends StatefulWidget {
  final Function(ui.Image) onGenerated;

  const _OnlineDesigner({
    Key? key,
    required this.onGenerated,
  }) : super(key: key);

  @override
  __OnlineDesignerState createState() => __OnlineDesignerState();
}

class __OnlineDesignerState extends State<_OnlineDesigner> {
  String shape = 'circle';
  final TextEditingController sizeEditingController = TextEditingController(
    text: '10',
  );
  String fillMode = 'color';
  final TextEditingController fillColorEditingController =
      TextEditingController(
    text: '#ffffff',
  );

  void doGenerate() {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint();
    double size = double.tryParse(sizeEditingController.text) ?? 0.0;
    if (fillMode == 'color') {
      paint.color = _HexColor.fromHex(fillColorEditingController.text);
    } else if (fillMode == 'gradient') {
      paint.shader = RadialGradient(
        colors: [
          _HexColor.fromHex(fillColorEditingController.text),
          _HexColor.fromHex(fillColorEditingController.text).withOpacity(0.0),
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size / 2.0, size / 2.0),
          radius: size / 2.0,
        ),
      );
    }
    if (shape == 'circle') {
      canvas.drawCircle(
        Offset(size / 2.0, size / 2.0),
        size / 2.0,
        paint,
      );
    } else if (shape == 'square') {
      canvas.drawRect(Rect.fromLTWH(0, 0, size, size), paint);
    }
    pictureRecorder
        .endRecording()
        .toImage(size.toInt(), size.toInt())
        .then((value) {
      widget.onGenerated(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('形状'),
          trailing: DropdownButton(
            items: ['circle', 'square'].map((e) {
              return DropdownMenuItem(child: Text(e), value: e);
            }).toList(),
            onChanged: (value) {
              setState(() {
                shape = value as String;
              });
            },
            value: shape,
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: [
              Text('尺寸'),
              Spacer(),
              Container(
                width: 76,
                child: TextField(
                  controller: sizeEditingController,
                  textAlign: TextAlign.end,
                  onSubmitted: (value) {},
                ),
              )
            ],
          ),
        ),
        ListTile(
          title: Text('填充方式'),
          trailing: DropdownButton(
            items: ['color', 'gradient'].map((e) {
              return DropdownMenuItem(child: Text(e), value: e);
            }).toList(),
            onChanged: (value) {
              setState(() {
                fillMode = value as String;
              });
            },
            value: fillMode,
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: [
              Text('填充色'),
              Spacer(),
              Container(
                width: 76,
                child: TextField(
                  controller: fillColorEditingController,
                  textAlign: TextAlign.end,
                  onSubmitted: (value) {},
                ),
              )
            ],
          ),
        ),
        ListTile(
          onTap: () {
            doGenerate();
          },
          title: Container(
            width: 300,
            height: 44,
            child: Center(
              child: Text(
                '生成纹理',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
