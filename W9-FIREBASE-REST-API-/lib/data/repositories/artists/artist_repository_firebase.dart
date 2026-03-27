
import 'package:w9_firebase/data/dtos/artist_dto.dart';
import 'package:w9_firebase/data/repositories/artists/artist_repository.dart';
import 'package:w9_firebase/model/artists/artist.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ArtistRepositoryFirebase extends ArtistRepository{
  static final Uri baseUrl = Uri.https('songdb-89a59-default-rtdb.asia-southeast1.firebasedatabase.app');
  static Uri artistUrl = baseUrl.replace(path: '/artists.json');

  @override
  Future<List<Artist>> fetchArtists() async {
    final http.Response response = await http.get(artistUrl);

    if(response.statusCode == 200){
      // convert the string from api to Map object
      Map<String, dynamic> artistJson = json.decode(response.body);

      final List<Artist> result = []; // store the final result data

      for(var art in artistJson.entries){  // loop to get id and data from 
        String id = art.key;
        Map<String, dynamic> value = art.value;
        Artist artist = ArtistDto.fromJson(id, value); // convert json to artist object
        result.add(artist);
      }
      return result;

    } else{
      throw Exception("failed to load");
    }
  }
}