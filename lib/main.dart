// ignore_for_file: unnecessary_string_escapes

import 'package:flutter/material.dart';

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

// Enum для управления состоянием сообщений
enum MessageType { noQuotes, newQuoteAdded }

// Модель цитаты
class Quote {
  final String text;
  final String author;
  Quote(this.text, this.author);
}

// Главный экран
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Quote> _quotes = [];
  MessageType _messageType = MessageType.noQuotes;

  // Метод добавления цитаты
  Future<void> _addQuote() async {
    final result = await showDialog<Map<String, String>?>(
      context: context,
      builder: (BuildContext context) => const AddQuoteDialog(),
    );

    if (result != null && result['quote'] != '' && result['author'] != '') {
      setState(() {
        _quotes.add(
          Quote(result['quote']!.addQuotesIfMissing(), result['author']!.capitalize()),
        );
        _messageType = MessageType.newQuoteAdded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Center(
            child: _messageType == MessageType.noQuotes
                ? const NoQuotesMessage()
                : QuoteList(quotes: _quotes),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: QuoteCounter(count: _quotes.length),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addQuote,
        tooltip: 'Добавить цитату',
        child: const Icon(Icons.format_quote),
      ),
    );
  }
}

// Виджет списка цитат
class QuoteList extends StatelessWidget {
  final List<Quote> quotes;
  const QuoteList({super.key, required this.quotes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: quotes.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            quotes[index].text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          subtitle: Text('- ${quotes[index].author}'),
        );
      },
    );
  }
}

// Виджет сообщения "нет цитат"
class NoQuotesMessage extends StatelessWidget {
  const NoQuotesMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Нет добавленных цитат. Добавь первую!',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18, color: Colors.grey),
    );
  }
}

// Виджет счетчика цитат
class QuoteCounter extends StatelessWidget {
  final int count;
  const QuoteCounter({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.7),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.black.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Text(
          'Количество цитат: $count',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
    );
  }
}

// Диалоговое окно добавления цитаты
class AddQuoteDialog extends StatelessWidget {
  const AddQuoteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController quoteController = TextEditingController();
    final TextEditingController authorController = TextEditingController();

    return AlertDialog(
      title: const Text('Добавить цитату'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: quoteController,
            decoration: const InputDecoration(labelText: 'Цитата'),
          ),
          TextField(
            controller: authorController,
            decoration: const InputDecoration(labelText: 'Автор'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop({
            'quote': quoteController.text,
            'author': authorController.text,
          }),
          child: const Text('Добавить'),
        ),
      ],
    );
  }
}

// Расширение для форматирования текста
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
