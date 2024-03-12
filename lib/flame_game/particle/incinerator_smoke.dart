import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart' hide Timer;
import 'package:flame/particles.dart';
import 'package:flutter/animation.dart';
import 'package:mgame/flame_game/level_world.dart';

import '../../gen/assets.gen.dart';
import '../game.dart';

class IncineratorSmoke extends PositionComponent with HasGameReference<MGame>, HasWorldReference<LevelWorld>, IgnoreEvents {
  final int rate;
  IncineratorSmoke({required this.rate});

  Timer? spawnSmokeTimer;
  final Random rng = Random();

  void spawnParticles() {
    world.add(ParticleSystemComponent(
        priority: 1000,
        particle: Particle.generate(
            lifespan: 5,
            count: rng.nextInt(5),
            generator: (i) {
              return MovingParticle(
                  from: position - Vector2(20, 0),
                  to: position + Vector2(rng.nextDouble() * 100, rng.nextDouble() * -100 - 200),
                  curve: Curves.easeInQuad,
                  child: ScalingParticle(
                    to: 3,
                    child: SpriteParticle(
                      sprite: Sprite(game.images.fromCache(Assets.images.pollution.smoke.path)),
                      size: Vector2.all(rng.nextDouble() * 20 + 20),
                      overridePaint: Paint()..filterQuality = FilterQuality.none,
                    ),
                  ));
            })));
  }

  void stopSmoke() {
    spawnSmokeTimer?.cancel();
  }

  void resumeSmoke() {
    if (!(spawnSmokeTimer?.isActive ?? false)) {
      spawnSmokeTimer = Timer.periodic(Duration(milliseconds: Random().nextInt((5000 / rate).round()) + 200), (_) {
        spawnParticles();
      });
    }
  }

  void resumeSmokeForDuration(Duration duration) {
    if (!(spawnSmokeTimer?.isActive ?? false)) {
      spawnSmokeTimer = Timer.periodic(Duration(milliseconds: Random().nextInt((5000 / rate).round()) + 200), (_) {
        spawnParticles();
      });
      Future.delayed(duration).then((_) => stopSmoke());
    }
  }

  @override
  void onRemove() {
    super.onRemove();
    spawnSmokeTimer?.cancel();
  }
}
