import 'package:flutter/material.dart';
import 'dart:math';

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

  void swipeRight() {
    if (flashcards.isNotEmpty) {
      setState(() {
        Flashcard card = flashcards.removeAt(0);
        card.isCorrect = true;
        score += card.text.length;
        correctFlashcards.add(card);
      });
    }
  }

  void swipeLeft() {
    if (flashcards.isNotEmpty) {
      setState(() {
        Flashcard card = flashcards.removeAt(0);
        card.isCorrect = false;
        score = max(0, score - 1);  // Verhindert negative Punktzahlen
        incorrectFlashcards.add(card);
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Punktestand: $score',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            if (flashcards.isNotEmpty)
              Text(
                flashcards[0].text,
                style: Theme.of(context).textTheme.displaySmall,
              )
            else
              const Text(
                'Alle Karten gelesen!',
                style: TextStyle(fontSize: 24),
              ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: swipeLeft,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Falsch'),
                ),
                ElevatedButton(
                  onPressed: swipeRight,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Richtig'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: repeatIncorrect,
              child: const Text('Falsche wiederholen'),
            ),
          ],
        ),
      ),
    );
  }
}