import 'package:open_eta/helpers/ui_helper.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomDialog extends StatefulWidget {
  final String title, description, buttonText;
  final Image image;
  final Function function;

  CustomDialog({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.image,
    this.function,
  });

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog>
    with TickerProviderStateMixin {
  AnimationController animationController;
  UiHelper uiHelper = UiHelper();

  String get timeString {
    Duration duration =
        animationController.duration * animationController.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 30),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(uiHelper.scrWidth(context) * 0.05),
      ),
      elevation: 2.0,
      title: Text(
        '${this.widget.title}',
        style: uiHelper.size(26),
      ),
      content: Column(
        children: <Widget>[
          Text(
            '${this.widget.description}',
            style: uiHelper.size(20),
          ),
          AnimatedBuilder(
              animation: animationController,
              builder: (BuildContext context, Widget child) {
                return Text(
                  timeString,
                  style: uiHelper.size(20),
                );
              }),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            '${this.widget.buttonText}',
            style: uiHelper.size(20),
          ),
          onPressed: () {},
        )
      ],
    );
  }
}

class TimerPainter extends CustomPainter {
  TimerPainter({this.animation, this.backgroundColor, this.color})
      : super(repaint: animation);

  final Animation animation;
  final Color backgroundColor, color;

  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
