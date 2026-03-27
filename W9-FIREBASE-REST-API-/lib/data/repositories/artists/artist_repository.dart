
import 'package:w9_firebase/model/artists/artist.dart';

abstract class ArtistRepository {

  Future<List<Artist>> fetchArtists();
}