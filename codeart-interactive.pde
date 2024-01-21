class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector target;
  float radius;
  float maxSpeed;
  float maxForce;

  Particle(float x, float y) {
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    target = new PVector(random(width), random(height));
    maxSpeed = 50;
    maxForce = 10;
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);
    desired.setMag(maxSpeed);

    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);

    return steer;
  }

  PVector arrive(PVector target, float slowingDistance) {
    PVector desired = PVector.sub(target, position);
    float distance = desired.mag();

    float speed = maxSpeed;
    if (distance < slowingDistance) {
      speed = map(distance, 0, slowingDistance, 0, maxSpeed);
    }

    desired.setMag(speed);

    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);

    return steer;
  }

  void update() {
    PVector arriveForce = arrive(target, 100);
    applyForce(arriveForce);

    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    position.add(velocity);
    acceleration.mult(0);

    // Check if the particle has reached the target
    if (position.dist(target) < 10) {
      target = new PVector(random(width), random(height));
    }
  }

  void display() {
    if (random(10) < 1)
    {
      ink_splatter(particle.position.x, particle.position.y, 0);
      ink_splatter(width-particle.position.x, height-particle.position.y, 255);
    }
  }
}

color[] cols= {color(112, 112, 75),   color(115, 105, 97), color(215, 90, 35), color(242, 230, 195)};
PVector brush = new PVector(0, 0);
float px;
float py;
float x0=0;
float y0=0;

//Code for brush strokes
void Brush() {
  float s = 2+100/dist(px, py, brush.x, brush.y);
  s=min(20, s);//limit strokeWeight
  strokeWeight(s);
  stroke(0, s*100);
  line(px, py, brush.x, brush.y);
  stroke(255, s*100);
  line(width-px, height-py, width-brush.x, height-brush.y);//symmetric
}

//Code for inksplatter (dots that splatter on canvas)
void ink_splatter(float bx, float by, float  c) {
  noStroke();
  fill(c);
  float r = random(0.5, 10);
  ellipse(bx+random(-30, 30), by+random(-30, 30), r, r);
  ellipse(bx+random(-30, 30), by+random(-30, 30), r, r);
}

//the growing square above background 
void autosplatter() { 
  strokeWeight(1);
  stroke(cols[(int)random(cols.length)], 50);
  if (frameCount<500)
   for (int i=0; i<10000; i++)   
   {
     float nx=sin(-12.5*y0)-cos(12.5*x0);
     float ny=sin(-1*x0)-cos(1.9+y0);     
     point(400*x0+width/2, 400*y0+height/2);
     x0=nx;
     y0=ny;
   }

}

Particle particle; 
void setup() {
  size(1418, 1003);  
  particle = new Particle(width / 2, height / 2);
  noStroke();  
  background(cols[(int)random(cols.length)]);
}

void draw() {
  brush.x+=(mouseX-brush.x)/8;
  brush.y+=(mouseY-brush.y)/8;//follow the mouse with delay effect
  if (frameCount>40) 
    Brush();
  px=brush.x;
  py=brush.y;//stored value:)
  ink_splatter(brush.x,brush.y,0);
  ink_splatter(width-brush.x,height-brush.y,255);
  autosplatter();
}
