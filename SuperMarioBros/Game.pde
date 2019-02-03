import java.util.Iterator;

class Game {
  Level level = new Level();
  float time;
  float dt = 1;
  boolean play;
  Window window;
  Player player;
  
  ArrayList<Item> items = new ArrayList<Item>();
  ArrayList<Enemy> enemies = new ArrayList<Enemy>();
  ArrayList<Animation> animations = new ArrayList<Animation>();
  ArrayList<Body> obstacles = new ArrayList<Body>();
  ArrayList<Trigger> activeTriggers = new ArrayList<Trigger>();

  Game() {
    
  }

  void init() {
    window = new Window();

    // clear all
    items.clear();
    enemies.clear();
    animations.clear();
    obstacles.clear();
    activeTriggers.clear();

    // load level
    level.load("data/levels/lvl1-1/lvl.txt");  
    activeTriggers = level.copyTriggersArray();

    window.setSize(20, 20);
    // TODO(step1): position window

    player = new Player();
    player.pos.set(0.5 * cellSize, 10 * cellSize);
    //TODO(step1): position and size player

    Enemy enemy = new Goomba(43*cellSize, 11*cellSize);
    enemies.add(enemy);

    play = true;
    time = 0;
  }


  void step() {
    //TODO(step1): skip this if "play" is false

    // step all
    player.step(dt);    
    for (Enemy enemy : enemies) enemy.step(dt);
    for (Item item : items) item.step(dt);
    for (Body obstacle : obstacles) obstacle.step(dt);
    for (Animation anim : animations) anim.step(dt);

    // check collisions
    player.handleBlockCollisions();
    for (Enemy enemy : enemies) enemy.handleBlockCollisions();

    // check triggers
    for (Iterator<Trigger> it = activeTriggers.iterator(); it.hasNext(); ) {
      Trigger trigger = it.next();
      if (trigger.triggered())
        trigger.activate();
    }

    // cleanup
    for (Iterator<Enemy> it = enemies.iterator(); it.hasNext(); )
      if (!(it.next()).valid()) it.remove();
    for (Iterator<Item> it = items.iterator(); it.hasNext(); )
      if (!(it.next()).valid()) it.remove();
    for (Iterator<Body> it = obstacles.iterator(); it.hasNext(); )
      if (!(it.next()).valid()) it.remove();
    for (Iterator<Animation> it = animations.iterator(); it.hasNext(); )
      if (it.next().completed()) it.remove();
    for (Iterator<Trigger> it = activeTriggers.iterator(); it.hasNext(); )
      if (it.next().completed()) it.remove();

    time += dt;
  }

  void draw() {

    //TODO(step1): replace this with a checkerboard pattern and a "plus" sign at the origin
    float hr = height / 14.0;
    float wr = width / 224.0;   
    int score = 000000;
    int lives = 03;
    int time = 400;
    level.drawBackgroundImages();
    
    for (Enemy enemy : enemies) {
      enemy.draw();
    }
    
    player.draw();   
    drawer.draw("MARIO", 10 + (float)initialTilePos, 160);
    drawer.draw(nf(score, 6), 10 + (float)initialTilePos, 140);
    drawer.draw("x"+ nf(lives, 2), 150 + (float)initialTilePos, 140); 
    drawer.draw("WORLD", 325 + (float)initialTilePos, 160);
    drawer.draw("1-1", 338 + (float)initialTilePos, 140);
    drawer.draw("TIME", 550 + (float)initialTilePos, 160);
    drawer.draw(nf(time, 3), 563 + (float)initialTilePos, 140);
    //TODO(step1): draw the player.
  } 
  

 
}
