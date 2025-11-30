import 'dart:async';
import 'dart:ui';

import 'package:dino_run/components/player.dart';
import 'package:dino_run/components/level.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class PixelAdventure extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks ,HasCollisionDetection{
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late  CameraComponent cam;
  Player player = Player(character: 'Virtual Guy');
  late JoystickComponent joyStick;
  bool showJoyStick = false;
  List<String> levelNames =['Level-01','Level-02'];
  int currentLevelIndex=0;

  @override
  FutureOr<void> onLoad() async {
    // Load all images first
    await images.loadAllImages();

    // Create the world/level
    _loadLevel();

    // Add joystick if needed
    if (showJoyStick) {
      addJoyStick();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoyStick) {
      updateJoystick();
    }

    super.update(dt);
  }

  void addJoyStick() {
    joyStick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      knobRadius: 32,
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/JoyStick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    add(joyStick);
  }

  void updateJoystick() {
    switch (joyStick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }
   
   void loadNextLevel(){
    if(currentLevelIndex < levelNames.length -1){
      currentLevelIndex++;
      _loadLevel();
    }else{

    }
   }


  void _loadLevel() {
    Future.delayed(const Duration(seconds: 1,),(){
 
    Level world = Level(
      levelName: levelNames[currentLevelIndex],
      player: player,
    );

    // Setup camera
    cam = CameraComponent.withFixedResolution(
      width: 640,
      height: 360,
      world: world,
    );
    cam.viewfinder.anchor = Anchor.topLeft;

    // Add camera and world to game
    addAll([cam, world]);

    });
   
  }
}