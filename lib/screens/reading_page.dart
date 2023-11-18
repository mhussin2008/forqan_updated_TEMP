import 'package:flutter/material.dart';
import 'package:forqan_app/models/surah.dart';
import 'package:quran/quran.dart' as quran;

class SurahPage extends StatelessWidget {
  final Surah surah;
  const SurahPage({super.key, required this.surah});
  @override
  Widget build(BuildContext context) {
    int count = surah.versesCount;
    int index = surah.id;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(),
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
                        alignment: PlaceholderAlignment.middle,
                        child: CircleAvatar(
                          radius: 14,
                          child: Text(
                            '$i',
                            textAlign: TextAlign.center,
                            textScaler: TextScaler.linear(i.toString().length <= 2 ? 1 : .8),
                           // textScaleFactor:i.toString().length <= 2 ? 1 : .8 ,

                          ),
                        ))
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
      surah.arabicName,
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
