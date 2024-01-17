// Sounds from Pixabay

List<String> soundTypeToFilename(SfxType type) {
  switch (type) {
    case SfxType.buttonTap:
      return const [
        'menu_button.mp3',
      ];
    case SfxType.clickPlay:
      return const [
        'click_play.mp3',
      ];
  }
}

/// Allows control over loudness of different SFX types.
double soundTypeToVolume(SfxType type) {
  switch (type) {
    case SfxType.clickPlay:
    case SfxType.buttonTap:
      return 1.0;
  }
}

enum SfxType {
  buttonTap,
  clickPlay,
}
