import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart' hide Timer;
import 'package:flame/particles.dart';
import 'package:flutter/animation.dart';
import 'package:mgame/flame_game/level_world.dart';

import '../../gen/assets.gen.dart';
import '../game.dart';

class TruckSmoke extends PositionComponent with HasGameReference<MGame>, HasWorldReference<LevelWorld>, IgnoreEvents {
  final int rate;
  TruckSmoke({required this.rate});

  late Timer? spawnSmokeTimer;
  final Random rng = Random();

  @override
  void onMount() {
    spawnParticles();
    spawnSmokeTimer = Timer.periodic(Duration(milliseconds: Random().nextInt((5000 / rate).round()) + 200), (_) {
      spawnParticles();
    });
    super.onMount();
  }

  void spawnParticles() {
    world.add(ParticleSystemComponent(
        priority: 1000,
        particle: Particle.generate(
            lifespan: 7,
            count: rng.nextInt(5),
            generator: (i) {
              return MovingParticle(
                  from: position - Vector2(20, 0),
                  to: position + Vector2(rng.nextDouble() * 100, rng.nextDouble() * -150 - 100),
                  // to: Vector2(Random().nextDouble() * -40 - 40, Random().nextDouble() * -100 - 100),
                  curve: Curves.easeInQuad,
                  child: ScalingParticle(
                    to: 5,
                    child: SpriteParticle(
                      sprite: Sprite(game.images.fromCache(Assets.images.pollution.smoke.path)),
                      size: Vector2.all(rng.nextDouble() * 10 + 5),
                      overridePaint: Paint()..filterQuality = FilterQuality.none,
                    ),
                  ));
            })));
  }

  @override
  void onRemove() {
    super.onRemove();
    spawnSmokeTimer?.cancel();
  }
}
