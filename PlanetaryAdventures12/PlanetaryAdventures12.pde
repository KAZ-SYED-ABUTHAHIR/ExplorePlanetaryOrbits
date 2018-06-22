//Refactoring On from Iteration 8: 15.06.2018 
//Primary aim of refactoring is to cast SideBar class in a more reusable form
//Emphasis is on Code Reusability...And Don't forget the famous Arrow class

Attractor sun;
ArrayList<Planet> planets;
SideBar sb;

float zoomFactor = 1.0;
float zoomStep = 0.15;
float pMouseX, pMouseY;

final boolean showOrbitPoints = false;
PVector velocityAnchor  = new PVector(0, 0);

void setup() {
  size(720, 640, P2D);
  smooth(8);
  background(0);
  frameRate(60);
  sb = new SideBar();
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
    try {
      planets.remove(planets.size()-1);
      background(0);
    }
    catch(Exception e) {
      //Who Cares?
    }
  }
}

void mouseDragged() {
  if (sb.inFocus()) {
    return;
  }
  background(0);
  drawScene();
  //redraw();
  Arrow arrow  = new Arrow(pMouseX, pMouseY, mouseX, mouseY);
  arrow.show();
}



void mousePressed() {
  if (sb.inFocus()) {
    return;
  }
  pMouseX = mouseX; 
  pMouseY = mouseY;
  noCursor();
  //redraw();
}

void mouseReleased() {
  if (sb.inFocus()) {
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
  sb.setText(p.orbitDescriptor);
  sb.setHandleColor(p.planetColor);
  popMatrix();
}

void drawScene() {
  background(0);
  pushMatrix();
  scale(zoomFactor);
  translate(width/2*(1/zoomFactor), height/2*(1/zoomFactor));
  sun.show();
  
  popMatrix();
  sb.render();
}//Could Multi threading help here?
void mouseClicked() {
  sb.mouseClickedHandler();
}
