library editor;

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:lizi/lizi.dart';
import 'package:lizi_site/app_bar.dart';
import 'package:lizi_site/lizi_model.dart';
import 'package:file_picker/file_picker.dart';

import 'bottom_bar.dart';
import 'file_saver.dart' if (dart.library.js) 'file_saver_js.dart';

part './editor_emitter.dart';
part './editor_particle.dart';
part './editor_previewer.dart';
part './editor_content.dart';

class MyEditorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LiziAppBar(),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1176),
          child: Column(
            children: [
              SizedBox(height: 66),
              Expanded(child: _EditorSekeleton()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: LiziBottomBar(),
    );
  }
}

class _EditorSekeleton extends StatefulWidget {
  @override
  __EditorSekeletonState createState() => __EditorSekeletonState();
}

class __EditorSekeletonState extends State<_EditorSekeleton> {
  LafItem? liziModel;

  @override
  void initState() {
    super.initState();
    liziModel = LiziModel.blankModel();
  }

  @override
  Widget build(BuildContext context) {
    if (liziModel == null) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 88.0),
      child: Row(
        children: [
          _EditorPreviewer(liziModel: liziModel!),
          SizedBox(width: 66),
          Expanded(
            child: _EditorInspector(
              liziModel!,
              key: Key(liziModel!.hashCode.toString()),
              onNewLiziModel: (value) {
                setState(() {
                  liziModel = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EditorInspector extends StatefulWidget {
  final LafItem liziModel;
  final Function(LafItem) onNewLiziModel;

  _EditorInspector(this.liziModel, {Key? key, required this.onNewLiziModel})
      : super(key: key);

  @override
  __EditorInspectorState createState() => __EditorInspectorState();
}

class __EditorInspectorState extends State<_EditorInspector>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Emitter? activeEmitter;

  @override
  void initState() {
    super.initState();
    activeEmitter = widget.liziModel.emitters[0];
    _resetTabController();
  }

  void _resetTabController() {
    _tabController = TabController(
      length: 1 + activeEmitter!.cells.length,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (activeEmitter == null) return Container();
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.0,
          color: Color.fromARGB(32, 0, 59, 153),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TabBar(
                  tabs: [
                    Tab(
                      child: Container(
                        height: 44,
                        child: _renderEmitterButton(),
                      ),
                    ),
                    ...activeEmitter!.cells
                        .asMap()
                        .keys
                        .map((e) => Tab(text: '?????? - $e')),
                  ],
                  isScrollable: true,
                  indicatorColor: Color.fromARGB(128, 0, 59, 153),
                  labelColor: Color.fromARGB(255, 34, 34, 34),
                  unselectedLabelColor: Color.fromARGB(100, 34, 34, 34),
                  controller: _tabController,
                ),
              ),
              MaterialButton(
                onPressed: () {
                  _showSettingMenu();
                },
                height: 54,
                child: Icon(Icons.settings),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _renderEmitterInspectorPage(context),
                ...activeEmitter!.cells.asMap().values.map(
                      (e) => _renderParticleInspectorPage(e, context),
                    ),
              ],
              controller: _tabController,
            ),
          ),
        ],
      ),
    );
  }

  void _onExport() {
    final data = widget.liziModel.encode();
    FileSaver.saveFile(Uint8List.fromList(utf8.encode(data)),
        'laf_${Random().nextInt(9999999)}.json');
  }

  void _onImport() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.first.bytes != null) {
      final fileContent = utf8.decode(result.files.first.bytes!);
      final fileModel = LafItem.decodeFromString(fileContent);
      widget.onNewLiziModel(fileModel);
    }
  }

  void _showSettingMenu() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    _onExport();
                  },
                  title: Text(
                    '?????? JSON ??????',
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    _onImport();
                  },
                  title: Text(
                    '?????? JSON ??????',
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.onNewLiziModel(LiziModel.blankModel());
                  },
                  title: Text(
                    '??????',
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  title: Text(
                    '??????',
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _EditorEmitterInspector _renderEmitterInspectorPage(BuildContext context) {
    return _EditorEmitterInspector(
      model: widget.liziModel,
      activeEmitter: activeEmitter!,
      onDelete: () {
        if (widget.liziModel.emitters.length <= 1) {
          final snackBar = SnackBar(content: Text('?????????????????????????????????????????????????????????'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }
        widget.liziModel.emitters.remove(activeEmitter!);
        activeEmitter = widget.liziModel.emitters.last;
        _resetTabController();
        setState(() {});
      },
    );
  }

  _EditorParticleInspector _renderParticleInspectorPage(
      Cell e, BuildContext context) {
    return _EditorParticleInspector(
      activeCell: e,
      onCopy: () {
        final copiedCell = LiziModel.copyCell(e);
        activeEmitter!.cells.add(copiedCell);
        _resetTabController();
        _tabController.index = _tabController.length - 1;
        setState(() {});
      },
      onDelete: () {
        if (activeEmitter!.cells.length <= 1) {
          final snackBar = SnackBar(content: Text('???????????????????????????????????????????????????'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }
        activeEmitter!.cells.remove(e);
        _resetTabController();
        _tabController.index = _tabController.length - 1;
        setState(() {});
      },
    );
  }

  Widget _renderEmitterButton() {
    return Stack(
      children: [
        IgnorePointer(
          ignoring: _tabController.index > 0,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: DropdownButton(
              items: widget.liziModel.emitters.asMap().keys.map((e) {
                return DropdownMenuItem(
                  child: Text('????????? - $e'),
                  value: widget.liziModel.emitters[e],
                );
              }).toList()
                ..add(DropdownMenuItem(
                  child: Text('???????????????'),
                  value: null,
                )),
              value: activeEmitter,
              underline: Container(),
              isExpanded: false,
              onChanged: (value) {
                if (value == null) {
                  setState(() {
                    final newEmittter = LiziModel.blankEmitter();
                    widget.liziModel.emitters.add(newEmittter);
                    activeEmitter = newEmittter;
                    _resetTabController();
                  });
                } else {
                  setState(() {
                    activeEmitter = value as Emitter;
                    _resetTabController();
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
