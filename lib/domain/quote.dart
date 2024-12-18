class Quote {
  final String text;
  final String author;
  final String imagePath;
  final String id;
  bool isFavorite;

  Quote(this.text, this.author, this.imagePath, this.id,[this.isFavorite = false]);

  bool toggleFavorite() {
    isFavorite = !isFavorite;
    return isFavorite;
  }
}
