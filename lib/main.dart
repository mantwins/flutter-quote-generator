import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const QuoteApp());
}

class Quote {
  final String text;
  final String author;

  const Quote({required this.text, required this.author});
}

class QuoteApp extends StatelessWidget {
  const QuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote of the Day',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const QuoteScreen(),
    );
  }
}

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  static const List<Quote> _quotes = [
    Quote(text: "The best way to get started is to quit talking and begin doing.", author: "Walt Disney"),
    Quote(text: "Don't watch the clock; do what it does. Keep going.", author: "Sam Levenson"),
    Quote(text: "Success is not final, failure is not fatal: it is the courage to continue that counts.", author: "Winston Churchill"),
    Quote(text: "Believe you can and you're halfway there.", author: "Theodore Roosevelt"),
    Quote(text: "It always seems impossible until it's done.", author: "Nelson Mandela"),
    Quote(text: "Simplicity is the ultimate sophistication.", author: "Leonardo da Vinci"),
  ];

  static const List<Color> _colors = [
    Colors.deepPurple,
    Colors.teal,
    Colors.indigo,
    Colors.blueGrey,
    Colors.orange,
  ];

  late Quote _currentQuote;
  Color _currentColor = Colors.deepPurple;
  final List<Quote> _favorites = [];

  @override
  void initState() {
    super.initState();
    _currentQuote = _quotes[0];
  }

  void _showRandomQuote() {
    final random = Random();
    setState(() {
      _currentQuote = _quotes[random.nextInt(_quotes.length)];
      _currentColor = _colors[random.nextInt(_colors.length)];
    });
  }

  void _toggleFavorite() {
    setState(() {
      if (_favorites.contains(_currentQuote)) {
        _favorites.remove(_currentQuote);
      } else {
        _favorites.add(_currentQuote);
      }
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: '"${_currentQuote.text}" - ${_currentQuote.author}'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quote copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showFavoritesDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Saved Favorites'),
          content: SizedBox(
            width: double.maxFinite,
            child: _favorites.isEmpty
                ? const Text('No favorites saved yet!')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _favorites.length,
                    itemBuilder: (context, index) {
                      final quote = _favorites[index];
                      return ListTile(
                        title: Text('"${quote.text}"'),
                        subtitle: Text('- ${quote.author}'),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFav = _favorites.contains(_currentQuote);

    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _currentColor),
        useMaterial3: true,
      ),
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return Scaffold(
            backgroundColor: theme.colorScheme.surfaceContainerLowest,
            appBar: AppBar(
              title: const Text('Quote of the Day', style: TextStyle(fontWeight: FontWeight.bold)),
              centerTitle: true,
              elevation: 2,
              actions: [
                IconButton(
                  icon: const Icon(Icons.bookmarks_rounded),
                  tooltip: 'View Favorites',
                  onPressed: _showFavoritesDialog,
                ),
              ],
            ),
            body: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.format_quote_rounded,
                              size: 48,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _currentQuote.text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "- ${_currentQuote.author}",
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: theme.colorScheme.outline,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isFav ? Icons.favorite : Icons.favorite_border,
                                    color: isFav ? Colors.red : theme.colorScheme.outline,
                                  ),
                                  onPressed: _toggleFavorite,
                                ),
                                const SizedBox(width: 16),
                                IconButton(
                                  icon: Icon(Icons.copy_rounded, color: theme.colorScheme.outline),
                                  onPressed: _copyToClipboard,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: _showRandomQuote,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text(
                        'New Quote',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
