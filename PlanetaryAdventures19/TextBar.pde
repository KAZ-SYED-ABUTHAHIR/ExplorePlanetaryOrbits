
public class TextBar extends Widget {

  PFont font;     //Font used for text o/p
  String textContent; // Text to be displayed in the text bar
  color textBackColor; // Color of the text surface
  color textColor; // Color of the text
  float textHeight; // Text Height for alignment purposes
  float textLeading = 20;
  float leftPadding = 10;
  float rightPadding = 10;
  float topPadding = 10;
  float bottomPadding = 10;
  float textSize = 14;
  boolean borderless = false;
  boolean textDelimited ; //is this necessary?
  char delimiter;


  TextBar(float _leftPos, float _topPos, float _barWidth, float _barHeight, Widget _parent) {
    super(_leftPos, _topPos, _barWidth, _barHeight);
    this.initFields();
    this.parent = _parent;
    this.parent.addChild(this);
    this.init();
  }

  TextBar(float _leftPos, float _topPos, float _barWidth, float _barHeight) {
    super(_leftPos, _topPos, _barWidth, _barHeight);
    this.initFields();
    this.init();
  }

  private void initFields() {
    this.textContent = "";
    this.textBackColor = color(5, 25, 10, 100);
    this.textColor = color(200, 200, 200, 255);
    this.font = createFont("Calibri", this.textSize, true);
    this.textHeight = textAscent()+textDescent()+this.font.getSize();
    this.barColor = this.textBackColor;
    this.self = createGraphics((int)this.barWidth, (int)this.barHeight);
    this.self.smooth(8);
  }
  void init() {
    pushStyle();
    try {
      self.smooth(4);
      self.beginDraw();
      self.fill(this.barColor); 
      self.rectMode(CORNER);
      self.background(this.textBackColor);
      if (this.borderless) {
        self.noStroke();
      } else {
        self.strokeWeight(8);
        self.stroke(255, 100, 50, 128);
      }
      self.strokeWeight(4);
      //self.rect(0, 0, this.barWidth-1, this.barHeight-1);
      self.strokeJoin(ROUND);
      self.stroke(255, 255);
      self.line(1, 1, this.barWidth-1, 1);
      self.line(1, 1, 1, this.barHeight-1);
      self.stroke(128, 255);
      self.line(this.barWidth-1, this.barHeight-1, this.barWidth-1, 1);
      self.line(this.barWidth-1, this.barHeight-1, 1, this.barHeight-1);
      self.strokeWeight(1);
      self.stroke(128, 255);
      self.rect(0, 0, this.barWidth, this.barHeight);
      self.endDraw();
      popStyle();
      printText(this.textContent);
    }
    catch(Exception e) {
      e.printStackTrace();
      println("Exception in Textbar init() method");
    }
  }

  void render() {


    this.parent.self.beginDraw();
    this.parent.self.pushStyle();

    //If I'm the first child, It is my duty to clear up the mess before rendering me...
    if (this.parent.children.indexOf(this) == 0) //This is my long sought solution...Thank God...
    {
      this.parent.self.clear();
      this.parent.self.image(this.parent.buffer, 0, 0);
    }
    
    this.parent.self.image(this.self, this.leftPos, this.topPos); 
    this.parent.self.popStyle();
    this.parent.self.endDraw();
  }


  void printText(String str) {
    if (str.length()==0) return;
    if (this.textDelimited) {
      try {
        this.printTextDelimited(str);
      }
      catch(Exception e) {
        e.printStackTrace();
        this.setText("FORMAT ERROR !");
      }
      return;
    } 
    //printArray(Thread.currentThread().getStackTrace());

    pushStyle();
    self.beginDraw();
    self.rectMode(CORNER);
    if (this.font != null) {
      self.textFont(this.font);
    } else {
      self.textSize(18);
    }
    self.noStroke();
    float textLeadingFactor = 1.0f;
    this.textLeading = this.textHeight/textLeadingFactor;
    self.textLeading(this.textLeading);

    float fieldWidth = (this.barWidth-this.rightPadding-this.leftPadding);
    float fieldHeight = (this.barHeight-this.topPadding-this.bottomPadding);

    self.textAlign(LEFT, TOP);
    self.fill(this.textBackColor);
    self.rect(0, 0, this.barWidth, this.barHeight);
    self.fill(this.textColor); 
    self.textSize(this.textSize);
    self.text(str, this.leftPadding, this.topPadding, 
      fieldWidth, fieldHeight);

    self.endDraw();
    popStyle();
  }

