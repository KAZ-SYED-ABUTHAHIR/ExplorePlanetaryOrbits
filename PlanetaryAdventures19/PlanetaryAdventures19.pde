//Refactoring On from Iteration 8: 15.06.2018 
//Primary aim of refactoring is to cast SideBar class in a more reusable form
//Emphasis is on Code Reusability...And Don't forget the famous Arrow class

Attractor sun;
ArrayList<Planet> planets;
SideBar sb;
SideBar SB;
TextBar txtBar, txtBarSB, txtBarsb;
int highlightedPlanetIndex = -1;

float zoomFactor = 0.85; //This is the optimal zoom factor for speed...
float zoomStep = 0.15;
float pMouseX, pMouseY;

final boolean showOrbitPoints = false;
PVector velocityAnchor  = new PVector(0, 0);

void setup() {
  size(720, 720, P2D);

  smooth(8);
  background(0);
  frameRate(60);
  sb = new SideBar(0, 2.5*width/3, 2*height/3);
  SB = new SideBar(2*height/3, 2*width/3, height/2);

  txtBar = new TextBar(10, 10, (sb.barWidth-sb.handleWidth-20), sb.barHeight/2-10);
  txtBarsb = new TextBar(10, sb.barHeight/2+10, (sb.barWidth-sb.handleWidth-20), sb.barHeight/2-20);
  txtBarSB = new TextBar(10, 10, (SB.barWidth-SB.handleWidth-20), SB.barHeight/2-10);
  txtBarSB.setTextSize(16);
  

  sb.addChild(txtBarsb);
  sb.addChild(txtBar);
  SB.addChild(txtBarSB);
  //txtBarsb.setText("Processing is a flexible software sketchbook and a language for learning how to code within the context of the visual arts. Since 2001, Processing has promoted software literacy within the visual arts and visual literacy within technology. There are tens of thousands of students, artists, designers, researchers, and hobbyists who use Processing for learning and prototyping.");
  String message = "Interactivity\n\n" +
                   "Click and drag to add a Planet. The arrow represents velocity vector.\n" +
                   "Press \'h\'or \'H\' to cycle through planets for highlighting.\n" + 
                   "Press \'d\'or \'D\' to delete the highlighted planet.\n" + 
                   "Orbital parameters for highlighted planets are show in the above text field";
   
  txtBarsb.setText(message); 
  txtBarsb.setTextSize(17);
  sun = new Attractor();
  planets = new ArrayList<Planet>();
  background(0);
}

void draw() {
  if (!mousePressed || sb.inFocus()) {
    //fill(0, 128);
    //noStroke();
    //rect(0, 0, width, height);
    background(0);
    pushMatrix();
    scale(zoomFactor);
    translate(width/2*(1/zoomFactor), height/2*(1/zoomFactor));
    sun.show();
    for (Planet p : planets) {
      p.showOrbit(showOrbitPoints);
    }
    for (Planet p : planets) {
      p.calcForce(sun);
      p.update();
      p.show();
      p.showVelocity();
      p.showAcceleration();
      //p.showVelocity(velocityAnchor);
    }
    popMatrix();
    sb.render();
    SB.render();
    if (frameCount%10 == 0){
      String debugMsg = "Debug Parameters"+
                        "\nFrame Rate   : " + String.format("%.02f", frameRate) +
                        "\nZoom Factor : " + String.format("%.02f", zoomFactor)+
                        "\nhighlightedPlanetIndex : " + highlightedPlanetIndex;
      txtBarSB.setText(debugMsg, ':');    
      //if(highlightedPlanetIndex>-1)
      //txtBarSB.setText(planets.get(highlightedPlanetIndex).orbitDescriptor, ':');
    }
  }//END IF
}


void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      zoomFactor += zoomStep;
      if (zoomFactor>10) zoomFactor = 10;
      background(0);
    } else if (keyCode == DOWN) {
      zoomFactor -= zoomStep;
      if (zoomFactor<0) zoomFactor = 0;
      background(0);
    }
  } 
  if (key == 'D'||key == 'd')
  {

    if (planets.size()>0) {
      planets.remove(planets.get(highlightedPlanetIndex++));
      if (highlightedPlanetIndex > (planets.size()-1)) highlightedPlanetIndex = 0;
      if (planets.size()>0) {
       
        selectPlanet(highlightedPlanetIndex);
      } else {
        txtBar.setText("NO PLANETS AVAILABLE !");
        highlightedPlanetIndex = -1;
      }
      background(0);
    }
  }
  if (key == 'H'||key == 'h')
  {
    if (planets.size()>0) {
      planets.get(highlightedPlanetIndex++).setHighlighted(false);
      if (highlightedPlanetIndex > (planets.size()-1)) highlightedPlanetIndex = 0;
      selectPlanet(highlightedPlanetIndex);
     
    }
  }
}

void selectPlanet(int index) {
  planets.get(index).setHighlighted(true);
  txtBar.setText( planets.get(index).orbitDescriptor, ':');
  sb.setHandleColor( planets.get(index).planetColor);
}

void mouseDragged() {
  if (sb.inFocus() || SB.inFocus()) {
    return;
  }
  background(0);
  drawScene();
  //redraw();
  Arrow arrow  = new Arrow(pMouseX, pMouseY, mouseX, mouseY);
  arrow.show();
}



void mousePressed() {
  if (sb.inFocus() || SB.inFocus()) {
    return;
  }
  pMouseX = mouseX; 
  pMouseY = mouseY;
  noCursor();
  //redraw();
}

void mouseReleased() {
  if (sb.inFocus() || SB.inFocus()) {
    return;
  }
  addNewPlanet((mouseX - pMouseX)/Planet.velocityArrowScale, (mouseY - pMouseY)/Planet.velocityArrowScale);
  background(0);
  cursor();
}

void addNewPlanet(float vx, float vy) {
  pushMatrix();
  //Important piece of transformation , I understand? 
  float x = (pMouseX-width/2)/zoomFactor; 
  float y = (pMouseY-height/2)/zoomFactor;
  Planet p = new Planet(new PVector(x, y), new PVector(vx, vy), 0.5, sun);
  try {
    planets.add(p);
  }
  catch(Exception e) {
    e.printStackTrace();
  }

  if(planets.size()==1) {
    highlightedPlanetIndex = 0;
    selectPlanet(highlightedPlanetIndex);
  }
  popMatrix();
}

void drawScene() {
  background(0);
  pushMatrix();
  scale(zoomFactor);
  translate(width/2*(1/zoomFactor), height/2*(1/zoomFactor));
  sun.show();

  popMatrix();
  //sb.render();
  //SB.render();
  
}//Could Multi threading help here?
void mouseClicked() {
  sb.mouseClickedHandler();
  SB.mouseClickedHandler();
}
