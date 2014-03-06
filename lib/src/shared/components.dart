part of shared;


class Transform extends Component {
  Vector2 pos;
  Transform(num x, num y) : pos = new Vector2(x.toDouble(), y.toDouble());
}

class Player extends Component {
  int id;
  Player(this.id);
}

class Building extends Component {
  int height;
  int hue;
  Building(this.height, this.hue);
}

class AngleInput extends Component {
  int angle;
  bool done = false;
}

class VelocityInput extends Component {
  int velocity;
  bool done = false;
}

class Velocity extends Component {
  Vector2 velocity;
  Velocity(int deg, int velocity) {
    var rad = 0.0174532925 * (deg + 90);
    this.velocity = new Vector2(sin(rad) * velocity * 0.1, cos(rad) * velocity * 0.1);
  }
}

class Renderable extends Component {
  String sprite;
  Renderable(this.sprite);
}