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
        primarySwatch: Colors.pink,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue[600]!, // Kräftigeres Blau
          secondary: Colors.green[600]!, // Kräftigeres Grün
          tertiary: Colors.orange[600]!, // Kräftigeres Orange
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
  _ReadingGamePageState createState() => _ReadingGamePageState();
}

class _ReadingGamePageState extends State<ReadingGamePage> {
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
    ];
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
      flashcards.addAll(incorrectFlashcards);
      incorrectFlashcards.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
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
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 40),
            if (flashcards.isNotEmpty)
              Text(
                flashcards[0].text,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 72, fontWeight: FontWeight.bold),
              )
            else
              const Text(
                'Alle Karten gelesen!',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: swipeLeft,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    textStyle: const TextStyle(fontSize: 24),
                  ),
                  child: const Text('Falsch'),
                ),
                ElevatedButton(
                  onPressed: swipeRight,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    textStyle: const TextStyle(fontSize: 24),
                  ),
                  child: const Text('Richtig'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: repeatIncorrect,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Falsche wiederholen'),
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