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
          primary: Colors.blue[700]!, // Darker Blue for contrast
          secondary: Colors.green[700]!, // Darker Green
          tertiary: Colors.orange[700]!, // Darker Orange
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
        int points = card.text.length;
        score += points;
        showPointAnimation(points);
      });
    }
  }

  void swipeLeft() {
    if (flashcards.isNotEmpty) {
      setState(() {
        flashcards.removeAt(0);
        score = score > 0 ? score - 1 : 0;
        showPointAnimation(-1);
      });
    }
  }

  void repeatIncorrect() {
    setState(() {
      // Add logic to repeat incorrect words if needed
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
              mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
              children: [
                ElevatedButton(
                  onPressed: swipeLeft,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  ),
                  child: const Text(
                    'Falsch',
                    style: TextStyle(color: Colors.white), // Ensure text is visible
                  ),
                ),
                const SizedBox(width: 20), // Add space between buttons
                ElevatedButton(
                  onPressed: swipeRight,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  ),
                  child: const Text(
                    'Richtig',
                    style: TextStyle(color: Colors.white), // Ensure text is visible
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
                style: TextStyle(color: Colors.white), // Ensure text is visible
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