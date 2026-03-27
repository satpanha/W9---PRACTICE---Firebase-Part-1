class Song {
  final String id;
  final String title;
  final String artistId;
  final Duration duration;
  final Uri imageUrl;
  final String artistGenre;
  final String artistName;

  Song({
    required this.id,
    required this.title,
    required this.artistId,
    required this.duration,
    required this.imageUrl, required this.artistGenre, required this.artistName,
  });

  @override
  String toString() {
    return "Song(id : $id ,title: $title, artistId: $artistId, duration: $duration, imageUrl: $imageUrl )";
  }
}
