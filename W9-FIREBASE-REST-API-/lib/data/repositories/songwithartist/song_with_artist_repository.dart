
import 'package:w9_firebase/model/songwithartist.dart/song_artist.dart';

abstract class SongWithArtistRepository {

   Future<List<SongArtist>> fetchSongswithArtist();
}