class Planet {  //<>// //<>// //<>//
  PVector position = new PVector();
  PVector velocity = new PVector();
  PVector acceleration = new PVector();
  PVector initialPosition = new PVector();
  Attractor myAttractor;
  ArrayList<PVector> orbitPoints = new ArrayList<PVector>();
  ArrayList<PolarPoint> orbitPolarPoints = new ArrayList<PolarPoint>();
  float orbitalPeriod=-1;
  float maxRadius = -1;
  float minRadius = 5000000;
  float minAngle = 0;
  float maxAngle = 0;
  int minIndex = 0;
  int maxIndex = 0;
  float orbitalEccentricity = 0;
  float semiMajorAxis = 0;
  float semiMinorAxis = 0;
  PVector apoapsis = new PVector(); //Farthest point from the attractor
  PVector periapsis = new PVector(); //Closest point to the attractor
  PVector orbitCenter = new PVector(); //Center point of the elliptical orbit
  String  orbitDescriptor;

  final private float threshold = 0.5;
  final private int minOrbitPointCount = 100;
  final private int maxOrbitPointCount = 50000;


  float mass;
  float size = 60;
  String name;
  color planetColor ;

  Arrow velocityArrow = new Arrow(0, 0, 0, 0);
  Arrow accelerationArrow  = new Arrow(0, 0, 0, 0);
  final static float velocityArrowScale = 40;
  
  boolean highlighted = false;

  //Constructors

  Planet(PVector _position, PVector _velocity, float _mass) {
    this.position = _position.copy();
    this.initialPosition = this.position.copy();
    this.velocity = _velocity.copy();
    this.velocityArrow = new Arrow(this.position, this.velocity.copy().mult(velocityArrowScale));
    this.mass = _mass;
    this.name = "Planet";
    this.orbitDescriptor = "";
    pushStyle();
    colorMode(HSB);
    this.planetColor = color(random(255), 255, 255, 255);
    popStyle();
  }

  Planet(PVector _position, PVector _velocity, float _mass, Attractor _attractor) {
    this(_position, _velocity, _mass);
    this.velocityArrow = new Arrow(this.position, this.velocity.copy().mult(velocityArrowScale));
    this.initialPosition = this.position.copy();
    this.myAttractor = _attractor;
    calcOrbit(_attractor);
  }

  Planet(PVector _position, float _mass) {
    this.position = _position.copy();
    this.initialPosition = this.position.copy();
    this.velocity = PVector.random2D();
    this.velocityArrow = new Arrow(this.position, this.velocity.copy().mult(velocityArrowScale));
    this.mass = _mass;
    this.name = "Planet";
    pushStyle();
    colorMode(HSB);
    this.planetColor = color(random(255), 255, 255, 255);
    popStyle();
  }

  Planet() {
    this.position.x = random(width);
    this.position.y = random(height);
    this.initialPosition = this.position.copy();
    this.velocity = PVector.random2D();
    this.velocity.setMag(random(0.5, 5.0));
    this.velocityArrow = new Arrow(this.position, this.velocity.copy().mult(velocityArrowScale));
    this.mass = random(0.05, 0.5);
    this.name = "Planet";
    pushStyle();
    colorMode(HSB);
    this.planetColor = color(random(255), 255, 255, 255);
    popStyle();
  }

  //Displayer
  void show() {
    pushStyle();
    fill(this.planetColor);
    noStroke();
    ellipse(this.position.x, this.position.y, this.size, this.size);
    if(this.highlighted){
      pushStyle();
        float beginRed = red(this.planetColor);
        float beginGreen = green(this.planetColor);
        float beginBlue = blue(this.planetColor);
        float endRed = 255-red(this.planetColor);
        float endGreen = 255-green(this.planetColor);
        float endBlue = 255-blue(this.planetColor);
        color beginColor = color(beginRed,beginGreen,beginBlue);
        color endColor = color(endRed,endGreen,endBlue);
        noFill();
        strokeWeight(2);
        for(float i=0;i<=1;i+=0.05){
        stroke(lerpColor(beginColor,endColor,i),map(i,0,1,255,0)); 
        ellipse(this.position.x, this.position.y, this.size+20*i, this.size+20*i);
        }
      popStyle();
    }
    popStyle();
  }

  //Update : Do Physics...Verlet Integration to be implemented in future.
  void update() {
    float deltaTime = 60/frameRate;
    this.velocity.add(PVector.mult(this.acceleration, deltaTime));
    this.position.add(PVector.mult(this.velocity, deltaTime));
    velocityArrow.setArrow(this.position, this.velocity.copy().mult(velocityArrowScale));
    accelerationArrow.setArrow(this.position, this.acceleration.copy().mult(velocityArrowScale*30));
    this.acceleration.setMag(0);
    //println("deltaTime: "+deltaTime);//deltaTime ---> experimental Seems to be OK...
  }

  //CalcForce : Calculate Force using Newton's Law of Gravitation. The Great Inverse Square Law.
  void calcForce(Attractor attractor) {
    float dist = PVector.dist(this.position, attractor.position);
    PVector radialVector = PVector.sub(attractor.position, this.position).setMag(1);
    acceleration.set(radialVector).setMag(G*attractor.mass/(dist*dist));
  }

