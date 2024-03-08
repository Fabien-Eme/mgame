import 'dart:async';

import 'package:flame/components.dart';

class TileHolder extends Component with HasGameReference, IgnoreEvents {
  List<Component> listComponent;

  TileHolder(this.listComponent);

  @override
  FutureOr<void> onLoad() async {
    priority = 10;
    await addAll([...listComponent]);

    return super.onLoad();
  }
}
