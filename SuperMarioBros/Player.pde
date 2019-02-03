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
  String imgName;
  MarioState state = MarioState.SMALL;
  ImageSet imgSet = MarioState.SMALL.imageSet;   

  Player() {
    this.imgName = "idle";
    this.size = new Vec2(cellSize, cellSize);
    this.img = imgSet.get(imgName).getPImage();
    img.resize((int) size.x, (int) size.y);
  }

  void step(float dt) {
    if (koopaInvincibility > 0) --koopaInvincibility;
    if (invincibility > 0) --invincibility; //<>// //<>//
    if (invincibility < 0) ++invincibility;

    handleControls();
    vel.add(acc.x * dt, acc.y * dt);
    if (acc.x == 0) {
      vel.x *= GameConstants.DAMPING;
    }

    restrictVelocity();     
    pos.add(vel); 
    isOnGround = false;
    
    if (pos.y > height) {
      alive = false;
      game.play = false;
    }
  }

  void handleControls() {
    acc.y = GameConstants.GRAVITY;

    boolean up = Keyboard.isPressed(87);
    if (up && isOnGround) {
      imgName = "jump";
      vel.y = GameConstants.PLAYER_JUMP;
      this.img = imgSet.get(imgName).getPImage();
      img.resize((int) size.x, (int) size.y);
    }

    boolean down = Keyboard.isPressed(83);
    if (down) { 
      // TODO: implement crouch 
      if (isOnGround) {
        imgName = "crouch";
        this.img = imgSet.get(imgName).getPImage();
         img.resize((int) size.x, (int) size.y);
      }
      //pos.y += dt;
    }

    // Left
    boolean left = Keyboard.isPressed(65);
    boolean right = Keyboard.isPressed(68);
    if (left != right) {
      acc.x = GameConstants.PLAYER_ACC * (right ? 1 : -1); 
      if (isOnGround && !up) {
        imgName = "run";
        this.img = imgSet.get(imgName).getPImage();
        img.resize((int) size.x, (int) size.y);
      }
    } else {
      acc.x = 0; //<>//
      if (isOnGround && !up && !down) {
        imgName = "idle";
        this.img = imgSet.get(imgName).getPImage();
        img.resize((int) size.x, (int) size.y);
      } //<>//
    }
  }

  void restrictVelocity() {
    vel.x = max(-GameConstants.PLAYER_MAX_SPEED_X, min(vel.x, GameConstants.PLAYER_MAX_SPEED_X));
    vel.y = min(GameConstants.GRAVITY_MAX_SPEED, vel.y);
  }

  void handleCollision(FullCollisionReport collision) { //<>//
    isOnGround = (collision.voteY < 0);
    if (collision.voteY > 0) {
      //if the collision is from under

      for (Map.Entry<Tile, CollisionData> me : collision.data.entrySet()) {
        Tile t = me.getKey();
        int posX = (int) t.pos.x / cellSize;
        int posY = (int) t.pos.y / cellSize;
        if (t instanceof SolidTile) {
        } else if (t instanceof BreakableTile) {
          game.level.tiles[posX][posY] = null;
          game.level.backgroundImages[posX][posY] = null;

          //have a preset block explosion coordinate and instance it at posX and posY
        } else if (t instanceof ContainerTile) {
          ContainerTile ti = (ContainerTile)t;
          game.level.backgroundImages[posX][posY] = CONTAINER_IMAGE_SET.get("end").getPImage();
          Item item = ti.item.copy();
          if (ti.n > 0) {
            item.pos.x = t.pos.x;
            item.pos.y = t.pos.y - 1*cellSize;
            --ti.n;
            game.items.add(item);
          }
        } //<>// //<>//
      }
    }
  }

  void handleEnemyCollisions() {
    
    for (Enemy enemy : game.enemies) {
      CollisionData data = enemy.getCollisionData(this);
      if (data == null) continue;

      if (invincibility > 0) {
        enemy.alive = false;
        game.score += GameConstants.SCORE_KILL_ENEMY;
        continue;
      }

      if (enemy instanceof Koopa && ((Koopa)enemy).inShell && ((Koopa)enemy).shellDirection == 0) {
        koopaInvincibility = GameConstants.KOOPA_KICK_INVINCIBILITY;
        ((Koopa)enemy).shellDirection = (data.direction[DIR_LEFT] ? 1 : -1);
        game.score += GameConstants.SCORE_KILL_ENEMY;
        continue;
      }

      if (data.direction[DIR_DOWN] || !data.direction[DIR_UP] || abs((float)data.p[0]) < abs((float)data.p[1])) {
        if (enemy instanceof Koopa && koopaInvincibility > 0) continue;
        if (invincibility < 0) continue;
        // Kill player
        println("player hit");
        if (state.onHit == null) {
          imgName = "dead";
          this.img = imgSet.get(imgName).getPImage();
          img.resize((int) size.x, (int) size.y);
          game.play = false;
        } else {
          setMarioState(state.onHit);
          invincibility = -fps*3;
        }
      } else {
        // Kill enemy
        if (enemy instanceof Koopa) {
          Koopa koopa = (Koopa) enemy;
          if (!koopa.inShell) {
            koopa.setInShell();
            game.score += GameConstants.SCORE_KILL_ENEMY;
          } else if (koopa.shellDirection != 0) {
            koopa.shellDirection = 0;
          }
        } else if (enemy instanceof Goomba) {
           GoombaDeathAnimation gda = new GoombaDeathAnimation(enemy.pos);
           game.animations.add(gda);
           enemy.alive = false;
           game.score += GameConstants.SCORE_KILL_ENEMY;
         }

        this.pos.y = floor(this.pos.y);
        this.vel.y = GameConstants.SMASH_JUMP;
      }
    }
  }
  
  void handleItemCollisions() {
    for (Item item : game.items) {
      if (item.getCollisionData(this) == null) continue;
      
      item.consumed = true;
      
      // TODO: add score
      if (item instanceof Mushroom) {
        println("Mario big");
        game.score += GameConstants.SCORE_GROW;
        if (game.player.state == MarioState.SMALL) {
          game.player.setMarioState(MarioState.BIG);
        }
        
        continue;
      }
      
      if (item instanceof OneUp) {
        println("one up!");
        game.score += GameConstants.SCORE_ONE_UP;
        continue;
      }
      
      if (item instanceof Flower) {
        println("flower");
        game.score += GameConstants.SCORE_GROW;
        game.player.setMarioState(MarioState.FLOWER);
        continue;
      }
      
      if (item instanceof Star) {
        println("star");
        game.player.invincibility = fps * 5;
        continue;
      }
      
      println("Unknown item " + item);
    }
  }

  void setMarioState(MarioState newState) {
    if (newState == null || state == newState) return;

    this.imgSet = newState.imageSet;
    this.img = imgSet.get(imgName).getPImage();

    // Check if going from small to big
    if (state == MarioState.SMALL) {
      this.pos.y -= cellSize;
      this.size.y = 2*cellSize;
      println("from small to big");
    }

    // Check if going from big to small
    else if (newState == MarioState.SMALL) {
      this.pos.y += cellSize;
      this.size.y = cellSize;
      println("from big to small");
    }

    this.state = newState;
    this.img.resize((int) size.x, (int) size.y);
  }

  //<>// //<>// //<>//
  boolean valid() { 
    return alive;
  }
  void draw() {
    if (invincibility < 0) tint(255, 180);
    if (invincibility > 0) updateStarImage(); 
    super.draw();
    if (invincibility < 0) tint(255, 255);
  }
  
  void updateStarImage() {
    int index = (invincibility * 2) % 4;
    if (state == MarioState.SMALL) {
      this.img = smallStarMarioSet[index].get(imgName).getPImage();
      img.resize((int)size.x, (int)size.y);
    } else {
      this.img = bigStarMarioSet[index].get(imgName).getPImage();
      img.resize((int)size.x, (int)size.y);
    }
  }
}   