  //Orbit calculations. Pretty messy now but works good...
  void calcOrbit(Attractor a) {
    PVector radial = PVector.sub(this.position, a.position);
    float initHeading = radial.heading()*180/PI+180.0f;
    float heading; 
    float magnitude;
    int count = 0;
    do {
      PVector pos = this.position.copy();
      orbitPoints.add(pos);
      calcForce(a);
      update();
      radial = PVector.sub(this.position, a.position);
      magnitude = radial.mag();
      heading = radial.heading()*180/PI+180.0f;
      if (magnitude>this.maxRadius) {
        this.maxRadius = magnitude;
        this.maxAngle = heading-180.0f;
        this.maxIndex = count;
      }
      if (magnitude<this.minRadius) {
        this.minRadius = magnitude;
        this.minAngle = heading-180.0f;
        this.minIndex = count;
      }
      count++;
    } while ((abs(heading-initHeading)>this.threshold || count < this.minOrbitPointCount) && !(count>this.maxOrbitPointCount));
    if (orbitPoints.size()<maxOrbitPointCount) {
      this.orbitalPeriod = orbitPoints.size()*(1/frameRate);
    }
    this.orbitalEccentricity = (this.maxRadius-this.minRadius)/(this.maxRadius+this.minRadius);
    this.apoapsis = orbitPoints.get(maxIndex);
    this.periapsis = orbitPoints.get(minIndex);
    this.orbitCenter = PVector.lerp(this.apoapsis, this.periapsis, 0.5);
    this.semiMajorAxis = PVector.sub(this.periapsis, this.apoapsis).mag()/2;
    this.semiMinorAxis = this.semiMajorAxis*sqrt(1-this.orbitalEccentricity*this.orbitalEccentricity);
    float keplerRCubeByTSquare = pow(this.semiMajorAxis, 3)/pow(this.orbitalPeriod, 2);
    this.orbitDescriptor += "Orbital Parameters\n";
    this.orbitDescriptor += "Orbital Period          : "+String.format("%.02f", this.orbitalPeriod)+ " Sec\n";
    this.orbitDescriptor += "Eccentricity            : "+String.format("%.02f", this.orbitalEccentricity)+ "\n";
    this.orbitDescriptor += "Semi Major Axis         : "+String.format("%.02f", this.semiMajorAxis) + "\n";
    this.orbitDescriptor += "Semi Minor Axis         : "+String.format("%.02f", this.semiMinorAxis) + "\n";
    this.orbitDescriptor += "Kepler III Law Constant : "+String.format("%.02f", keplerRCubeByTSquare) + "\n";
    this.orbitDescriptor += "Max Radius              : "+String.format("%.02f", this.maxRadius) + "\n";
    this.orbitDescriptor += "Min Radius              : "+String.format("%.02f", this.minRadius) + "\n";
    // "\u00B0" ---> Degree Symbol
    this.orbitDescriptor += "Max Angle               : "+String.format("%.02f", this.maxAngle) + "\u00B0" + "\n";
    this.orbitDescriptor += "Min Angle               : "+String.format("%.02f", this.minAngle) + "\u00B0" + "\n"; 
    this.orbitPoints.clear();
  }

  void calcPolarOrbit(Attractor a) {
    pushMatrix();
    translate(a.position.x, a.position.y);
    PVector radial = PVector.sub(this.position, a.position);
    print(radial.mag());
    print(" , ");
    println(radial.heading()*180/PI+180.0f);
    popMatrix();
  }

  void showOrbit(boolean showPoints) {
    pushStyle();
    strokeWeight(2);
    stroke(this.planetColor);
    noFill();
    pushMatrix();
    translate(this.orbitCenter.x, this.orbitCenter.y);
    rotate(radians(this.minAngle));
    ellipse(0, 0, 2*this.semiMajorAxis, 2*this.semiMinorAxis);
    popMatrix();
    if (showPoints) {
      stroke(0, 0, 255, 255);
      strokeWeight(20);
      point(orbitPoints.get(minIndex).x, orbitPoints.get(minIndex).y);
      stroke(255, 100, 0, 255);
      point(orbitPoints.get(maxIndex).x, orbitPoints.get(maxIndex).y);
      stroke(255, 100, 255, 255);
      point(this.orbitCenter.x, this.orbitCenter.y);
      popStyle();
    }
  }

  void showRadial(Attractor a) {
    pushStyle();
    stroke(this.planetColor);
    line(a.position.x, a.position.y, this.position.x, this.position.y);
    popStyle();
  }

  void showVelocity() {
    this.velocityArrow.show();
  }

  void showAcceleration() {
    this.accelerationArrow.show();
  }

  void showVelocity(PVector anchor) {
    velocityArrow.setArrow(anchor, this.velocity.copy().mult(velocityArrowScale));
    this.velocityArrow.show();
  }
  
  void setHighlighted(boolean _highlighted){
    this.highlighted = _highlighted;
  }
}//CLASS_END
