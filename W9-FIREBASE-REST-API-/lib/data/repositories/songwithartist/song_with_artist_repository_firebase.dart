import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:w9_firebase/data/repositories/songwithartist/song_with_artist_repository.dart';
import 'package:w9_firebase/model/artists/artist.dart';
import 'package:w9_firebase/model/songs/song.dart';
import 'package:w9_firebase/model/songwithartist.dart/song_artist.dart';

class SongWithArtistRepositoryFirebase extends SongWithArtistRepository {
  static final Uri baseUrl = Uri.https(
    'songdb-89a59-default-rtdb.asia-southeast1.firebasedatabase.app',
  );
  static Uri songUrl = baseUrl.replace(path: '/songs.json');
  static Uri artistUrl = baseUrl.replace(path: '/artists.json');
  @override
  Future<List<SongArtist>> fetchSongswithArtist() async {
    final http.Response responseSong = await http.get(songUrl);
    final http.Response responseArtist = await http.get(artistUrl);

    if (responseSong.statusCode == 200 && responseArtist.statusCode == 200) {
      Map<String, dynamic> songJson = json.decode(
        responseSong.body,
      ); // convert the text string in json to map object
      Map<String, dynamic> artistJson = json.decode(
        responseArtist.body,
      ); // convert the text string in json to map object

      final List<SongArtist> songart = []; // store the result

      songJson.forEach((songId, songValue) {
        // loop into songJson to join
        final artistId = songValue['artistId']; // get the artistId in song
        final artistValue =
            artistJson[artistId]; // store the artistId in song that matching in the artistValue to join
        if (artistValue != null) {
          songart.add(
            SongArtist(
              song: Song(
                id: songId,
                title: songValue['title'],
                artistId: songValue['artistId'],
                duration: Duration(milliseconds: songValue['duration']),
                imageUrl: Uri.parse(songValue['imageUrl']),
              ),
              artist: Artist(
                id: artistId,
                name: artistValue['name'],
                genre: artistValue['genre'],
              ),
            ),
          );
        }
      });
      return songart;
    } else {
      throw Exception("cannot load");
    }
  }
}
