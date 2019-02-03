class Player extends Body {
  
  // ImageSets (used in Step4)
  ImageSet smallMarioSet = new ImageSet("data/img/players/mariosmall");
  ImageSet smallStarMarioSet[] = {
   new ImageSet("data/img/players/mariosmalldark"),
   new ImageSet("data/img/players/mariosmallflower"),
   new ImageSet("data/img/players/mariosmallgreen"),
   new ImageSet("data/img/players/mariosmallpale")
  };
  ImageSet bigMarioSet = new ImageSet("data/img/players/mariobig");
  ImageSet bigStarMarioSet[] = {
   new ImageSet("data/img/players/mariobigdark"),
   new ImageSet("data/img/players/mariobigflower"),
   new ImageSet("data/img/players/mariobiggreen"),
   new ImageSet("data/img/players/mariobigpale")
  };
  ImageSet flowerMarioSet = new ImageSet("data/img/players/mariobigflower");
  
  
  boolean alive = true;
  boolean isCrouching;
  
  ImageSet imgSet;      
        
  Player() {
    this.size = new Vec2(cellSize, 2*cellSize);
  }
     
  void step(float dt){    
    handleControls();
    vel.add(acc.x * dt, acc.y * dt);
    if (acc.x == 0) {
       vel.x *= GameConstants.DAMPING;
    }
    
    
    restrictVelocity();     
    pos.add(vel);
    
    handleTiles();
    handleEnemies();
    handleItems();
    handleObstacles(); //<>// //<>//
  }
  
  void handleControls() {
    acc.y = GameConstants.GRAVITY;
    
     boolean up = Keyboard.isPressed(87);
     if (up) {
      vel.y = GameConstants.PLAYER_JUMP;
    }
    
    if (Keyboard.isPressed(83)) { 
      // TODO: implement crouch 
      //pos.y += dt;
    }
    
    // Left
    boolean left = Keyboard.isPressed(65);
    boolean right = Keyboard.isPressed(68);
    if (left != right) {
      acc.x = GameConstants.PLAYER_ACC * (right ? 1 : -1); 
    } else {
      acc.x = 0;
    }
  }
  
  void restrictVelocity() {
    vel.x = max(-GameConstants.PLAYER_MAX_SPEED_X, min(vel.x, GameConstants.PLAYER_MAX_SPEED_X));
    vel.y = min(GameConstants.PLAYER_MAX_SPEED_Y, vel.y);
  }
  
  void handleCollisions() {
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
        this.pos.y = cellSize * ((data.p[1] > 0) ? floor(this.pos.y/cellSize) : ceil(this.pos.y/cellSize));
      } else {
        this.pos.x = cellSize * ((data.p[0] > 0) ? floor(this.pos.x/cellSize) : ceil(this.pos.x/cellSize));
      }
      return;
    }
    
    final int finalVoteY = voteY;
    final int finalVoteX = voteX;
    Runnable run1 = new Runnable() {

      public void run() {
      if (finalVoteY != 0) {
        Player.this.pos.y = cellSize * ((finalVoteY < 0) ? floor(Player.this.pos.y/cellSize) : ceil(Player.this.pos.y/cellSize));
      }
    }};
    
    Runnable run2 = new Runnable() {
       public void run() {
         if (finalVoteX != 0) {
           Player.this.pos.x = cellSize * ((finalVoteX < 0) ? floor( Player.this.pos.x/cellSize) : ceil( Player.this.pos.x/cellSize));
        }
       }
    };
    
    if (abs(finalVoteX) > abs(finalVoteY)) {
      Runnable temp = run2;
      run2 = run1;
      run1 = temp;
    }
    
    run1.run();
    
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
    
    if (!hasCollision) return;
    
    run2.run();
    
  }
  
  void interactWith(Tile tile){ //<>// //<>//
  }   
  
  void interactWith(Enemy enemy){  
  }
  
  void interactWith(Item item){
  }
  
  void interactWith(Body body){ //<>// //<>//
  }
 //<>// //<>//
  boolean valid(){ return alive; }

  void draw() {
      super.draw();
  }
}   
