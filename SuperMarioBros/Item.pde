
// ************** Item base class ********************* 
// base class for all items

abstract class Item extends Body {
  boolean consumed = false;
  boolean direction = true;

  // **** constructors ****
  Item() {
    this.size.set(cellSize, cellSize);
  }
  Item(float x, float y) { 
    super(x, y);
    this.size.set(cellSize, cellSize);
  }
  Item(Item o) { 
    super(o);
    this.consumed = o.consumed;
  }
  abstract Item copy();
  // **** interactions ****

  void pickedUpBy(Player player) {
  }
  boolean valid() { 
    return !consumed;
  }

  void step(float absStep, boolean dir) {

    vel.y += GameConstants.GRAVITY;
    vel.y = min(GameConstants.GRAVITY_MAX_SPEED, vel.y);

    double step = absStep * (dir ? 1 : -1);
    this.pos.x += step;
    this.pos.y += vel.y;
  }

  void handleCollision(FullCollisionReport collision) {
    if (collision.voteX > 0) {
      direction = true;
    } else if (collision.voteX < 0) {
      direction = false;
    }
  }
}



// ***************** Grow ********************
// temporary item that creates appropriate item (mushroom or flower) on grow (out of tile)

class Grow extends Item {  
  Grow() {
  }
  Grow(Grow o) { 
    super(o);
  }
  Grow copy() { 
    return new Grow(this);
  }
}



// **************** Mushroom ***********************

class Mushroom extends Item {

  Mushroom() { 
    super(0, 0);
    this.img = loadImage("data/img/items/mushroom.png");
    this.img.resize(cellSize, cellSize);
  }
  Mushroom(float x, float y) {
    super(x, y);
    this.img = loadImage("data/img/items/mushroom.png");
    this.img.resize(cellSize, cellSize);
  }
  Mushroom(Mushroom o) { 
    super(o); 
    this.img = o.img;
  }
  Mushroom copy() { 
    return new Mushroom(this);
  }

  void step(float s) {
    super.step(GameConstants.GOOMBA_SPEED * s, direction);
  }

  void draw() {
    super.draw();
  }
}



// ****************** Flower ***********************

class Flower extends Item {

  Flower() { 
    super(0, 0);
  }  
  Flower(float x, float y) {
    super(x, y);
  }
  Flower(Flower o) { 
    super(o); 
    this.img = o.img.copy();
  }
  Flower copy() { 
    return new Flower(this);
  }
}




// ************* One Up ****************

class OneUp extends Item {

  OneUp() { 
    super(0, 0);
    this.img = loadImage("data/img/items/oneUp.png");
    this.img.resize(cellSize, cellSize);
  }
  OneUp(float x, float y) {
    super(x, y);
    this.img = loadImage("data/img/items/oneUp.png");
    this.img.resize(cellSize, cellSize);
  }
  OneUp(OneUp o) { 
    super(o);
  }
  OneUp copy() { 
    return new OneUp(this);
  }
  void step(float s) {
    super.step(GameConstants.GOOMBA_SPEED * s, direction);
  }

  void draw() {
    super.draw();
  }
}



// *************** Coin ******************

class Coin extends Item {
  Coin() { 
    super(0, 0);
  }
  Coin(float x, float y) { 
    super(x, y);
  }
  Coin(Coin o) { 
    super(o);
  }
  Coin copy() { 
    return new Coin(this);
  }
}



// ****************** Star **********************

class Star extends Item {

  Star() { 
    super(0, 0);
    this.img = new ImageSet("data/img/items/star").get("").getPImage();
    this.img.resize(cellSize, cellSize);
  }
  Star(float x, float y) {
    super(x, y);
    this.img = new ImageSet("data/img/items/star").get("").getPImage();
    this.img.resize(cellSize, cellSize);
  }
  Star(Star o) { 
    super(o);
  }
  Star copy() { 
    return new Star(this);
  }
  
  void step(float s) {
    super.step(GameConstants.GOOMBA_SPEED * s, direction);
  }
  
  void handleCollision(FullCollisionReport collision) {
    boolean isOnGround = (collision.voteY < 0);
    if(isOnGround) {
      this.vel.y = GameConstants.STAR_JUMP;
    }
  }
}
