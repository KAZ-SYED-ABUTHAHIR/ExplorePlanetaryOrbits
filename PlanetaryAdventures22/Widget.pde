public abstract  class Widget {
  protected Widget parent = null;
  protected ArrayList<Widget> children = new ArrayList<Widget>();
  protected PGraphics self; //Main graphic surface to draw on...
  protected PImage buffer = null;//Buffer to hold self

  protected float barWidth; //Width of the Widget
  protected float barHeight; //Height of the Widget
  protected float leftPos;  //x coordinate of the left extreme of the Widget
  protected float topPos; //y coordinate of the upper extreme of the Widget
  protected float relTopPos=0; // Relative position from the parent/container top as a fraction of parents height
  protected float relLeftPos=0; // Relative position from the parent/container left as a fraction of parents width
  protected color barColor ; // Background color of the Widget
  protected PImage img; // Optional background image can be set.

  Widget(float _topPos, float _barWidth, float _barHeight) {

    this.topPos = _topPos;
    this.barWidth = _barWidth;
    this.barHeight = _barHeight;
  }

  Widget(float _leftPos, float _topPos, float _barWidth, float _barHeight) {
    this.leftPos = _leftPos;
    this.topPos = _topPos;
    this.barWidth = _barWidth;
    this.barHeight = _barHeight;
  }


  Widget() {
  }

  protected abstract void init();
  protected abstract void render();

  //abstract boolean inFocus();
  protected abstract void mouseClickedHandler();
  protected abstract void addChild(Widget child);

  //---------------------------------------------------------------------------------------------//
  //-----------------------------------GETTERS & SETTERS-----------------------------------------//

  //----------------------------------------GETTERS----------------------------------------------//
  
  Widget getParent() {
    return this.parent;
  }

  ArrayList<Widget> getChildren() {
    return this.children;
  }
  
  PImage getBuffer() {
    return this.buffer;
  }
  
  float getBarWidth() {
   return this.barWidth; 
  }
  
  float getBarHeight() {
   return this.barHeight; 
  }
  
  color getBarColor() {
    return this.barColor;
  }

  //----------------------------------------SETTERS----------------------------------------------//

  void setParent(Widget w) {
    this.parent = w;
  }
  
  void setBarColor(color _barColor) {
    this.barColor = _barColor;
  }
}//EOAC

/*
Tamil Unicode 
 "\u0B85\u0BAE\u0B82\u0BAE\u0BBE " ---> ammA
 Project Idea
 
 
 */
