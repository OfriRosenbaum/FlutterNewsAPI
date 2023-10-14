import 'package:json_annotation/json_annotation.dart';

part 'news_card.g.dart';

@JsonSerializable()
class NewsCard {
  final String? title;
  final String? author;
  final String? description;
  final String? content;
  final String? urlToImage;
  final String? url;

  const NewsCard({
    required this.title,
    required this.author,
    required this.description,
    required this.content,
    this.urlToImage,
    this.url,
  });

  factory NewsCard.fromJson(Map<String, dynamic> json) => _$NewsCardFromJson(json);

  Map<String, dynamic> toJson() => _$NewsCardToJson(this);
}
