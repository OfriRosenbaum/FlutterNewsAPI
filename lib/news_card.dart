class NewsCard {
  final String title;
  final String author;
  final String description;
  final String content;
  final String? imageUrl;

  const NewsCard({
    required this.title,
    required this.author,
    required this.description,
    required this.content,
    this.imageUrl,
  });
}
