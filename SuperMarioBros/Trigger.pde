interface Trigger{
  boolean triggered();
  void activate();
  boolean completed();
}


class EnemyTrigger implements Trigger{
  Enemy enemy;
  boolean completed = false;
    
  boolean triggered() {return false;}
  void activate() {}
  boolean completed() {return false;}
}