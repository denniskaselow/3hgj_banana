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