import 'dart:async';

import 'package:dino_run/components/background_tile.dart';
import 'package:dino_run/components/checkpoint.dart';
import 'package:dino_run/components/collision_block.dart';
import 'package:dino_run/components/fruit.dart';
import 'package:dino_run/components/player.dart';
import 'package:dino_run/components/saw.dart';
import 'package:dino_run/pixel_adventure.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World with HasGameRef<PixelAdventure> {
  final String levelName;
  final Player player;
  Level({required this.levelName, required this.player});
  late TiledComponent level;
  List<CollisionBlock> collisionsBlock = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);

    _scrollingBackground();
    _spawningObject();
    _addCollisions();

    return super.onLoad();
  }

  void _scrollingBackground() {
    final backgroundLayer = level.tileMap.getLayer('Background');
    const tileSize = 64;

    final numTilesY = (game.size.y / tileSize).floor();
    final numTilesX = (game.size.x / tileSize).floor();

    if (backgroundLayer != null) {
      final backgroundColor = backgroundLayer.properties.getValue('BackgroundColor');

      for (double y = 0; y < game.size.y / numTilesY; y++) {
        for (double x = 0; x < numTilesX; x++) {
          final backgroundTile = BackgroundTile(
            color: backgroundColor ?? 'Gray',
            position: Vector2(x * tileSize, y * tileSize - tileSize),
          );

          add(backgroundTile);
        }
      }
    }
  }

  void _spawningObject() {
    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if (spawnPointLayer != null) {
      for (final Spawnpoint in spawnPointLayer.objects) {
        switch (Spawnpoint.class_) {
          case 'Player':
            player.position = Vector2(Spawnpoint.x, Spawnpoint.y);
            player.scale.x = 1;
            add(player);
            break;

          case 'Fruit':
            final fruit = Fruit(
              fruit: Spawnpoint.name,
              position: Vector2(Spawnpoint.x, Spawnpoint.y),
              size: Vector2(Spawnpoint.width, Spawnpoint.height),
            );
            add(fruit);
            break;

            case 'Saw' :
            final isVertical=Spawnpoint.properties.getValue('isVertical');
            final offNeg=Spawnpoint.properties.getValue('offNeg');
            final offPos=Spawnpoint.properties.getValue('offPos');
            final saw = Saw(
              isVertical: isVertical,
              offNeg: offNeg,
              offPos: offPos,
              position: Vector2(Spawnpoint.x, Spawnpoint.y),
              size: Vector2(Spawnpoint.width, Spawnpoint.height),
            ); 
            add(saw);
            break;

            case 'Checkpoint':
            final checkpoint = Checkpoint(

              position: Vector2(Spawnpoint.x, Spawnpoint.y),
              size: Vector2(Spawnpoint.width, Spawnpoint.height),

            );
            add(checkpoint);
            break;
          default:
        }
      }
    }
  }

  void _addCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');
    
    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlaform: true,
            );
            collisionsBlock.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionsBlock.add(block);
            add(block);
        }
      }
    }

    player.collisionBlocks = collisionsBlock;
  }
}