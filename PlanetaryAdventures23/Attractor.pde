class Attractor {
  PVector position ;
  float mass ;
  String name = "Attractor";

  Attractor(PVector _position, float _mass) {
    this.position = _position.copy();
    this.mass = _mass;
  }

  Attractor() {
    this.position = new PVector(0,0);
    this.mass = 2000;
  }

  void show() {
    pushStyle();
      noStroke();
      fill(233, 63, 21, 250);
      ellipse(this.position.x, this.position.y, 100, 100);
    popStyle();
  }
}
