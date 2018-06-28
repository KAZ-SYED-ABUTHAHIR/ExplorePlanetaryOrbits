abstract public class Widget {
  Widget parent = null;
  ArrayList<Widget> children = new ArrayList<Widget>();
  PGraphics self; //Main graphic surface to draw on...
  PImage buffer = null;//Buffer to hold self
  float barWidth; //Width of the Widget
  float barHeight; //Height of the Widget
  float leftPos;  //x coordinate of the left extreme of the Widget
  float topPos; //y coordinate of the upper extreme of the Widget
  float relTopPos=0; // Relative position from the parent/container top as a fraction of parents height
  float relLeftPos=0; // Relative position from the parent/container left as a fraction of parents width
  color barColor ; // Background color of the Widget
  PImage img; // Optional background image can be set.
  Widget(float _topPos,float _barWidth,float _barHeight){
    this.topPos = _topPos;
    this.barWidth = _barWidth;
    this.barHeight = _barHeight;
  }
  
 
  Widget(){
  }
  
  abstract void init();
  abstract void render();
  abstract boolean inFocus();
  abstract void mouseClickedHandler();
  abstract void addChild(Widget child);
  protected abstract void setParent(Widget w);
  
};

/*
Tamil Unicode 
"\u0B85\u0BAE\u0B82\u0BAE\u0BBE " ---> ammA




*/
