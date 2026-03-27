import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:w9_firebase/data/repositories/songwithartist/song_with_artist_repository.dart';
import 'package:w9_firebase/ui/screens/songwithartist/view_model/song_with_artist_view_model.dart';
import 'package:w9_firebase/ui/screens/songwithartist/widgets/song_with_artist_content.dart';
import 'package:w9_firebase/ui/states/player_state.dart';

class SongWithArtistScreen extends StatelessWidget{
  const SongWithArtistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SongWithArtistViewModel(
        playerState: context.read<PlayerState>(),
        songartistRepository: context.read<SongWithArtistRepository>(),
      ),
      child: SongWithArtistContent(),
    );
  }
}
