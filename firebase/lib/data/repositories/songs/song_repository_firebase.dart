import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  static final Uri baseUrl = Uri.https(
    'songdb-89a59-default-rtdb.asia-southeast1.firebasedatabase.app',
  );
  static Uri songUrl = baseUrl.replace(path: '/songs.json');

  @override
  Future<List<Song>> fetchSongs() async {
    final http.Response response = await http.get(songUrl);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);
      final List<Song> result = [];
      for (var it in songJson.entries) {
        String id = it.key;
        Map<String, dynamic> value = it.value;
        Song song = SongDto.fromJson(id, value);
        result.add(song);
      }
      return result;
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {}
}
