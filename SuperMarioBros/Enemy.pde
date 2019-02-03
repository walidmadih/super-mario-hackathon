
// ****************** Enemy base class **********************
// base class for all enemies
// (koopa, goomba, piranhaplant, ...)

abstract class Enemy extends Body {
  boolean alive = true;
  boolean direction = false;
  
  // **** constructors ****
  Enemy(float x, float y) {
    super();
    pos.set(x,y);
  }
    
  // **** stepping ****
  void step(float dt){
    if(!alive) return; //<>//
    
    vel.y += GameConstants.GRAVITY;
    vel.y = min(GameConstants.GRAVITY_MAX_SPEED, vel.y);
    
    double step = GameConstants.GOOMBA_SPEED * dt * (direction ? 1 : -1);
    this.pos.x += step;
    this.pos.y += vel.y;
     //<>//
  }
   //<>//
  boolean valid(){ return alive; }
  
  void handleCollision(FullCollisionReport collision) {
    if (collision.voteX > 0) {
       direction = true;
    } else if (collision.voteX < 0) {
      direction = false;
    }
  }
}



// ************ GOOMBA ************

class Goomba extends Enemy {
  ImageSet imgSet = new ImageSet("data/img/enemies/goomba/brown");
  
  // **** constructors ****
  Goomba(float x, float y) { 
    super(x, y);
    this.size.set(cellSize, cellSize);
    this.img = imgSet.get("walking").getPImage();
    this.img.resize((int)size.x, (int)size.y);
  }
   //<>// //<>//
}


// ************ KOOPA *************

class Koopa extends Enemy {
  ImageSet imgSet = null;
  
  // **** constructors ****
  Koopa(float x, float y) {
    super(x, y);
  }
  
  // **** stepping ****
  void step(float dt){
    if(!alive) return;
    super.step(dt);
  }
  
}
