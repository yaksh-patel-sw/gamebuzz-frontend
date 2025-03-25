class Game {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> screenshots;

  Game({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.screenshots,
  });

  // Factory method to create an instance of Game from JSON
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['_id'] ?? '', // Default to empty string if null
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      screenshots: json['screenshots'] != null
          ? List<String>.from(json['screenshots']) // Ensure List<String> conversion
          : [], // Default to an empty list if null
    );
  }

  // Convert the object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'screenshots': screenshots,
    };
  }
}
