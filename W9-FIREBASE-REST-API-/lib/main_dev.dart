import 'package:provider/provider.dart';
import 'package:w9_firebase/data/repositories/artists/artist_repository.dart';
import 'package:w9_firebase/data/repositories/artists/artist_repository_firebase.dart';
import 'package:w9_firebase/data/repositories/songwithartist/song_with_artist_repository.dart';
import 'package:w9_firebase/data/repositories/songwithartist/song_with_artist_repository_firebase.dart';
 
import 'data/repositories/songs/song_repository_firebase.dart';
import 'main_common.dart';
import 'data/repositories/settings/app_settings_repository_mock.dart';
import 'data/repositories/songs/song_repository.dart';
import 'ui/states/player_state.dart';
import 'ui/states/settings_state.dart';

/// Configure provider dependencies for dev environment
List<InheritedProvider> get devProviders {
  final appSettingsRepository = AppSettingsRepositoryMock();

  return [
 
    // 1 - Inject the song repository
    Provider<SongRepository>(create: (_) => SongRepositoryFirebase()),

    // 2 - Inject the player state
    ChangeNotifierProvider<PlayerState>(create: (_) => PlayerState()),

    // 3 - Inject the  app setting state
    ChangeNotifierProvider<AppSettingsState>(
      create: (_) => AppSettingsState(repository: appSettingsRepository),
    ),
    // inject the repo Artist
    Provider<ArtistRepository>(create: (_) => ArtistRepositoryFirebase()),

    Provider<SongWithArtistRepository>(create: (_) => SongWithArtistRepositoryFirebase()),
  ];
}

void main() {
  mainCommon(devProviders);
}
