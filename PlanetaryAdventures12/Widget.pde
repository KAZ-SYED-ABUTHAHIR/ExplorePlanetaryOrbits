abstract public class Widget {
  Widget parent = null;
  ArrayList<Widget> children = null;
  PGraphics self; //Main graphic surface to draw on...
  float barWidth; //Width of the Widget
  float barHeight; //Height of the Widget
  float leftPos;  //x coordinate of the left extreme of the Widget
  float topPos; //y coordinate of the upper extreme of the Widget
  float relTopPos; // Relative position from the parent/container top
  float relLeftPos; // Relative position from the parent/container left
  color barColor ; // Background color of the Widget
  
  Widget(float _leftPos,float _topPos,float _barWidth,float _barHeight){
    this.leftPos = _leftPos;
    this.topPos = _topPos;
    this.barWidth = _barWidth;
    this.barHeight = _barHeight;
  }
  
  Widget(){
  }
  abstract void render();
  abstract boolean inFocus();
  abstract void mouseClickedHandler();
  abstract void addChild(Widget child);
  abstract void init();
};

/*
Tamil Unicode 
"\u0B85\u0BAE\u0B82\u0BAE\u0BBE " ---> ammA




*/
