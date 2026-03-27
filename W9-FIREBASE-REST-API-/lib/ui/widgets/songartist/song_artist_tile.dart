import 'package:flutter/material.dart';

import 'package:w9_firebase/model/songwithartist.dart/song_artist.dart';



class SongArtistTile extends StatelessWidget {
  const SongArtistTile({
    super.key,
    required this.songArtist,
    
    required this.onTap,
  });

  final SongArtist songArtist;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
        ),
        child: ListTile(
          subtitle: Text(songArtist.artist.name),
          leading: CircleAvatar(foregroundImage: NetworkImage(songArtist.song.imageUrl.toString()),),
          onTap: onTap,
          title: Text(songArtist.song.title),
          

        ),
      ),
    );
  }
}
