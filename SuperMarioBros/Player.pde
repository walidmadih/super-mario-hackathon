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
  boolean isUnder;
  
  int koopaInvincibility = 0;
  ImageSet imgSet = smallMarioSet;   
        
  Player() {
    this.size = new Vec2(cellSize, cellSize);
    this.img = imgSet.get("idle").getPImage();
    img.resize(cellSize, cellSize);
  }
     
  void step(float dt){
    --koopaInvincibility;
    handleControls();
    vel.add(acc.x * dt, acc.y * dt);
    if (acc.x == 0) {
       vel.x *= GameConstants.DAMPING;
    }
    
    
    restrictVelocity();     
    pos.add(vel); //<>//
    isOnGround = false; //<>//
  }
  
  void handleControls() {
    acc.y = GameConstants.GRAVITY;
    
     boolean up = Keyboard.isPressed(87);
     if (up && isOnGround) {
      vel.y = GameConstants.PLAYER_JUMP;
      this.img = imgSet.get("jump").getPImage();
      img.resize(cellSize, cellSize);
     }
    
    boolean down = Keyboard.isPressed(83);
    if (down) { 
      // TODO: implement crouch 
      if (isOnGround){
        this.img = imgSet.get("crouch").getPImage();
        img.resize(cellSize, cellSize);
      }
      //pos.y += dt;
    }
    
    // Left
    boolean left = Keyboard.isPressed(65);
    boolean right = Keyboard.isPressed(68);
    if (left != right) {
      acc.x = GameConstants.PLAYER_ACC * (right ? 1 : -1); 
      if(isOnGround && !up){
        this.img = imgSet.get("run").getPImage();
        img.resize(cellSize, cellSize);
      }
    } else {
      acc.x = 0;
      if (isOnGround && !up && !down){
        this.img = imgSet.get("idle").getPImage();
        img.resize(cellSize, cellSize);
      }
    }
  }
  
  void restrictVelocity() {
    vel.x = max(-GameConstants.PLAYER_MAX_SPEED_X, min(vel.x, GameConstants.PLAYER_MAX_SPEED_X));
    vel.y = min(GameConstants.GRAVITY_MAX_SPEED, vel.y);
  }
  
  void handleCollision(FullCollisionReport collision) {
    isOnGround = (collision.voteY < 0);
  }
  
  
  
  void handleEnemyCollisions() {
    for (Enemy enemy : game.enemies) {
       CollisionData data = enemy.getCollisionData(this);
       if (data == null) continue;
       
       if (enemy instanceof Koopa && ((Koopa)enemy).inShell && ((Koopa)enemy).shellDirection == 0) {
         koopaInvincibility = GameConstants.KOOPA_KICK_INVINCIBILITY;
         ((Koopa)enemy).shellDirection = (data.direction[DIR_LEFT] ? 1 : -1);
         continue;
       }
       
       if (data.direction[DIR_DOWN] || !data.direction[DIR_UP] || abs((float)data.p[0]) < abs((float)data.p[1])) {
         if (enemy instanceof Koopa && koopaInvincibility > 0) continue;
         
         // Kill player
         println("player dead");
         this.img = imgSet.get("dead").getPImage();
         img.resize(cellSize, cellSize);
         game.play = false;
       } else { //<>// //<>// //<>//
         // Kill enemy
         if (enemy instanceof Koopa) {
           Koopa koopa = (Koopa) enemy;
           if (!koopa.inShell) {
             koopa.setInShell();
           } else if (koopa.shellDirection != 0) {
             koopa.shellDirection = 0;
           }
         } else {
           enemy.alive = false;
         }
         
         this.pos.y = floor(this.pos.y);
         this.vel.y = GameConstants.SMASH_JUMP;
       }
    }
  }
   //<>// //<>// //<>//
  boolean valid(){ return alive; }
  void draw() {
      super.draw();
  }
}   
