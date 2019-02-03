
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
  void step(float absStep, boolean dir){ //<>//
    if(!alive) return; //<>//
     //<>//
    vel.y += GameConstants.GRAVITY;
    vel.y = min(GameConstants.GRAVITY_MAX_SPEED, vel.y);
    
    double step = absStep * (dir ? 1 : -1);
    this.pos.x += step;
    this.pos.y += vel.y; //<>//
     //<>//
  } //<>//
   //<>//
  boolean valid(){ return alive; }
  
  void handleCollision(FullCollisionReport collision) {
    if (collision.voteX > 0) {
       direction = true;
    } else if (collision.voteX < 0) {
      direction = false;
    }
  }
  
  void handleEnemyCollisions(int i) {
    for (Iterator<Enemy> it = game.enemies.listIterator(i); it.hasNext();) {
      Enemy enemy = it.next();
      if (enemy == this) continue;
      
      CollisionData data = enemy.getCollisionData(this);
      if (data == null) continue;
      
      boolean thisShell = (this instanceof Koopa) && ((Koopa)this).inShell && ((Koopa)this).shellDirection != 0;
      boolean otherShell = (enemy instanceof Koopa) && ((Koopa)enemy).inShell && ((Koopa)enemy).shellDirection != 0;
      
      if (thisShell) {
        if (otherShell) {
          this.alive = false;
          enemy.alive = false;
          return;
        } else {
          enemy.alive = false;
        }
      } else {
        if (otherShell) {
          this.alive = false;
          return;
        } else {
          this.direction = !this.direction;
          enemy.direction = !enemy.direction;
        }
      }
    }
  }
}
 //<>//
 //<>//

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
  
  void step(float s) {
   super.step(GameConstants.GOOMBA_SPEED * s, direction);  //<>//
  } //<>//
}


// ************ KOOPA *************

class Koopa extends Enemy {
  boolean inShell;
  int shellDirection;
  ImageSet imgSet = new ImageSet("data/img/enemies/koopa/green");
  
  
  // **** constructors ****
  Koopa(float x, float y) {
    super(x, y);
    setWalking();
  }
  
  void setWalking() {
    inShell = false;
    this.size.set(cellSize, 2*cellSize);
    this.img = imgSet.get("walking").getPImage();
    this.img.resize((int)size.x, (int)size.y);
  }
  
  void setInShell() {
    inShell = true;
    this.pos.add(0, cellSize);
    this.size.set(cellSize, cellSize);
    this.img = imgSet.get("shell").getPImage();
    this.img.resize((int)size.x, (int)size.y);
  }
  
  void draw() {
    if (direction) {
      image(this.img, this.pos.x, this.pos.y);
    } else {
      scale(-1, 1);
      image(this.img, -this.size.x-this.pos.x, this.pos.y);
      scale(-1, 1);
    }
  }
  
  void step(float dt){
    float speed = inShell ? GameConstants.SHELL_SPEED : GameConstants.KOOPA_SPEED;
    if (inShell&&shellDirection == 0) speed = 0;
    super.step(speed * dt, inShell ? shellDirection > 0 : direction);
  }
  
  void handleCollision(FullCollisionReport collision) {    
    if (collision.voteX > 0) {
      if (inShell) shellDirection = 1;
      else direction = true;
      
    } else if (collision.voteX < 0) {
      if (inShell) shellDirection = -1;
      else direction = false;
    }
  }
  
}
