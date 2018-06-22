//Have to be developed into a potential UI Component in Future.

public class SideBar extends Widget
{
  PFont font;     //Font used for text o/p
  String textContent; // Text to be displayed in the side bar 
  color textBackColor; // Color of the text surface
  color textColor; // Color of the text
  float textHeight; // Text Height for alignment purposes

  float handleWidth; //Width of the handle to pull out the side bar
  float animSpeed ; // Easing speed of the sliding action of the side bar
  PImage img; // Optional background image can be set.
  color handleColor; // Color of the handle

  private boolean latched = true; // Property to keep track of latching condition of the sidebar
  private float slide = -1;       // To determine sliding direction on mouse click multiplied by -1. 
  // Hence start with -1 for sliding out

  SideBar() {
    super();
    this.textContent = "";
    this.textBackColor = color(255, 200);
    this.textColor = color(10, 10, 50, 200);
    animSpeed = 0.2;
    try {
      this.font = createFont("GIST-TMOTPadma Normal", 20, true);
    }
    catch(Exception e) {
      //Throw the exception away. Don't bother, handled in the later code!
      //But, Don't forget to log the error
      //But wait no exception even for the mispelling I hope this try-catch block is not necessary
      println("Could not locate the font "+this.font.toString()+". Using Default");
      e.printStackTrace();
    }
    this.textHeight = textAscent()+textDescent()+this.font.getSize();

    this.barWidth = 2*width/3;
    this.barHeight = height/2;
    this.handleWidth = 10;
    this.leftPos = -this.barWidth + this.handleWidth;
    this.topPos = height*0.1;

    this.barColor = color(100, 150, 200, 128);
    this.handleColor = color(255, 0, 255, 64);
    this.self = createGraphics((int)this.barWidth, (int)this.barHeight);
    init();
  }

  void init() {
    pushStyle();
    self.smooth(4);
    self.beginDraw();
    self.background(this.barColor); 
    self.noStroke();
    self.fill(this.handleColor);
    self.rect(this.barWidth-this.handleWidth, 0, handleWidth, this.barHeight);
    if (this.img != null) {
      self.tint(255, 152);
      self.image(this.img, 0, 0, this.barWidth-this.handleWidth, this.barHeight);
    }
    self.endDraw();
    popStyle();

    printText(this.textContent);
  }

  void printText(String str) {
    //Restructuring the str into two parts based on the delimiter ':'

    String[] splitString = split(str, ':');

    String leftStr = splitString[0];
    String rightStr = splitString[1];

    pushStyle();
    self.beginDraw();
    self.rectMode(CORNER);
    if (this.font != null) {
      self.textFont(this.font);
    } else {
      // self.textSize(32);
    }
    
    self.textLeading(30);
    self.textAlign(LEFT);
    self.noStroke();
    //Begining left text surface
    self.fill(this.textBackColor);
    self.rect(5, 10, (this.barWidth-this.handleWidth-10)/2, this.barHeight-20);
    self.fill(this.textColor);
    self.text(leftStr, 5, 10, (this.barWidth-this.handleWidth-10)/2, this.barHeight-20);
    //Beginning right text surface
    self.textAlign(LEFT);
    self.fill(this.textBackColor);
    self.rect(5+(this.barWidth-this.handleWidth-10)/2, 10, (this.barWidth-this.handleWidth-10)/2, this.barHeight-20);
    self.fill(this.textColor);
    self.text(rightStr, 5+(this.barWidth-this.handleWidth-10)/2, 10, (this.barWidth-this.handleWidth-10)/2, this.barHeight-20);
    //Beginning Underlining the firstline
    self.stroke(0, 50, 255);
    self.strokeWeight(2);
    if (this.textContent.length() != 0) {
      self.line(5, this.textHeight+5, 5+self.textWidth(str.split("\n")[0]), this.textHeight+5);
    }
    self.endDraw();
    popStyle();
  }

  private String[] split(String str, char delimiter)
  {
    String[] splitString = new String[2];
    String leftStr = "";
    String rightStr = "";
    //Playing to display text easthetically...
    String[] lines = str.split("\n");
    String regX = "\\s+" + delimiter;
    for (int i=1; i<lines.length; i++) {
      String[] lineParts = lines[i].split(regX);//Regular Expression Saved the Day !
      //(This RegX means split at ":" preceded by one or more white spaces)
      leftStr += lineParts[0]+"\n";
      rightStr += ": "+lineParts[1]+"\n";
    }

    leftStr = lines[0] + "\n" + leftStr;
    rightStr =  "\n" + rightStr;
    splitString[0] = leftStr;
    splitString[1] = rightStr;
    return splitString;
  }




  void render() {

    image(this.self, this.leftPos, this.topPos);
    float target = (this.slide<0)?(-this.barWidth+this.handleWidth):(0);
    float diff = abs(target-this.leftPos);
    if (!this.latched) {
      this.leftPos += this.slide*(diff*animSpeed);
      //this.leftPos += this.slide*3;
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
  }

  void setText(String str) {
    this.textContent = str;
    this.init();
  }

  void setHandleColor(color c) {
    this.handleColor = color(red(c),green(c),blue(c),184);
    this.init();
  }

  void setImage(PImage _image) {
    this.img = _image;
    this.init();
  }

  boolean inFocus() {
    return (mouseX > this.leftPos && mouseX < (this.leftPos + this.barWidth + 10) && mouseY > this.topPos && mouseY < (this.topPos + this.barHeight + 10)) ;
  }

  void mouseClickedHandler() {
    float handlePosition = this.leftPos + this.barWidth-this.handleWidth;
    if (mouseX > handlePosition && mouseX < handlePosition+this.handleWidth) {
      this.latched = false;
      this.slide *= -1.0;
    }
  }

  void addChild(Widget child) {
    this.children.add(child);
  }
}
