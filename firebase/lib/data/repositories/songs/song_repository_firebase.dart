import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:w9_firebase/data/dtos/artist_dto.dart';
import 'package:w9_firebase/model/artists/artist.dart';

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  static final Uri baseUrl = Uri.https(
    'songdb-89a59-default-rtdb.asia-southeast1.firebasedatabase.app',
  );
  static Uri songUrl = baseUrl.replace(path: '/songs.json');
  static Uri artistUrl = baseUrl.replace(path: '/artists.json');

  @override
  Future<List<Song>> fetchSongs() async {
    final responses = await Future.wait([
      http.get(songUrl),
      http.get(artistUrl),
    ]);

    if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> artistJson = json.decode(responses[1].body);
      Map<String, Artist> artistMap = {};
      for (var entry in artistJson.entries) {
        artistMap[entry.key] = ArtistDto.fromJson(entry.key, entry.value);
      }

      Map<String, dynamic> songJson = json.decode(responses[0].body);
      final List<Song> result = [];
      for (var it in songJson.entries) {
        String id = it.key;
        Map<String, dynamic> value = it.value;
        Artist? artist = artistMap[value[SongDto.artistIdKey]];
        Song song = SongDto.fromJson(
          id,
          value,
          artistName: artist?.name ?? 'Unknown',
          artistGenre: artist?.genre ?? 'Unknown',
        );
        result.add(song);
      }
      return result;
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async => null;
}
