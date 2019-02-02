import java.util.Iterator;

class Game{
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
    
  Game(){
    window = new Window();
    init();
  }
  
  void init(){    
    
    // clear all
    items.clear();
    enemies.clear();
    animations.clear();
    obstacles.clear();
    activeTriggers.clear();
    
    // load level
    level.load("data/levels/lvl1-1/lvl.txt");  
    activeTriggers = level.copyTriggersArray();
        
    window.setSize(20,20);
    // TODO(step1): position window
    
    player = new Player();
    //TODO(step1): position and size player
    
    play = true;
    time = 0;
  }

  
  void step(){
    //TODO(step1): skip this if "play" is false
           
    // step all
    player.step(dt);    
    for(Enemy enemy : enemies) enemy.step(dt);
    for(Item item : items) item.step(dt);
    for(Body obstacle : obstacles) obstacle.step(dt);
    for(Animation anim : animations) anim.step(dt);
    
    // check triggers
    for(Iterator<Trigger> it = activeTriggers.iterator(); it.hasNext();) {
      Trigger trigger = it.next();
      if(trigger.triggered())
        trigger.activate();
    }
    
    // cleanup
    for(Iterator<Enemy> it = enemies.iterator(); it.hasNext();)
      if(!(it.next()).valid()) it.remove();
    for(Iterator<Item> it = items.iterator(); it.hasNext();)
      if(!(it.next()).valid()) it.remove();
    for(Iterator<Body> it = obstacles.iterator(); it.hasNext();)
      if(!(it.next()).valid()) it.remove();
    for(Iterator<Animation> it = animations.iterator(); it.hasNext();)
      if(it.next().completed()) it.remove();
    for(Iterator<Trigger> it = activeTriggers.iterator(); it.hasNext();)
      if(it.next().completed()) it.remove();
        
    time += dt;
  }

  void draw(){
    
    //TODO(step1): replace this with a checkerboard pattern and a "plus" sign at the origin
    background(255,0,0);
    fill(255,255,0);
    ellipse(10,10,19,19);
    fill(0,0,0);
    strokeWeight(0.2);
    stroke(0,0,0);    
    fill(255,255,255);
    ellipse(6,14,4,4);    
    fill(0,0,255);
    ellipse(6,14,2,2);
    fill(0,0,0);
    rect(12,13.5,4,1);    
    fill(255,255,255);
    arc(10,9,12,12,PI,2*PI,CHORD);
    
    //TODO(step1): draw the player.
    
  }
  
}
