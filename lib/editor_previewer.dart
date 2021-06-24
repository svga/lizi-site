part of './editor.dart';

class _EditorPreviewer extends StatefulWidget {
  final LiziModel liziModel;

  _EditorPreviewer({Key? key, required this.liziModel}) : super(key: key);

  @override
  __EditorPreviewerState createState() => __EditorPreviewerState();
}

class __EditorPreviewerState extends State<_EditorPreviewer>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  int lastTime = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);
    animationController.addListener(() {
      int curTime = DateTime.now().millisecondsSinceEpoch;
      int deltaTime = curTime - lastTime;
      lastTime = curTime;
      widget.liziModel.emitters.forEach((element) {
        element.update(deltaTime);
      });
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    animationController.animateTo(
      1.0,
      duration: Duration(seconds: 86400),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: (MediaQuery.of(context).size.height / 667.0) * 0.73,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 375.0,
          height: 667.0,
          color: Colors.black,
          child: CustomPaint(
            painter: _EditorPreviewerPainter(widget.liziModel),
          ),
        ),
      ),
    );
  }
}

class _EditorPreviewerPainter extends CustomPainter {
  final LiziModel liziModel;

  _EditorPreviewerPainter(this.liziModel);

  @override
  void paint(Canvas canvas, Size size) {
    liziModel.emitters.forEach((element) {
      element.draw(canvas);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
