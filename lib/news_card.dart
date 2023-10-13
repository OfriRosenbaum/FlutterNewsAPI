import 'package:flutter/material.dart';
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

  Widget showNewsCard(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.width;
    Widget image;
    if (urlToImage != null) {
      try {
        image = Image.network(
          urlToImage!,
          width: screenWidth * 0.5,
          height: screenHeight * 0.5,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: screenWidth * 0.5),
        );
      } catch (e) {
        image = Icon(Icons.image_not_supported, size: screenWidth * 0.5);
      }
    } else {
      image = Icon(Icons.image_not_supported, size: screenWidth * 0.5);
    }
    return Card(
      color: Colors.lightBlue,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            image,
            Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
              child: ListTile(
                title: Center(child: Text(title ?? 'No title')),
                subtitle: Center(child: Text(author ?? 'No author')),
              ),
            ),
            Text(description ?? 'No description'),
          ],
        ),
      ),
    );
  }
}
