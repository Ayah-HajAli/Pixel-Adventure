import 'dart:async';

import 'package:dino_run/components/custom_hitbox.dart';
import 'package:dino_run/pixel_adventure.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Fruit extends SpriteAnimationComponent with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final String fruit;
  
  Fruit({
    this.fruit = 'Apple',
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );
  
  bool _collected = false;
  final double stepTime = 0.05;
  final hitbox = CustomHitbox(offSetX: 10, offSetY: 10, width: 12, height: 12);
  
  @override
  FutureOr<void> onLoad() {
    priority = -1;
    // debugMode = true;

    add(RectangleHitbox(
      position: Vector2(hitbox.offSetX, hitbox.offSetY),
      size: Vector2(hitbox.width, hitbox.height),
      collisionType: CollisionType.passive,
    ));
    
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Fruits/$fruit.png'),
      SpriteAnimationData.sequenced(
        amount: 17,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
    
    return super.onLoad();
  }
  
  void collidedWithPlayer() {
    if (!_collected) {
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Fruits/Collected.png'),
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
          loop: false,
        ),
      );

      _collected = true;
    }
    
    // Fixed: Changed from microseconds to milliseconds
    Future.delayed(const Duration(milliseconds: 400), () => removeFromParent());
  }
}