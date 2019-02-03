final int DIR_UP = 0;
final int DIR_DOWN = 1;
final int DIR_LEFT = 2;
final int DIR_RIGHT = 3;


class CollisionData {
  Body with, self;
  double p[];
  boolean direction[];
  
  CollisionData(Body self, Body with, double[] p, boolean[] direction) {
    this.self = self;
    this.with = with;
    this.p = p;
    this.direction = direction;
  }
  
  int voteX() {
     if (direction[DIR_LEFT] == direction[DIR_RIGHT])
       return 0;
     
     if (direction[DIR_LEFT])
       return -1;
      
      // right
      return 1;
  }
  
  int voteY() {
     if (direction[DIR_UP] == direction[DIR_DOWN])
       return 0;
     
     if (direction[DIR_UP])
       return -1;
      
      // down
      return 1;
  }
  
  public String toString() {
     return String.format("Collision{%.2f %.2f ; %b %b %b %b}", p[0], p[1], direction[0], direction[1], direction[2] ,direction[3]); 
  }
}

class FullCollisionReport {
  int collisionCount;
  int voteX, voteY;
  CollisionData data;
  
  FullCollisionReport(int count, int vx, int vy, CollisionData data) {
    this.collisionCount = count;
    this.voteX = vx;
    this.voteY = vy;
    this.data = data;
  }
}
