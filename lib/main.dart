import 'package:flutter/material.dart';
import '/data/repositories/quotes_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Цитаты',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Цитаты'),
    );
  }
}

class Quote {
  final String text;
  final String author;
  final String imagePath;
  bool isFavorite;

  Quote(this.text, this.author, this.imagePath, [this.isFavorite = false]);

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Quote> _quotes = [];
  final List<Quote> _filteredQuotes = [];

  final QuotesRepository _quotesRepository = QuotesRepository();

  final TextEditingController searchController = TextEditingController();
  final TextEditingController authorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadQuotes();

    searchController.addListener(() {
      _loadQuotes();
    });

    authorController.addListener(() {
      _loadQuotes();
    });
  }

  // Метод для загрузки цитат с учетом обоих фильтров
  Future<void> _loadQuotes() async {
    final query = searchController.text;
    final author = authorController.text;

    final quotes = await _quotesRepository.loadData(
      q: query, // Поиск по цитате
      author: author, // Поиск по автору
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки: $error')),
        );
      },
    );

    if (quotes != null) {
      setState(() {
        _quotes.clear();
        _quotes.addAll(quotes);
        _filterQuotes();
      });
    }
    print('Загружено цитат: ${_quotes.length}');
    print('Отфильтрованные цитаты: ${_filteredQuotes.length}');
  }

  // Фильтрация цитат по введенным значениям
  void _filterQuotes() {
    setState(() {
      _filteredQuotes.clear(); // Очистите список фильтрации
      _filteredQuotes.addAll(_quotes); // Изначально показываем все цитаты

      // Применяем фильтрацию по цитате
      if (searchController.text.isNotEmpty) {
        _filteredQuotes.retainWhere((quote) =>
            quote.text.toLowerCase().contains(searchController.text.toLowerCase()));
      }

      // Применяем фильтрацию по автору
      if (authorController.text.isNotEmpty) {
        _filteredQuotes.retainWhere((quote) =>
            quote.author.toLowerCase().contains(authorController.text.toLowerCase()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Цитаты'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Поиск по цитате',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: authorController,
              decoration: const InputDecoration(
                labelText: 'Поиск по автору',
                prefixIcon: Icon(Icons.person),
              ),
            ),
          ),
          Expanded(
            child: _filteredQuotes.isEmpty
                ? const Center(
              child: Text(
                'Нет цитат для отображения.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: _filteredQuotes.length,
              itemBuilder: (context, index) {
                final quote = _filteredQuotes[index]; // Используем _filteredQuotes для отображения
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 10.0,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    leading: SizedBox(
                      width: 50.0,
                      child: Image.network(
                        quote.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                        const Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                    title: Text(
                      quote.text,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text('- ${quote.author}'),
                    trailing: IconButton(
                      icon: Icon(
                        quote.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: quote.isFavorite ? Colors.red : null,
                      ),
                      onPressed: () {
                        setState(() {
                          quote.toggleFavorite();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(quote.isFavorite
                                ? 'Цитата добавлена в избранное'
                                : 'Цитата удалена из избранного'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              QuoteDetailScreen(quote: quote),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class QuoteDetailScreen extends StatelessWidget {
  final Quote quote;

  const QuoteDetailScreen({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали цитаты'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                quote.imagePath,
                height: 150,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.error, color: Colors.red),
              ),
              const SizedBox(height: 20),
              Text(
                quote.text,
                style:
                const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                '- ${quote.author}',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





extension StringExtension on String {
  String capitalize() {
    return split(' ').map((word) {
      if (word.isNotEmpty) {
        return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
      }
      return word;
    }).join(' ');
  }

  String addQuotesIfMissing() {
    if (startsWith('\"') && endsWith('\"')) return this;
    if (startsWith('\"') && !endsWith('\"')) return '$this\"';
    if (endsWith('\"') && !startsWith('\"')) return '\"$this';
    return '\"$this\"';
  }
}
