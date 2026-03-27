class Artist {
  final String id;
  final String genre;
  final String name;
  final Uri? imageUrl;

  Artist({required this.id, required this.genre, required this.name,  this.imageUrl});

  @override
  String toString() {
    
    return "Artist(id: $id , genre: $genre, name: $name, imageUrl: $imageUrl)";
  }
}