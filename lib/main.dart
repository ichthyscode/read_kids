import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lese-Übungs-App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue[700]!,
          secondary: Colors.green[700]!,
          tertiary: Colors.orange[700]!,
        ),
      ),
      home: const ReadingGamePage(),
    );
  }
}

class Flashcard {
  final String text;
  bool isCorrect;

  Flashcard(this.text, {this.isCorrect = false});
}

class ReadingGamePage extends StatefulWidget {
  const ReadingGamePage({super.key});

  @override
  ReadingGamePageState createState() => ReadingGamePageState();
}

class ReadingGamePageState extends State<ReadingGamePage> {
  List<Flashcard> flashcards = [];
  List<Flashcard> correctFlashcards = [];
  List<Flashcard> incorrectFlashcards = [];
  int score = 0;
  String? lastPoints;

  @override
  void initState() {
    super.initState();
    initializeFlashcards();
  }

  void initializeFlashcards() {
    flashcards = [
      Flashcard("Buch"),
      Flashcard("Lied"),
      Flashcard("Haus"),
      Flashcard("Baum"),
      Flashcard("Schule"),
      Flashcard("Kindergarten"),
    ];
  }

  List<int> findSyllablePositions(String word) {
    List<int> positions = [];
    String vowels = 'aeiouäöü';
    String connections = 'sch,ch,ph,ck,pf,br,pl,tr,st,gr';
    int length = word.length;

    if (length > 2) {
      bool canSplit = false;

      for (int i = 1; i < length - 1; i++) {
        String z0 = word[i - 1];
        if (!canSplit && vowels.contains(z0)) {
          canSplit = true;
        }

        if (canSplit) {
          String z = word[i];
          String z1 = word[i + 1];
          String v = z0 + z;

          if (v == 'ch' && i > 1 && word[i - 2] == 's') {
            v = 'sch';
          }

          if (vowels.contains(z1) && !vowels.contains(z)) {
            if (connections.contains(v)) {
              positions.add(i - v.length + 1);
            } else {
              positions.add(i);
            }
          }
        }
      }
    }

    return positions;
  }

  List<String> splitIntoSyllables(String word) {
    List<int> positions = findSyllablePositions(word);
    List<String> syllables = [];
    int start = 0;

    for (int pos in positions) {
      syllables.add(word.substring(start, pos));
      start = pos;
    }
    syllables.add(word.substring(start));

    return syllables;
  }

  List<TextSpan> colorizeSyllables(String word, List<Color> colors) {
    List<String> syllables = splitIntoSyllables(word);
    List<TextSpan> spans = [];
    for (int i = 0; i < syllables.length; i++) {
      spans.add(TextSpan(
        text: syllables[i],
        style: TextStyle(color: colors[i % colors.length]),
      ));
    }
    return spans;
  }

  void showPointAnimation(int points) {
    setState(() {
      lastPoints = (points >= 0 ? "+" : "") + points.toString();
    });
  }

  void swipeRight() {
    if (flashcards.isNotEmpty) {
      setState(() {
        Flashcard card = flashcards.removeAt(0);
        card.isCorrect = true;
        int points = card.text.length;
        score += points;
        correctFlashcards.add(card);
        showPointAnimation(points);
      });
    }
  }

  void swipeLeft() {
    if (flashcards.isNotEmpty) {
      setState(() {
        Flashcard card = flashcards.removeAt(0);
        card.isCorrect = false;
        score = score > 0 ? score - 1 : 0;
        incorrectFlashcards.add(card);
        showPointAnimation(-1);
      });
    }
  }

  void repeatIncorrect() {
    setState(() {
      if (incorrectFlashcards.isNotEmpty) {
        flashcards.addAll(incorrectFlashcards);
        incorrectFlashcards.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).colorScheme.tertiary
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lese-Übungs-App'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Punktestand: $score',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 40),
            if (flashcards.isNotEmpty)
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 142, fontWeight: FontWeight.bold),
                  children: colorizeSyllables(flashcards[0].text, colors),
                ),
              )
            else
              const Text(
                'Alle Karten gelesen!',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: swipeLeft,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  ),
                  child: const Text(
                    'Falsch',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: swipeRight,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  ),
                  child: const Text(
                    'Richtig',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: repeatIncorrect,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text(
                'Falsche wiederholen',
                style: TextStyle(color: Colors.white),
              ),
            ),
            if (lastPoints != null)
              Animate(
                effects: const [
                  FadeEffect(duration: Duration(milliseconds: 500)),
                  ScaleEffect(begin: Offset(0.5, 0.5), end: Offset(1.5, 1.5), duration: Duration(milliseconds: 500)),
                  MoveEffect(begin: Offset(0, 50), end: Offset(0, -50), duration: Duration(milliseconds: 500)),
                ],
                onComplete: (controller) {
                  setState(() {
                    lastPoints = null;
                  });
                },
                child: Text(
                  lastPoints!,
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: lastPoints!.startsWith('+')
                        ? Colors.green[700]
                        : Colors.red[700],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}