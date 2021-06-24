library editor;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lizi/lizi.dart';
import 'package:lizi_site/app_bar.dart';
import 'package:lizi_site/lizi_model.dart';

import 'bottom_bar.dart';

part './editor_emitter.dart';
part './editor_particle.dart';
part './editor_previewer.dart';

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
  LiziModel? liziModel;

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
            child: _EditorInspector(liziModel!),
          ),
        ],
      ),
    );
  }
}

class _EditorInspector extends StatefulWidget {
  final LiziModel liziModel;

  _EditorInspector(this.liziModel);

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
          TabBar(
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
                  .map((e) => Tab(text: '粒子 - $e')),
            ],
            isScrollable: true,
            indicatorColor: Color.fromARGB(128, 0, 59, 153),
            labelColor: Color.fromARGB(255, 34, 34, 34),
            unselectedLabelColor: Color.fromARGB(100, 34, 34, 34),
            controller: _tabController,
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

  _EditorEmitterInspector _renderEmitterInspectorPage(BuildContext context) {
    return _EditorEmitterInspector(
      model: widget.liziModel,
      activeEmitter: activeEmitter!,
      onDelete: () {
        if (widget.liziModel.emitters.length <= 1) {
          final snackBar = SnackBar(content: Text('不能删除最该发射器（至少保留一个发射器）'));
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
          final snackBar = SnackBar(content: Text('不能删除最该粒子（至少保留一个粒子）'));
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
                  child: Text('发射器 - $e'),
                  value: widget.liziModel.emitters[e],
                );
              }).toList()
                ..add(DropdownMenuItem(
                  child: Text('新增发射器'),
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
