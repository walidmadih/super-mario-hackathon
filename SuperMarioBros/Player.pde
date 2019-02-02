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
    dt = 2.5*dt;
    if (Keyboard.isPressed(87)) {
      pos.y -= dt;
    }
    
    if (Keyboard.isPressed(83)) {
      pos.y += dt;
    }
    
    if (Keyboard.isPressed(65)) {
      pos.x -= dt;
    }
    
    if (Keyboard.isPressed(68)) {
      pos.x += dt;
    }
       
    handleTiles();
    handleEnemies();
    handleItems();
    handleObstacles(); //<>//
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
        SolidTile tile = new SolidTile(x, y);
        if (!game.tempTiles.contains(tile))
          continue;
        
        CollisionData d = tile.getCollisionData(this);
        if (d == null) continue;
        
        data = d;
        println(data);
        ++collisionCount;
        voteX += data.voteX();
        voteY += data.voteY();
      }  
    }
    
    if (collisionCount == 0) return;
    println("ay");
    if (collisionCount == 1) {
      if (abs((float)data.p[0]) >= abs((float)data.p[1])){
        this.pos.y = cellSize * ((data.p[1] > 0) ? floor(this.pos.y/cellSize) : ceil(this.pos.y/cellSize));
      } else {
        this.pos.x = cellSize * ((data.p[0] > 0) ? floor(this.pos.x/cellSize) : ceil(this.pos.x/cellSize));
      }
      return;
    }
    
    if (voteY != 0) {
      this.pos.y = cellSize * ((voteY < 0) ? floor(this.pos.y/cellSize) : ceil(this.pos.y/cellSize));
    }
    
    if (voteX != 0) {
      this.pos.x = cellSize * ((voteX < 0) ? floor(this.pos.x/cellSize) : ceil(this.pos.x/cellSize));
    }
  }
  
  void interactWith(Tile tile){ //<>//
  }   
  
  void interactWith(Enemy enemy){  
  }
  
  void interactWith(Item item){
  }
  
  void interactWith(Body body){ //<>//
  }
 //<>//
  boolean valid(){ return alive; }

  void draw() {
      super.draw();
  }
}   
