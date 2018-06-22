public class TextBar extends Widget {

  PFont font;     //Font used for text o/p
  String textContent; // Text to be displayed in the text bar
  color textBackColor; // Color of the text surface
  color textColor; // Color of the text
  float textHeight; // Text Height for alignment purposes

  float leftPadding = 5;
  float rightPadding = 5;
  float topPadding = 5;
  float bottomPadding = 5;

  boolean textDelimited = true;
  char delimiter = ':';

  void render() {
    parent.self.image(this.self, this.leftPos, this.topPos);
  }

  boolean inFocus() {
    return true;
  }

  void mouseClickedHandler() {
  }

  void addChild(Widget child) {
    children.add(child);
  }

  void init() {
    pushStyle();
    this.self = createGraphics((int)this.barWidth, (int)this.barHeight);
    self.smooth(4);
    self.beginDraw();
    self.background(this.barColor); 
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
      self.textSize(32);
    }
    self.textLeading(30);
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
    //Beginning Underlining the firstline
    self.stroke(0, 50, 255);
    self.strokeWeight(2);
    if (this.textContent.length() != 0) {
      self.line(5, 35, 5+self.textWidth(str.split("\n")[0]), 35);
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
  void setText(String str) {
    this.textContent = str;
    this.init();
  }
}
