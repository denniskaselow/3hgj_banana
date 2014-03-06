part of shared;


class PlayerActionSystem extends EntityProcessingSystem {
  ComponentMapper<AngleInput> am;
  ComponentMapper<VelocityInput> vm;
  ComponentMapper<Player> pm;
  ComponentMapper<Transform> tm;

  PlayerActionSystem() : super(Aspect.getAspectForAllOf([Player, AngleInput, VelocityInput, Transform]));


  @override
  void processEntity(Entity entity) {
    var a = am.get(entity);
    var v = vm.get(entity);
    if (a.done && v.done) {
      var p = pm.get(entity);
      var t = tm.get(entity);
      world.createAndAddEntity([new Transform(p.id == 0 ? t.pos.x - 15 : t.pos.x + 15, t.pos.y - 5),
                                new Player(p.id),
                                new Velocity(a.angle, v.velocity)]);
      entity.removeComponent(AngleInput);
      entity.removeComponent(VelocityInput);
      entity.changedInWorld();
      currentPlayer = (p.id + 1) % 2;
    }
  }
}

class MovementSystem extends EntityProcessingSystem {
  ComponentMapper<Transform> tm;
  ComponentMapper<Velocity> vm;
  MovementSystem() : super(Aspect.getAspectForAllOf([Transform, Velocity]));

  @override
  void processEntity(Entity entity) {
    var v = vm.get(entity);
    var t = tm.get(entity);
    t.pos += v.velocity;
  }
}

class GravitySystem extends EntityProcessingSystem {
  ComponentMapper<Velocity> vm;
  GravitySystem() : super(Aspect.getAspectForAllOf([Velocity]));

  @override
  void processEntity(Entity entity) {
    vm.get(entity).velocity.y += 0.1;
  }
}