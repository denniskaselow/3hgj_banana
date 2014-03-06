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
                                new Velocity(a.angle, v.velocity),
                                new Renderable('banana.png')]);
      a.done = false;
      a.angle = null;
      v.done = false;
      v.velocity = null;
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

class CollisionSystem extends EntitySystem {
  ComponentMapper<Transform> tm;
  ComponentMapper<Player> pm;

  CollisionSystem() : super(Aspect.getAspectForAllOf([Transform, Player]));

  @override
  void processEntities(ReadOnlyBag<Entity> entitiesInBag) {
    var entities = new List<Entity>();
    entitiesInBag.forEach((entity) => entities.add(entity));

    for (int i = 0; i < entities.length - 1; i++) {
      var entity1 = entities[i];
      var t1 = tm.get(entity1);
      var r1 = pm.get(entity1);
      for (int j = i + 1; j < entities.length; j++) {
        var entity2 = entities[j];
        var t2 = tm.get(entity2);
        var r2 = pm.get(entity2);
        if (t2.pos.distanceToSquared(t1.pos) < 100) {
          entity1.deleteFromWorld();
          entity2.deleteFromWorld();
        }
      }
    }
  }

  @override
  bool checkProcessing() => true;
}