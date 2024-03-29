import java.util.Map; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
class Player extends Body {

  ImageSet containerTileSet = new ImageSet("data/img/tiles/imageSet1");
  ImageSet brokenBlockSet = new ImageSet("data/img/tiles/imageSet4");
  ImageSet goombaSet = new ImageSet("data/img/enemies/goomba/brown");

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

  Vec2 prevPos;

  Player() {
    this.imgName = "idle";
    this.size = new Vec2(cellSize, cellSize);
    Image i = imgSet.get(imgName);
    i.speed = 0.6;
    this.img = i.getPImage();
    img.resize((int) size.x, (int) size.y);
  } //<>//

  void step(float dt) {
    if (koopaInvincibility > 0) --koopaInvincibility;
    if (invincibility > 0) --invincibility;
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
    
    pos.x = max((float)initialTilePos, pos.x);
  }

  void handleControls() {
    acc.y = GameConstants.GRAVITY;

    boolean up = Keyboard.isPressed(87);
    if (up && isOnGround) {
      imgName = "jump";
      vel.y = GameConstants.PLAYER_JUMP;
      Image i = imgSet.get(imgName);
      i.speed = 0.6;
      this.img = i.getPImage();
      img.resize((int) size.x, (int) size.y);
    }

    boolean down = Keyboard.isPressed(83);
    if (down) { 
      // TODO: implement crouch 
      if (isOnGround) {
        imgName = "crouch";
        Image i = imgSet.get(imgName);
        i.speed = 0.6;
        this.img = i.getPImage();
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
        Image i = imgSet.get(imgName);
    i.speed = 0.6;
    this.img = i.getPImage();
    img.resize((int) size.x, (int) size.y); //<>//
      }
    } else {
      acc.x = 0;
      if (isOnGround && !up && !down) {
        imgName = "idle";
        Image i = imgSet.get(imgName);
    i.speed = 0.6;
    this.img = i.getPImage();
    img.resize((int) size.x, (int) size.y);
      }
    }
  }

  void restrictVelocity() {
    vel.x = max(-GameConstants.PLAYER_MAX_SPEED_X, min(vel.x, GameConstants.PLAYER_MAX_SPEED_X));
    vel.y = min(GameConstants.GRAVITY_MAX_SPEED, vel.y);
  }

  void handleCollision(FullCollisionReport collision) {
    isOnGround = (collision.voteY < 0);
    if (pos.x > 199*cellSize) {game.play = false; return;}
    
    if (collision.voteY > 0) {
      //if the collision is from under

      for (Map.Entry<Tile, CollisionData> me : collision.data.entrySet()) {
        Tile t = me.getKey();
        int posX = (int) t.pos.x / cellSize;
        int posY = (int) t.pos.y / cellSize;
        for (Enemy e : game.enemies) {
          if (e.alive && abs(e.pos.x - t.pos.x) < cellSize && abs(e.pos.y - t.pos.y + 1) <= cellSize) {
            e.alive = false;
            game.animations.add(new ParticleAnimation(t.pos.copy(), new Vec2(3, -20), goombaSet.get("dead"), cellSize, cellSize));
          }
        }
        if (t instanceof SolidTile) {
        } else if (t instanceof BreakableTile) {
          if (state == MarioState.SMALL) {
            println("bump");
            Animation anim = new BlockBumpAnimation(t.pos, game.level.backgroundImages[posX][posY]);
            game.blockBumps.put(t, anim);
            game.animations.add(anim);
          } else {
            game.level.tiles[posX][posY] = null;
            game.level.backgroundImages[posX][posY] = null;
  
            Image left = brokenBlockSet.get("pieceLeft");
            Image right = brokenBlockSet.get("pieceRight");
            int brokenSize = cellSize/4;
            game.animations.add(new ParticleAnimation(t.pos.copy().add(0, cellSize / 2.0), new Vec2(-2, -8), left, brokenSize, brokenSize));
            game.animations.add(new ParticleAnimation(t.pos.copy().add(cellSize, cellSize / 2.0), new Vec2(2, -8), right, brokenSize, brokenSize));
            game.animations.add(new ParticleAnimation(t.pos.copy().add(0, cellSize / 2.0 - cellSize), new Vec2(-2, -8), left, brokenSize, brokenSize));
                      game.animations.add(new ParticleAnimation(t.pos.copy().add(cellSize, cellSize / 2.0 - cellSize), new Vec2(2, -8), right, brokenSize, brokenSize));

          }
          
        } else if (t instanceof ContainerTile) {
          ContainerTile ti = (ContainerTile)t;
          game.level.backgroundImages[posX][posY] = CONTAINER_IMAGE_SET.get("end").getPImage();
          Item item = ti.item.copy();
          if (ti.n > 0) {
            if (ti.item instanceof Coin) {
              ImageSet imgSet = new ImageSet("data/img/items/coin");
              Image imgTemp = imgSet.get("bounce");
              imgTemp.speed = 0.6;
              game.score += 10;
              
              game.animations.add(new CoinAnimation(new Vec2(ti.pos.x, ti.pos.y), new Vec2(0, -20), imgTemp , cellSize, cellSize));
              
              --ti.n;
            } else {
              item.pos.x = t.pos.x;
              item.pos.y = t.pos.y - 1*cellSize;
              --ti.n;
              game.items.add(item);
            }
          }
        }
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


      Vec2 diff = this.pos.copy().sub(enemy.pos);
      if (state != MarioState.SMALL) diff.add(0, cellSize);
      if (enemy.size.y > cellSize) diff.sub(0, cellSize);

      if (data.direction[DIR_DOWN] || !data.direction[DIR_UP] || diff.y >= 0) {
        if (enemy instanceof Koopa && koopaInvincibility > 0) continue;
        if (invincibility < 0) continue;
        // Kill player
        println("player hit");
        if (state.onHit == null) {
          imgName = "dead";
          Image i = imgSet.get(imgName);
    i.speed = 0.6;
    this.img = i.getPImage();
    img.resize((int) size.x, (int) size.y);
          game.play = false;
        } else {
          setMarioState(state.onHit);
          invincibility = -fps;
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
    Image i = imgSet.get(imgName);
    i.speed = 0.6;
        this.img = i.getPImage();
        img.resize((int) size.x, (int) size.y);


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

  //<>// //<>//
  boolean valid() { 
    return alive;
  }
  void draw() {
    if (invincibility < 0) tint(255, 180);
    if (invincibility > 0) updateStarImage(); 
    if (vel.x < 0){
      scale(-1, 1);
      image(this.img, -this.size.x-this.pos.x, this.pos.y);
      scale(-1, 1);
    } else {
      super.draw();
    }
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
