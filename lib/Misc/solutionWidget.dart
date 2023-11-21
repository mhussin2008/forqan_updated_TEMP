import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widget Test',
      home: TestWidgetSpans(),
    );
  }
}

double getYOffsetOf(GlobalKey key) {
  RenderBox? box = key.currentContext!.findRenderObject() as RenderBox;
  return box!.globalToLocal(Offset.zero).dy;

  // return box!.getTransformTo(box!.parent).localToGlobal(Offset.zero).dy;
}

double getXOffsetOf(GlobalKey key) {
  RenderBox? box = key.currentContext!.findRenderObject() as RenderBox;
  return box.localToGlobal(Offset.zero).dx;
}

// void resolveSameRow(List<GlobalKey<_WidgetSpanWrapperState>> keys) {
//   var middle = (keys.length / 2.0).floor();
//   for (int i = 0; i < middle; i++) {
//     var a = keys[i];
//     var b = keys[keys.length - i - 1];
//     var left = getXOffsetOf(a);
//     var right = getXOffsetOf(b);
//     a.currentState?.updateXOffset(right - left);
//     b.currentState?.updateXOffset(left - right);
//   }
// }

class TestWidgetSpans extends StatefulWidget {
  @override
  State<TestWidgetSpans> createState() => _TestWidgetSpansState();
}

class _TestWidgetSpansState extends State<TestWidgetSpans> {
  @override
  Widget build(BuildContext context) {
    final keys = <GlobalKey<_WidgetSpanWrapper2State>>[];
    var nextKey = () {
      var key = GlobalKey<_WidgetSpanWrapper2State>();
      keys.add(key);
      return key;
    };
    // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    //   List<GlobalKey<_WidgetSpanWrapper2State>>? sameRow;
    //   GlobalKey<_WidgetSpanWrapper2State> prev = keys.removeAt(0);
    //   keys.forEach((key) {
    //     if (getYOffsetOf(key) == getYOffsetOf(prev)) {
    //       if (sameRow == null) {
    //         sameRow = [prev];
    //       }
    //       sameRow!.add(key);
    //     } else if (sameRow != null) {
    //       resolveSameRow(sameRow!);
    //       sameRow = null;
    //     }
    //     prev = key;
    //   });
    //   if (sameRow != null) {
    //     resolveSameRow(sameRow!);
    //   }
    // });

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(leading: ElevatedButton(
          onPressed: (){
            setState(() {

            });
          },
          child: Text('refresh'),
        ),),
        body: Center(
          child: Text.rich(
            TextSpan(
              text: 'هذا اختبار',
              style: TextStyle(
                backgroundColor: Colors.grey.withOpacity(0.5),
                fontSize: 30,
              ),
              children: [
                WidgetSpan(
                  child: WidgetSpanWrapper2(
                    key: nextKey(),
                    child: TestWidgetSpan(color: Colors.red, order: 1),
                  ),
                ),
                TextSpan(text: ' و '),
                WidgetSpan(
                  child: WidgetSpanWrapper2(
                    key: nextKey(),
                    child: TestWidgetSpan(color: Colors.orange, order: 2),
                  ),
                ),
                TextSpan(text: ' ثم '),
                WidgetSpan(
                  child: WidgetSpanWrapper2(
                    key: nextKey(),
                    child: TestWidgetSpan(color: Colors.yellow, order: 3),
                  ),
                ),
                TextSpan(text: ' ، لكنه معطل'),
                WidgetSpan(
                  child: WidgetSpanWrapper2(
                    key: nextKey(),
                    child: TestWidgetSpan(color: Colors.green, order: 4),
                  ),
                ),
                TextSpan(text: ' اختبارات '),
                WidgetSpan(
                  child: WidgetSpanWrapper2(
                    key: nextKey(),
                    child: TestWidgetSpan(color: Colors.blue, order: 5),
                  ),
                ),
                TextSpan(text: ' اختبارات '),
                WidgetSpan(
                  child: WidgetSpanWrapper2(
                    key: nextKey(),
                    child: TestWidgetSpan(color: Colors.purple, order: 6),
                  ),
                ),
                TextSpan(text: ' اختبارات '),
                WidgetSpan(
                  child: WidgetSpanWrapper2(
                    key: nextKey(),
                    child: TestWidgetSpan(color: Colors.pink, order: 7),
                  ),
                ),
                TextSpan(text: ' اختبارات '),
                WidgetSpan(
                  child: WidgetSpanWrapper2(
                    key: nextKey(),
                    child: TestWidgetSpan(color: Colors.lime, order: 8),
                  ),
                ),
                TextSpan(text: ' اختبارات '),
                WidgetSpan(
                  child: WidgetSpanWrapper2(
                    key: nextKey(),
                    child: TestWidgetSpan(color: Colors.teal, order: 9),
                  ),
                ),
                TextSpan(text: ' اختبارات '),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WidgetSpanWrapper2 extends StatefulWidget {
  const WidgetSpanWrapper2({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  _WidgetSpanWrapper2State createState() => _WidgetSpanWrapper2State();
}

class _WidgetSpanWrapper2State extends State<WidgetSpanWrapper2> {
  Offset offset = Offset.zero;

  void updateXOffset(double xOffset) {
    setState(() {
      this.offset = Offset(xOffset, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: widget.child,
    );
  }
}

class TestWidgetSpan extends StatelessWidget {
  final Color color;
  final int order;

  const TestWidgetSpan({Key? key, required this.color, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
       return CircleAvatar(
          radius: 14,
          child: Text(
            '$order',
            textAlign: TextAlign.center,
            textScaler: TextScaler.linear(order.toString().length <= 2 ? 1 : .8),
            // textScaleFactor:i.toString().length <= 2 ? 1 : .8 ,

          ));


    // return Container(
    //   color: color.withOpacity(0.5),
    //   width: 40,
    //   child: Center(child: Text(order.toString())),
    // );
  }
}