const List<Song> songs = [
  Song('ambiance/Forestal.mp3', 'Forestal', artist: 'Liborio Conti'),
  Song('ambiance/Aurora.mp3', 'Aurora', artist: 'Liborio Conti'),
  Song('ambiance/Cinematic_Space.mp3', 'Cinematic Space', artist: 'Liborio Conti'),
  Song('ambiance/Exploration.mp3', 'Exploration', artist: 'Liborio Conti'),
  Song('ambiance/Nature_Call.mp3', 'Nature Call', artist: 'Liborio Conti'),
  Song('ambiance/Panorama.mp3', 'Panorama', artist: 'Liborio Conti'),
  Song('ambiance/Space_Pack.mp3', 'Space Pack', artist: 'Liborio Conti'),
  Song('ambiance/Timeless.mp3', 'Timeless', artist: 'Liborio Conti'),
];

class Song {
  final String filename;

  final String name;

  final String? artist;

  const Song(this.filename, this.name, {this.artist});

  @override
  String toString() => 'Song<$filename>';
}
