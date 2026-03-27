import 'package:flutter/material.dart';
import 'package:w9_firebase/model/artists/artist.dart';



class ArtistTile extends StatelessWidget {
  const ArtistTile({
    super.key,
    required this.artist,
    
  });

  final Artist artist;
 

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
          subtitle: Text(artist.genre),
          leading: CircleAvatar(foregroundImage: NetworkImage(artist.imageUrl.toString()),),
          title: Text(artist.name),

        ),
      ),
    );
  }
}
