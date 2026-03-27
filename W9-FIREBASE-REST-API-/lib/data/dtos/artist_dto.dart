
import 'package:w9_firebase/model/artists/artist.dart';


class ArtistDto{
  static const String title = "genre";
  static const String nameArtist = "name";
  static const String imageUrl = "imageUrl";

// get the song from json convert into artist object
  static Artist fromJson(String id, Map<String, dynamic> json){
    assert(json[title] is String);
    assert(json[nameArtist] is String);
    assert(json[imageUrl] is String);

    return Artist(
      id: id,
      genre: json[title], 
      name: json[nameArtist], 
      imageUrl: Uri.parse(json[imageUrl])
      );
  }

  Map<String, dynamic> toJson(Artist artist){
    return{
      title: artist.genre,
      nameArtist: artist.name,
      imageUrl: artist.imageUrl.toString()
     };
  }
}