interface Animation{
  void step(float dt);
  void draw();
  boolean completed();
}

class ParticleAnimation implements Animation{
  Vec2 pos,vel;
  Image image;
  int resizeX,resizeY;
  
  ParticleAnimation(Vec2 pos, Vec2 vel, Image image, int resizeX, int resizeY){
    this.pos = pos;
    this.vel = vel;
    this.image = image;
    this.resizeX = resizeX;
    this.resizeY = resizeY;
  }
  void step(float dt){
    vel.y += GameConstants.GRAVITY;
    pos.add(vel);
  }
  void draw(){
    PImage img = image.getPImage();
    img.resize(resizeX, resizeY);
    image(img, pos.x, pos.y);
  }
  boolean completed(){
    return pos.y >= height;
  }
}
