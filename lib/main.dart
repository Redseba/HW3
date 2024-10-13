import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DBZ Card Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'DBZ Card Matching Game!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<bool> _currentCardStates = List.filled(16, false); 
  List<int> _cardsIndex = [
    0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7
  ]; 
  int? _firstFlippedCard; 
  bool _gameWon = false; // Check if game is won

  @override
  void initState() {
    super.initState();
    _cardsIndex.shuffle(); // Randomize card order
  }

  void _cardFlip(int index) {
    if (_currentCardStates[index] || _gameWon) return; // Ignore if already flipped or game won

    setState(() {
      _currentCardStates[index] = true; // Flip the selected card face-up
    });

    if (_firstFlippedCard == null) {
      _firstFlippedCard = index; // Set the first flipped card
    } else {
      if (_cardsIndex[_firstFlippedCard!] == _cardsIndex[index]) {
        _firstFlippedCard = null; // Cards match, reset the first card
      } else {
        // Cards don't match, flip them back after a delay
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _currentCardStates[_firstFlippedCard!] = false; 
            _currentCardStates[index] = false; 
            _firstFlippedCard = null; // Reset first card
          });
        });
      }
      // Check if all cards are face-up and the game is won
      if (_currentCardStates.every((state) => state)) {
        setState(() {
          _gameWon = true; // All cards matched
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = List.generate(_cardsIndex.length, (index) {
      return GestureDetector(
        onTap: () => _cardFlip(index), // Flip card when tapped

        child: Container(
          decoration: BoxDecoration(
            color: _currentCardStates[index] ? Colors.teal[100] : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: _currentCardStates[index]
              ? Image.asset(
                  'Assets/Set${_cardsIndex[index] + 1}.jpg',
                  fit: BoxFit.cover,
                )
              : null, // Show image if flipped, otherwise blank
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _gameWon
          ? Center(
              child: Text(
                'Congrats You Won!!!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            )
          : GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 4,
              children: cards,
            ),
    );
  }
}
