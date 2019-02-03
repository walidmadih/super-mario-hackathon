
// ************ Body base class **************
// base class for all interacting game element
// (player, enemies, items, tiles, ...)

class Body{
  Vec2 pos = new Vec2(); // position of bottom-left corner
  Vec2 size = new Vec2(1);  
  Vec2 vel = new Vec2();
  Vec2 acc = new Vec2();
  Vec2 damping = new Vec2(1,1);
  PImage img = null;
  boolean visible = true;
  
  //color of the body
  Color bodyColor = new Color();
  void setColor(Color c) {bodyColor = c;}
  
  
  // **** constructors ****
  Body(){}
  Body(float x, float y){ pos.x = x; pos.y = y; }
  Body(float x, float y, float sx, float sy){ pos.x = x; pos.y = y; size.x = sx; size.y = sy; }
  Body(Body o){
    pos = o.pos.copy();
    size = o.size.copy();
    vel = o.vel.copy();
    acc = o.acc.copy();
    damping = o.damping.copy();
    visible = o.visible;
    img = o.img;
  }
  
  
  // **** stepping ****
  void step(float dt) {
  }
  
  // **** Utilitary functions ****
  float left(){ return pos.x; }
  float right(){ return pos.x + size.x; }
  float bottom(){ return pos.y; }
  float top(){ return pos.y + size.y; }
  float centerx(){ return pos.x + size.x/2; }
  float centery(){ return pos.y + size.y/2; }
  
  void handleBlockCollisions() {
    int collisionCount = 0;
    int voteX = 0, voteY = 0;
    CollisionData data = null;
    
    int minX = floor(pos.x / cellSize);
    int minY = floor(pos.y / cellSize);
    int maxX = floor((pos.x + size.x) / cellSize);
    int maxY = floor((pos.y + size.y) / cellSize);
       
    for (int x = minX; x <= maxX; ++x) {
      for (int y = minY; y <= maxY; ++y) {
        Tile tile = game.level.getTile(x, y);
        if (tile == null)
          continue;
          
        CollisionData d = tile.getCollisionData(this);
        if (d == null) continue;
                
        data = d;
        ++collisionCount;
        voteX += data.voteX();
        voteY += data.voteY();
      }  
    }
    
    if (collisionCount == 0) return;
    if (collisionCount == 1) {
      if (abs((float)data.p[0]) >= abs((float)data.p[1])){
        this.vel.y = 0;
        this.pos.y = cellSize * ((data.p[1] > 0) ? floor(this.pos.y/cellSize) : ceil(this.pos.y/cellSize));
      } else {
        this.vel.x = 0;
        this.pos.x = cellSize * ((data.p[0] > 0) ? floor(this.pos.x/cellSize) : ceil(this.pos.x/cellSize));
      }
      handleCollision(new FullCollisionReport(collisionCount, voteX, voteY, data));
      return;
    }
    
    final int finalVoteY = voteY;
    final int finalVoteX = voteX;
    Runnable run1 = new Runnable() {

      public void run() {
      if (finalVoteY != 0) {
        Body.this.vel.y = 0;
        Body.this.pos.y = cellSize * ((finalVoteY < 0) ? floor(Body.this.pos.y/cellSize) : ceil(Body.this.pos.y/cellSize));
      }
    }};
    
    Runnable run2 = new Runnable() {
       public void run() {
         if (finalVoteX != 0) {
           Body.this.vel.x = 0;
           Body.this.pos.x = cellSize * ((finalVoteX < 0) ? floor( Body.this.pos.x/cellSize) : ceil( Body.this.pos.x/cellSize));
        }
       }
    };
    
    if (abs(finalVoteX) > abs(finalVoteY)) {
      Runnable temp = run2;
      run2 = run1;
      run1 = temp;
    }
    
    run1.run();
    
    handleCollision(new FullCollisionReport(collisionCount, voteX, voteY, data));
    
    boolean hasCollision = false;
    outer: for (int x = minX; x <= maxX; ++x) {
      for (int y = minY; y <= maxY; ++y) {
        Tile tile = game.level.getTile(x,y);
        if (tile == null)
          continue;
        
        CollisionData d = tile.getCollisionData(this);
        if (d != null) {
          hasCollision = true;
          break outer;
        }
      }  
    }
    
    if (hasCollision) run2.run();
    
    handleCollision(new FullCollisionReport(collisionCount, voteX, voteY, data));
  }
   //<>// //<>//
  void draw(){
    //TODO(step1): draw body as a rectangle.
    if (this.img == null) {
      fill(255,0,0);
      strokeWeight(0);
      rect(this.pos.x , this.pos.y, this.size.x, this.size.y);
    } else {
      image(this.img, this.pos.x, this.pos.y); 
    }
    
  };
  
  void handleCollision(FullCollisionReport collision) {}
  
  // **** Functions to overload by children if needed ****
  boolean valid() { return true; }  
  void interactWith(Player player){}
  void interactWith(Enemy enemy){}
  void interactWith(Item item){}
  void interactWith(Tile tile){}
  void interactWith(Body body){}
}
