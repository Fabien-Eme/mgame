import 'package:flame/components.dart';
import 'package:mgame/flame_game/ui/snackbar.dart';

import '../game.dart';
import '../level_world.dart';

class SnackbarController extends Component with HasGameReference<MGame>, HasWorldReference<LevelWorld> {
  Map<int, bool> mapRankSnackBarAvailable = {0: true, 1: true, 2: true, 3: true, 4: true};
  List<SnackBar> listSnackBar = [];
  bool hide;

  SnackbarController({this.hide = false});

  void addSnackbar({required SnackbarType snackbarType}) {
    if (hide) return;

    int? firstAvailableRank = getAvailableRank();
    if (firstAvailableRank != null) {
      mapRankSnackBarAvailable[firstAvailableRank] = false;

      SnackBar snackBar = SnackBar(
        snackbarType: snackbarType,
        rank: firstAvailableRank,
        callback: () => removeFirstSnackBar(),
      );
      listSnackBar.add(snackBar);
      add(snackBar);
    } else {
      removeFirstSnackBar();
      addSnackbar(snackbarType: snackbarType);
    }
  }

  int? getAvailableRank() {
    for (final entry in mapRankSnackBarAvailable.entries) {
      if (entry.value) return entry.key;
    }
    return null;
  }

  void removeFirstSnackBar() {
    remove(listSnackBar.first);
    mapRankSnackBarAvailable[0] = true;

    int i = 0;
    for (SnackBar snackbar in listSnackBar) {
      if (i != 0) {
        mapRankSnackBarAvailable[i] = true;
        mapRankSnackBarAvailable[i - 1] = false;
        snackbar.updateRank(i - 1);
      }

      i++;
    }
    listSnackBar.removeAt(0);
  }
}
