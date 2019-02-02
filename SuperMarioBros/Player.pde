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