  void printTextDelimited(String str) {
    if (textContent.length()==0) return;  //???? 0 or 1?
    //Restructuring the str into two parts based on the delimiter ':'
    String[] splitString = this.split(str);
    String headerStr = splitString[0];
    String leftStr = splitString[1];
    String rightStr = splitString[2];
    //Wonderfull defugging tools ahead !
    //println(headerStr + " "+ millis()); // Why this is printed twice?
    //printArray(Thread.currentThread().getStackTrace()); //Found out through stack trace
    //
    pushStyle();

    self.beginDraw();
    self.rectMode(CORNER);
    if (this.font != null) {
      self.textFont(this.font);
    } else {
      self.textSize(18);
    }
    self.noStroke();
    float textLeadingFactor = 1.0f;
    this.textLeading = this.textHeight/textLeadingFactor;
    self.textLeading(this.textLeading);

    float fieldWidth = (this.barWidth/2-this.rightPadding-this.leftPadding);
    float fieldHeight = (this.barHeight-this.topPadding-this.bottomPadding);

    //Beginning Header Text Surface
    float headerHeight = 2*fieldHeight/str.split("\n").length;
    float fieldWidthHeader = (this.barWidth-this.rightPadding-this.leftPadding);
    float fieldHeightHeader = (headerHeight-this.topPadding-this.bottomPadding);
    fieldHeight -= headerHeight;

    self.textAlign(CENTER, CENTER);
    self.fill(this.textBackColor);
    self.rect(0, 0, this.barWidth, headerHeight);
    self.fill(this.textColor); 
    self.textSize(18);
    self.text(headerStr, this.leftPadding, this.topPadding, 
      fieldWidthHeader, fieldHeightHeader);

    //Begining left text surface
    self.textSize(this.textSize);
    self.textAlign(RIGHT, TOP);
    self.fill(this.textBackColor);
    self.rect(0, headerHeight, this.barWidth/2, this.barHeight);
    self.fill(this.textColor); 
    self.text(leftStr, this.leftPadding, headerHeight+this.topPadding, fieldWidth, fieldHeight);
    //self.rect(this.leftPadding, headerHeight+this.topPadding, fieldWidth, fieldHeight);

    //Beginning right text surface
    self.textAlign(LEFT, TOP);
    self.fill(this.textBackColor);
    self.rect(this.barWidth/2, headerHeight, this.barWidth/2, this.barHeight);
    self.fill(this.textColor);
    self.text(rightStr, this.barWidth/2+this.leftPadding, headerHeight+this.topPadding, fieldWidth, fieldHeight);

    //Beginning Underlining the firstline //Headache? Yes Unsolved Mystery
    self.stroke(200, 250, 255);
    self.strokeWeight(2);
    if (this.textContent.length() != 0) {

      //self.line(this.leftPadding, this.textHeight+this.topPadding-this.textLeading/(4*textLeadingFactor), 
      //  this.leftPadding+self.textWidth(str.split("\n")[0]), this.textHeight+this.topPadding-this.textLeading/(4*textLeadingFactor));
      //self.line(this.leftPadding, this.textHeight+1, 
      //     this.leftPadding+self.textWidth(str.split("\n")[0]), this.textHeight+1);
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

  private String[] split(String str)
  {
    String[] splitString = new String[3];
    String headerStr = "";
    String leftStr = "";
    String rightStr = "";
    //Playing to display text easthetically...
    String[] lines = str.split("\n");
    String regX = "\\s+" + this.delimiter;
    for (int i=1; i<lines.length; i++) {
      String[] lineParts = lines[i].split(regX);//Regular Expression Saved the Day !
      //(This RegX means split at ":" preceded by one or more white spaces)
      leftStr += lineParts[0]+"\n";
      rightStr += this.delimiter+" "+lineParts[1]+"\n";
    }
    headerStr = lines[0];
    splitString[0] = headerStr;
    splitString[1] = leftStr;
    splitString[2] = rightStr;
    return splitString;
  }
  void setText(String str) {
    this.textContent = str;
    this.textDelimited = false;
    this.init();
  }

  void setTextSize(float _textSize) {
    this.textSize = _textSize;
    this.init();
  }

  void addText(String str) {
    this.textContent += str;
    this.textDelimited = false;
    this.init();
  }

  void setText(String str, char _delimiter) {
    this.textContent = str;
    this.delimiter = _delimiter;
    this.textDelimited = true;
    this.init();
  }

  void setleftPadding(float _leftPadding) {
    this.leftPadding = _leftPadding;
    this.init();
  }
}//EOC
