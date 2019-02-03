interface Animation{
  void step(float dt);
  void draw();
  boolean completed();
}

class GoombaDeathAnimation implements Animation{
  int timer = fps/4;
  Vec2 pos;
  PImage squishedgoomba = loadImage("data/img/enemies/goomba/brown/squished.png");

  GoombaDeathAnimation(Vec2 pos) {
    this.pos = pos;
    squishedgoomba.resize(cellSize, cellSize);
  }

  void draw(){
     image(squishedgoomba, pos.x, pos.y);
  }
  void step(float dt){
    timer--;
  }
  
  boolean completed() {
    return timer <= 0;
  }
}
