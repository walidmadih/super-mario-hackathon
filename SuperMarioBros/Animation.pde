interface Animation {
  void step(float dt);
  void draw();
  boolean completed();
}

class ParticleAnimation implements Animation {
  Vec2 pos, vel;
  Image image;
  int resizeX, resizeY;

  ParticleAnimation(Vec2 pos, Vec2 vel, Image image, int resizeX, int resizeY) {
    this.pos = pos;
    this.vel = vel;
    this.image = image;
    this.resizeX = resizeX;
    this.resizeY = resizeY;
  }
  void step(float dt) {
    vel.y += GameConstants.GRAVITY;
    pos.add(vel);
  }
  
  void draw() {
    PImage img = image.getPImage();
    img.resize(resizeX, resizeY);
    image(img, pos.x, pos.y);
  }
  boolean completed() {
    return pos.y >= height;
  }
}

class CoinAnimation implements Animation {
  Vec2 pos, vel;
  Image image;
  int resizeX, resizeY;
  double initialY;
  
  CoinAnimation(Vec2 pos, Vec2 vel, Image image, int resizeX, int resizeY) {
    this.pos = pos;
    this.vel = vel;
    this.image = image;
    this.resizeX = resizeX;
    this.resizeY = resizeY;
    this.initialY = pos.y;
  }
  void step(float dt) {
    vel.y += GameConstants.GRAVITY;
    pos.add(vel);
  }
  
  void draw() {
    PImage img = image.getPImage();
    img.resize(resizeX, resizeY);
    image(img, pos.x, pos.y);
  }
  boolean completed() {
    return pos.y > initialY;
  }
}

class GoombaDeathAnimation implements Animation {
  int timer = fps/4;
  Vec2 pos;
  PImage squishedgoomba = loadImage("data/img/enemies/goomba/brown/squished.png");

  GoombaDeathAnimation(Vec2 pos) {
    this.pos = pos;
    squishedgoomba.resize(cellSize, cellSize);
  }

  void draw() {
    image(squishedgoomba, pos.x, pos.y);
  }
  void step(float dt) {
    timer--;
  }

  boolean completed() {
    return timer <= 0;
  }
}

class BlockBumpAnimation implements Animation {
  float y;
  Vec2 pos, vel;
  PImage img;
  
  BlockBumpAnimation(Vec2 pos, PImage img) {
    this.y = pos.y;
     this.pos = pos.copy().sub(0, 1);
     this.img = img;
     this.vel = new Vec2(0, -5);
  }
  
  void step(float dt) {
    vel.y += GameConstants.GRAVITY;
    pos.y += vel.y;
  }
  
  void draw() {
    img.resize(cellSize, cellSize);
    image(img, pos.x, pos.y);
  }
  
  boolean completed() {
    return pos.y >= y;
  }
}
