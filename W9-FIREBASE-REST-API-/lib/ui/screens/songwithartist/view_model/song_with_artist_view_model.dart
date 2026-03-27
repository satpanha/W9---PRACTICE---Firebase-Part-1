import 'package:flutter/material.dart';
import 'package:w9_firebase/data/repositories/songwithartist/song_with_artist_repository.dart';
import 'package:w9_firebase/model/songwithartist.dart/song_artist.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';

class SongWithArtistViewModel extends ChangeNotifier {
  final SongWithArtistRepository songartistRepository;
  final PlayerState playerState;

  AsyncValue<List<SongArtist>> songsValue = AsyncValue.loading();

 SongWithArtistViewModel({required this.songartistRepository, required this.playerState}) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    fetchSongArtist();
  }

  void fetchSongArtist() async {
    // 1- Loading state
    songsValue = AsyncValue.loading();
    notifyListeners();

    try {
      // 2- Fetch is successfull
      List<SongArtist> songs = await songartistRepository.fetchSongswithArtist();
      songsValue = AsyncValue.success(songs);
    } catch (e) {
      // 3- Fetch is unsucessfull
      songsValue = AsyncValue.error(e);
    }
     notifyListeners();

  }

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  
  void stop(Song song) => playerState.stop();
}
