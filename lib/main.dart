import 'dart:io';

import 'package:dino_run/pixel_adventure.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';

void main() async{
 
  WidgetsFlutterBinding.ensureInitialized();
 await Flame.device.fullScreen();
 await Flame.device.setLandscape();


  PixelAdventure game =PixelAdventure();
  runApp(GameWidget(game: kDebugMode ? PixelAdventure() : game));
}

