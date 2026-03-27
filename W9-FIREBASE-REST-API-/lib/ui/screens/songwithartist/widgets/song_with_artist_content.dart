
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:w9_firebase/model/songwithartist.dart/song_artist.dart';
import 'package:w9_firebase/ui/screens/songwithartist/view_model/song_with_artist_view_model.dart';
import 'package:w9_firebase/ui/widgets/songartist/song_artist_tile.dart';
import '../../../theme/theme.dart';
import '../../../utils/async_value.dart';


class SongWithArtistContent extends StatelessWidget {
  const SongWithArtistContent({super.key});

  @override
  Widget build(BuildContext context) {
    // 1- Read the globbal song repository
    SongWithArtistViewModel mv = context.watch<SongWithArtistViewModel>();

    AsyncValue<List<SongArtist>> asyncValue = mv.songsValue;

    Widget content;
    switch (asyncValue.state) {
      
      case AsyncValueState.loading:
        content = Center(child: CircularProgressIndicator());
        break;
      case AsyncValueState.error:
        content = Center(child: Text('error = ${asyncValue.error!}', style: TextStyle(color: Colors.red),));

      case AsyncValueState.success:
        List<SongArtist> songartist = asyncValue.data!;
        content = ListView.builder(
          itemCount: songartist.length,
          itemBuilder: (context, index) => SongArtistTile(
            songArtist: songartist[index],
            // isPlaying: mv.isSongPlaying(songartist[index]),
            onTap: () {
             
            },
          ),
        );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Text("Library", style: AppTextStyles.heading),
          SizedBox(height: 50),

          Expanded(child: content),
        ],
      ),
    );
  }
}
