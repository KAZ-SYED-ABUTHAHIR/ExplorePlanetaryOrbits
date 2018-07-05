//Have to be developed into a potential UI Component in Future.

public class SideBar extends Widget
{

  float handleWidth; //Width of the handle to pull out the side bar
  float animSpeed ; // Easing speed of the sliding action of the side bar

  color handleColor; // Color of the handle

  private boolean latched = true; // Property to keep track of latching condition of the sidebar
  private float slide = -1;       // To determine sliding direction on mouse click multiplied by -1. 
  // Hence start with -1 for sliding out

  SideBar() {
    super();

    this.animSpeed = 0.2;
    this.barWidth = 2*width/3;
    this.barHeight = height/2;
    this.handleWidth = 10;
    this.leftPos = -this.barWidth + this.handleWidth;
    this.topPos = height*this.relTopPos;

    this.barColor = color(10, 25, 10, 32);
    this.handleColor = color(255, 0, 255, 64);
    this.self = createGraphics((int)this.barWidth, (int)this.barHeight);
    this.init();
  }

  SideBar(float _topPos, float _barWidth, float _barHeight) {
    super(_topPos, _barWidth, _barHeight);


    this.handleWidth = 10;
    this.leftPos = -this.barWidth + this.handleWidth;

    this.barColor = color(10, 25, 10, 128);
    this.handleColor = color(255, 0, 255, 16);
    this.self = createGraphics((int)this.barWidth, (int)this.barHeight);
    this.animSpeed = 0.2;

    this.init();
  }

  void init() {
    pushStyle();
    self.smooth(4);
    self.beginDraw();
    self.background(this.barColor); 
    self.noStroke();
    self.fill(this.handleColor);
    //New hande Drawing...
    pushStyle();
    self.noFill();
    //self.strokeJoin(BEVEL);
    float beginX = this.barWidth-this.handleWidth/2;

    for (float i=-this.handleWidth/2; i<this.handleWidth/2+2; i++) {
      self.stroke(red(this.handleColor), green(this.handleColor), blue(this.handleColor)
        , abs(155-abs(map(i, -handleWidth/2, handleWidth/2, -100, 100))));
      this.self.line(beginX+i, 0, beginX+i, this.barHeight);
    }
    popStyle();
    //
    //self.rect(this.barWidth-this.handleWidth, 0, handleWidth, this.barHeight); //Deprecate
    if (this.img != null) {
      self.tint(255, 152);
      self.image(this.img, 0, 0, this.barWidth-this.handleWidth, this.barHeight);
    }
    self.endDraw();

    popStyle();
    if (this.children.size()>0) {

      for (Widget w : this.children) {
        w.init();
        self.image(w.self, w.leftPos, w.topPos);
      }
    } //is this needed or not SERIOUSLY? in render this is required but not here I hope...
    this.buffer = this.self.get();
  }

  void render() {
    pushMatrix();
    if (this.children.size()>0) {
      for (Widget w : this.children) {
        w.render();
      }
    }

    image(this.self, this.leftPos, this.topPos);
    float target = (this.slide<0)?(-this.barWidth+this.handleWidth):(0);
    float diff = abs(target-this.leftPos);
    if (!this.latched) {
      this.leftPos += this.slide*(diff*animSpeed);
    }

    float handlePosition = this.leftPos + this.barWidth-this.handleWidth;
    float handlePositionMin = 0;
    float handlePositionMax  = this.barWidth-this.handleWidth;

    if (handlePosition < handlePositionMin) {
      this.latched = true;
      this.leftPos = -this.barWidth+this.handleWidth;
    }

    if (handlePosition > handlePositionMax) {
      this.latched = true;
      this.leftPos = 0;
    }
    popMatrix();
  }

  void slideOut() {
    this.latched = false;
    this.slide = 1;
  }

  void slideIn() {
    this.latched = false;
    this.slide = -1;
  }


  void setHandleColor(color c) {
    this.handleColor = color(red(c), green(c), blue(c), 184);
    this.init();
  }

  void drawHandle() {
    //NEW
    self.noStroke();
    self.fill(this.handleColor);
    self.rect(this.barWidth-this.handleWidth, 0, handleWidth, this.barHeight);
    this.init();
    //NEW
  }

  void setImage(PImage _image) {
    this.img = _image;
    this.init();
  }

  boolean inFocus() {
    return (mouseX > this.leftPos && 
      mouseX < (this.leftPos + this.barWidth ) && 
      mouseY > this.topPos && 
      mouseY < (this.topPos + this.barHeight)) ;
  }

  void mouseClickedHandler() {
    float handlePosition = this.leftPos + this.barWidth-this.handleWidth;
    if (mouseX > handlePosition && mouseX < handlePosition+this.handleWidth && this.inFocus()) {
      this.latched = false;
      this.slide *= -1.0;
    }
    try
    {
      for (Widget w : this.children) {
        w.mouseClickedHandler();
      }
    }
    catch(Exception e) {
      println("No Children Yet!");
    }
  }

  void setParent(Widget w) {
    this.parent = null;
  }

  void addChild(Widget child) {
    this.children.add(child);
    child.setParent(this);
    child.init();
  }
}//EOC
