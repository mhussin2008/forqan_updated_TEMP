import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:forqan_app/models/surah.dart';
import 'package:quran/quran.dart' as quran;
import '../Misc/solutionWidget.dart';

void resolveSameRow(List<GlobalKey<_WidgetSpanWrapperState>> keys) {
  var middle = (keys.length / 2.0).floor();
  for (int i = 0; i < middle; i++) {
    var a = keys[i];
    var b = keys[keys.length - i - 1];
    var left = getXOffsetOf(a);
    var right = getXOffsetOf(b);
    a.currentState?.updateXOffset(right - left);
    b.currentState?.updateXOffset(left - right);
  }
}

class SurahPage extends StatefulWidget {
  final Surah surah;
  const SurahPage({super.key, required this.surah});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  @override
  Widget build(BuildContext context) {
    int count = widget.surah.versesCount;
    int index = widget.surah.id;


    final keys = <GlobalKey<_WidgetSpanWrapperState>>[];
    var nextKey = () {
      var key = GlobalKey<_WidgetSpanWrapperState>();
      keys.add(key);
      return key;
    };
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      List<GlobalKey<_WidgetSpanWrapperState>>? sameRow;
      GlobalKey<_WidgetSpanWrapperState> prev = keys.removeAt(0);
      keys.forEach((key) {
        if (getYOffsetOf(key) == getYOffsetOf(prev)) {
          if (sameRow == null) {
            sameRow = [prev];
          }
          sameRow!.add(key);
        } else if (sameRow != null) {
          resolveSameRow(sameRow!);
          sameRow = null;
        }
        prev = key;
      });
      if (sameRow != null) {
        resolveSameRow(sameRow!);
      }
    });




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
        body: SafeArea(
          minimum: const EdgeInsets.all(15),
          child: ListView(children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: header(),
            ),
            const SizedBox(
              height: 5,
            ),
            RichText(
              textAlign: count <= 20 ? TextAlign.center : TextAlign.justify,
              text: TextSpan(
                children: [
                  for (var i = 1; i <= count; i++) ...{
                    TextSpan(
                      text: ' ${quran.getVerse(index, i, verseEndSymbol: false)} ',
                      style: const TextStyle(
                        fontFamily: 'Kitab',
                        fontSize: 25,
                        color: Colors.black87,
                      ),
                    ),

                    WidgetSpan(
                      child: WidgetSpanWrapper(
                        key: nextKey(),
                        child: TestWidgetSpan(color: Colors.red, order: i),
                      ),
                    ),

                    ////////////////////////
                    // WidgetSpan(
                    //     alignment: PlaceholderAlignment.middle,
                    //     child: CircleAvatar(
                    //       radius: 14,
                    //       child: Text(
                    //         '$i',
                    //         textAlign: TextAlign.center,
                    //         textScaler: TextScaler.linear(i.toString().length <= 2 ? 1 : .8),
                    //         // textScaleFactor:i.toString().length <= 2 ? 1 : .8 ,
                    //
                    //       ),
                    //     ))


                    //////////////////////////////
                  }
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget header() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.surah.arabicName,
          style: const TextStyle(
            fontFamily: 'Aldhabi',
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          ' ${quran.getBasmala()} ',
          textDirection: TextDirection.rtl,
          style: const TextStyle(
            fontFamily: 'NotoNastaliqUrdu',
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}

class WidgetSpanWrapper extends StatefulWidget {
  const WidgetSpanWrapper({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  _WidgetSpanWrapperState createState() => _WidgetSpanWrapperState();
}

class _WidgetSpanWrapperState extends State<WidgetSpanWrapper> {
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