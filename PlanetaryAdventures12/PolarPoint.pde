class PolarPoint {
  float radius;
  float angle;

  PolarPoint(float _radius, float _angle) {
    this.radius = _radius;
    this.angle = _angle;
  }

  PolarPoint(PVector cartesianPoint) {
    this.angle  = atan(cartesianPoint.y/cartesianPoint.x);
    this.radius = PVector.dist(cartesianPoint, new PVector(0, 0));
  }

  float getRadius() {
    return this.radius;
  }

  float geAngle() {
    return this.angle;
  }

  PVector getCartesian() {
    float x = this.radius*cos(this.angle);
    float y = this.radius*sin(this.angle);
    return new PVector(x, y);
  }
  
  void rotatePoint(float _angle){
    this.angle += _angle;
  }
}
