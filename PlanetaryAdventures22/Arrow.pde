
public class Arrow {
  PVector anchor = null;
  PVector head = null;
  PVector body = null;

  color arrowLineColor ;
  color arrowHeadColor ;
  float arrowHeadSize = 15;
  float arrowHeadAngle = 160;
  PShape arrowHead;

  boolean stylizedHead = false;

  Arrow(PVector _anchor, PVector _body) {
    this.anchor = _anchor.copy();
    this.body = _body.copy();
    this.head = PVector.add(this.anchor, this.body);
    this.arrowLineColor = color(100, 50, 200, 255);
    this.arrowHeadColor = color(255, 100, 50);
  }

  Arrow(float x1, float y1, float x2, float y2) {
    this.anchor = new PVector(x1, y1);
    this.head = new PVector(x2, y2);
    this.body = PVector.sub(this.head, this.anchor);
    this.arrowLineColor = color(100, 50, 200, 255);
    this.arrowHeadColor = color(255, 100, 50);
  }


  void setArrow(float x1, float y1, float x2, float y2) {
    this.anchor = new PVector(x1, y1);
    this.head = new PVector(x2, y2);
    this.body = PVector.sub(this.head, this.anchor);
  }

  void setArrow(PVector _anchor, PVector _body) {
    this.anchor = _anchor.copy();
    this.body = _body;
    this.head = PVector.add(this.anchor, this.body);
  }

  void setAnchor(float x1, float y1) {
    this.anchor = new PVector(x1, y1);
    this.body = PVector.sub(this.head, this.anchor);
  }

  void setBody(float x1, float y1) {
    this.body = new PVector(x1, y1);
    this.head = PVector.add(this.body, this.anchor);
  }

  void show() {
    drawArrow(this.anchor.x, this.anchor.y, this.head.x, this.head.y);
  }


  private void drawArrow(float x1, float y1, float x2, float y2) {
    pushMatrix();
    pushStyle();
    stroke(this.arrowLineColor);
    strokeWeight(1);
    fill(200, 0, 50, 255);

    //Drawing the arrow head;
    float dX = x2 - x1; 
    float dY = y2 - y1;
    float theta = atan2(dY, dX);
    line(x1, y1, x2, y2);

    float leftX = x2+this.arrowHeadSize*cos(theta-radians(this.arrowHeadAngle)), leftY = y2+this.arrowHeadSize*sin(theta-radians(this.arrowHeadAngle));
    float rightX = x2+this.arrowHeadSize*cos(theta+radians(this.arrowHeadAngle)), rightY = y2+this.arrowHeadSize*sin(theta+radians(this.arrowHeadAngle));
    if (stylizedHead) {
      //Too Slow Eating up CPU Time! Perhaps may be feasible in Quasi Static Programs
      this.arrowHead = createShape();
      this.arrowHead.setFill(true);
      this.arrowHead.beginShape();
      this.arrowHead.fill(this.arrowHeadColor);
      this.arrowHead.stroke(this.arrowHeadColor);
      this.arrowHead.vertex(x2, y2);
      this.arrowHead.vertex(leftX, leftY);
      this.arrowHead.vertex(rightX, rightY);
      this.arrowHead.endShape(CLOSE);
      shape(this.arrowHead);
    } else {
      strokeWeight(2);
      stroke(this.arrowHeadColor);
      line(x2, y2, leftX, leftY);
      line(x2, y2, rightX, rightY);
      line(leftX, leftY, rightX, rightY);
    }
    stroke(50, 100, 255, 255);
    ellipse(x1, y1, 10, 10);
    popStyle();
    popMatrix();
  }
}
