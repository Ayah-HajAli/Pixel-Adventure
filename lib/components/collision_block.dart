import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  bool isPlaform;
  
  CollisionBlock({
    position,
    size,
    this.isPlaform = false,
  }) : super(
    position: position,
    size: size
  ) {
    //debugMode = true;
  }
  


  double get x => position.x;
  double get y => position.y;
}