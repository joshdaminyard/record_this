class Album {
  final String id;
  final String title;
  final String artist;
  final String albumArt;
  final String genre;
  final String releaseYear;
  final String label;

  const Album({
    required this.id,
    required this.title,
    required this.artist,
    required this.genre,
    required this.albumArt,
    required this.releaseYear,
    required this.label,
  });

  Album.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        title = json['title'] as String,
        artist = json['title'] as String,
        albumArt = json['cover_image'] as String,
        genre = json['genre'][0] as String,
        releaseYear = json['year'] as String,
        label = json['label'][0] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'artist': artist,
        'genre': genre,
        'albumArt': albumArt,
        'releaseYear': releaseYear,
        'label': label,
      };

  // factory Album.fromJson(Map<String, dynamic> json) {
  //   return switch (json) {
  //     {
  //       'id': String id,
  //       'title': String title,
  //       'artist': String artist,
  //       'genre': String genre,
  //       'albumArt': String albumArt,
  //       'releaseYear': String releaseYear,
  //       'label': String label,
  //     } =>
  //       Album(
  //         id: id,
  //         title: title,
  //         artist: artist,
  //         genre: genre,
  //         albumArt: albumArt,
  //         releaseYear: releaseYear,
  //         label: label,
  //       ),
  //     _ => throw const FormatException('Failed to load album.'),
  //   };
  // }
}
