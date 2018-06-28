public class TextBar extends Widget {

  PFont font;     //Font used for text o/p
  String textContent; // Text to be displayed in the text bar
  color textBackColor; // Color of the text surface
  color textColor; // Color of the text
  float textHeight; // Text Height for alignment purposes
  float textLeading = 20;
  float leftPadding = 20;
  float rightPadding = 5;
  float topPadding = 10;
  float bottomPadding = 10;
  float textSize = 18;
  
  //boolean textDelimited = true; //is this necessary?
  char delimiter = ':';

  TextBar(float _leftPos, float _topPos, float _barWidth, float _barHeight, Widget _parent) {
    super(_topPos, _barWidth, _barHeight);
    this.leftPos = _leftPos;
    this.textContent = "";
    this.textBackColor = color(255, 255, 255,128);
    this.textColor = color(10, 10, 50, 200);
    this.font = createFont("Calibri", this.textSize, true);
    this.textHeight = textAscent()+textDescent()+this.font.getSize();
    this.barColor = this.textBackColor;
    this.self = createGraphics((int)this.barWidth, (int)this.barHeight);
    this.parent = _parent;
    this.parent.addChild(this);
    this.init();
  }

  TextBar(float _leftPos, float _topPos, float _barWidth, float _barHeight) {
    super(_topPos, _barWidth, _barHeight);
    this.leftPos = _leftPos;
    this.textContent = "";
    this.textBackColor = color(255, 255, 255,128);
    this.textColor = color(10, 40, 50, 200);
    this.font = createFont("Calibri", this.textSize, true);
    this.textHeight = 0.8*textAscent()+0.8*textDescent()+this.font.getSize();
    this.barColor = this.textBackColor;
    this.self = createGraphics((int)this.barWidth, (int)this.barHeight);
    this.init();
  }
  void init() {
    pushStyle();
    try{
    self.smooth(4);
    self.beginDraw();
    self.fill(this.barColor); 
    self.rectMode(CORNER);
    self.background(this.parent.barColor);
    self.rect(-1, -1, this.barWidth+1, this.barHeight+1);
    self.endDraw();
    popStyle();
    printText(this.textContent);
    
    }
    catch(Exception e){
      e.printStackTrace();
      println("Exception in Textbar init() method");
    }
    
  }

  void render() {
    this.parent.self.beginDraw();
    //this.parent.self.tint(50,100,200,4);
    this.parent.self.background(this.parent.barColor);//Danger !!! Gossamer Effect <> Danger I think I solved this...
    this.parent.self.image(this.parent.buffer,0,0);
    this.parent.self.image(this.self, this.leftPos, this.topPos); 
    this.parent.self.endDraw();    
  }

  void printText(String str) {
    if (textContent.length()==0) return;  //???? 0 or 1?
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
      self.textSize(32);
    }
    this.textLeading = this.textHeight/1.0;
    self.textLeading(this.textLeading);
    self.textAlign(LEFT);
    self.noStroke();
    //Begining left text surface
    self.fill(this.textBackColor);
    self.rect(0, 0, this.barWidth/2, this.barHeight);
    self.fill(this.textColor);
    float fieldWidth = (this.barWidth/2-this.rightPadding-this.leftPadding);
    float fieldHeight = (this.barHeight-this.topPadding-this.bottomPadding);
    self.text(leftStr, this.leftPadding, this.topPadding, fieldWidth, fieldHeight);
    //Beginning right text surface
    self.textAlign(LEFT);
    self.fill(this.textBackColor);
    self.rect(this.barWidth/2, 0, this.barWidth, this.barHeight);
    self.fill(this.textColor);
    self.text(rightStr, this.barWidth/2+this.leftPadding, this.topPadding, fieldWidth, fieldHeight);
    //Beginning Underlining the firstline //Headache?
    self.stroke(0, 50, 255);
    self.strokeWeight(2);
    if (this.textContent.length() != 0) {
      
      self.line(this.leftPadding, this.textHeight+this.topPadding-this.textLeading/4, 
        this.leftPadding+self.textWidth(str.split("\n")[0]), this.textHeight+this.topPadding-this.textLeading/4);
    }
    self.endDraw();
    popStyle();
  }

  boolean inFocus() { //Have to change this but how? think... well changed
    float relX  = mouseX - this.parent.leftPos;
    float relY = mouseY - this.parent.topPos;
    return (relX> this.leftPos &&
      relX < (this.leftPos + this.barWidth) &&
      relY > this.topPos && 
      relY < (this.topPos + this.barHeight));
  }

  void mouseClickedHandler() {
  }

  void addChild(Widget child) {
    children.add(child);
  }

  void setParent(Widget w) {
    this.parent = w;
    //print("I am in TextBar setParent method my parent is : ");
    //println(this.parent);
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
  void setText(String str) {
    this.textContent = str;
    this.init();
  }
  
  void setText(String str,char _delimiter) {
    this.textContent = str;
    this.delimiter = _delimiter;
    this.init();
  }
  
  void setleftPadding(float _leftPadding){
    this.leftPadding = _leftPadding;
    this.init();
  }
}
