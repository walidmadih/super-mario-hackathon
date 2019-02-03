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
  boolean isOnGround;
  
  ImageSet imgSet = smallMarioSet;   
        
  Player() {
    this.size = new Vec2(cellSize, cellSize);
    this.img = imgSet.get("idle").getPImage();
    img.resize(cellSize, cellSize);
  }
     
  void step(float dt){
    handleControls();
    vel.add(acc.x * dt, acc.y * dt);
    if (acc.x == 0) {
       vel.x *= GameConstants.DAMPING;
    }
    
    
    restrictVelocity();     
    pos.add(vel);
    isOnGround = false; //<>//
  }
  
  void handleControls() {
    acc.y = GameConstants.GRAVITY;
    
     boolean up = Keyboard.isPressed(87);
     if (up && isOnGround) {
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
    vel.y = min(GameConstants.GRAVITY_MAX_SPEED, vel.y);
  }
  
  void handleCollision(FullCollisionReport collision) {
    isOnGround = (collision.voteY < 0);
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
