import java.util.Map; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
class Player extends Body {
  
  ImageSet containerTileSet = new ImageSet("data/img/tiles/imageSet1");
  
  // ImageSets (used in Step4)
  ImageSet smallStarMarioSet[] = {
   new ImageSet("data/img/players/mariosmalldark"),
   new ImageSet("data/img/players/mariosmallflower"),
   new ImageSet("data/img/players/mariosmallgreen"),
   new ImageSet("data/img/players/mariosmallpale")
  };
  ImageSet bigStarMarioSet[] = {
   new ImageSet("data/img/players/mariobigdark"),
   new ImageSet("data/img/players/mariobigflower"),
   new ImageSet("data/img/players/mariobiggreen"),
   new ImageSet("data/img/players/mariobigpale")
  };
  
  
  boolean alive = true;
  boolean isCrouching;
  boolean isOnGround;
  boolean isUnder;
  
  int koopaInvincibility = 0;
  int invincibility = 0;
  MarioState state = MarioState.SMALL;
  ImageSet imgSet = MarioState.SMALL.imageSet;   
        
  Player() {
    this.size = new Vec2(cellSize, cellSize);
    this.img = imgSet.get("idle").getPImage();
    img.resize(cellSize, cellSize);
  }
     
  void step(float dt){
    if (koopaInvincibility > 0) --koopaInvincibility;
    if (invincibility > 0) --invincibility;
    
    handleControls();
    vel.add(acc.x * dt, acc.y * dt);
    if (acc.x == 0) {
       vel.x *= GameConstants.DAMPING; //<>//
    } //<>// //<>//
         //<>//
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
  
  void handleCollision(FullCollisionReport collision) { //<>//
    isOnGround = (collision.voteY < 0);
   if(collision.voteY > 0){
    //if the collision is from under
    
     for(Map.Entry<Tile, CollisionData> me : collision.data.entrySet()){
       Tile t = me.getKey();
       int posX = (int) t.pos.x / cellSize;
       int posY = (int) t.pos.y / cellSize;
       if(t instanceof SolidTile){
         
       }else if(t instanceof BreakableTile){
         game.level.tiles[posX][posY] = null;
         game.level.backgroundImages[posX][posY] = null;
         
         //have a preset block explosion coordinate and instance it at posX and posY
         
       }else if(t instanceof ContainerTile){
         game.level.backgroundImages[posX][posY] = CONTAINER_IMAGE_SET.get("end").getPImage();
         //pop up an item
       } //<>// //<>//
     }
    
   }
  }
  
  void handleEnemyCollisions() {
    for (Enemy enemy : game.enemies) {
       CollisionData data = enemy.getCollisionData(this);
       if (data == null) continue;
        //<>//
       if (invincibility > 0) {
          enemy.alive = false;
          continue;
       }
       
       if (enemy instanceof Koopa && ((Koopa)enemy).inShell && ((Koopa)enemy).shellDirection == 0) {
         koopaInvincibility = GameConstants.KOOPA_KICK_INVINCIBILITY;
         ((Koopa)enemy).shellDirection = (data.direction[DIR_LEFT] ? 1 : -1); //<>//
         continue;
       }
       
       if (data.direction[DIR_DOWN] || !data.direction[DIR_UP] || abs((float)data.p[0]) < abs((float)data.p[1])) {
         if (enemy instanceof Koopa && koopaInvincibility > 0) continue; //<>//
         
         // Kill player
         println("player dead");
         this.img = imgSet.get("dead").getPImage();
         img.resize(cellSize, cellSize); //<>//
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
           GoombaDeathAnimation gda = new GoombaDeathAnimation(enemy.pos);
           game.animations.add(gda);
           enemy.alive = false;
         }
         
         this.pos.y = floor(this.pos.y);
         this.vel.y = GameConstants.SMASH_JUMP;
       }
       
       
    }
  }
  
  void setMarioState(MarioState newState) {
    if (newState == null || state == newState) return;
    
    this.imgSet = newState.imageSet;
    this.img = imgSet.get("idle").getPImage();
    
    // Check if going from small to big
    if (state == MarioState.SMALL) {
      this.pos.y -= 1;
      this.size.y = 2*cellSize;
    }
    
    // Check if going from big to small
    else if (newState == MarioState.SMALL) {
      this.pos.y += 1;
      this.size.y = cellSize;
    }
    
    this.state = newState;
  }
  
   //<>// //<>// //<>//
  boolean valid(){ return alive; }
  void draw() {
      super.draw();
  }
}   
