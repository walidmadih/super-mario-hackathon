
// ***************** Tile base class ********************

class Tile extends Body{
    
  Tile() {}
  Tile(Tile o) { super(o); }
  Tile copy() {
    Tile tile = new Tile(this);
    return tile;
  }
  
  
  void interactWith(Enemy enemy){
  }
  void interactWith(Item item){
  }
  
  
  boolean valid(){ return true; }
  
  CollisionData getCollisionData(Body body) {
    double deltaX = this.pos.x - body.pos.x;
    double deltaY = this.pos.y - body.pos.y;
    double px1 = deltaX - body.size.x;
    double py1 = deltaY - body.size.y;
    double px2 = deltaX + this.size.x;
    double py2 = deltaY + this.size.y;
    
    if (px1 >= 0 || py1 >= 0 || px2 <=0 || py2 <=0){
     return null; 
    }
    
    double px = (abs((float)px1) > abs((float)px2))? -px2: -px1;
    double py = (abs((float)py1) > abs((float)py2))? -py2: -py1;
    double p[] = {px, py};
    
    boolean up = body.pos.y < this.pos.y;
    boolean down = body.pos.y + body.size.y > this.pos.y + this.size.y;
    boolean left = body.pos.x < this.pos.x;
    boolean right = body.pos.x + body.size.x > this.pos.x + this.size.x;
    boolean directions[] = {up, down, left, right};
    
    return new CollisionData(this, body, p, directions);
  }
  
  public boolean equals(Object o) {
     if (!(o instanceof Tile))
     return false;
     
     if (o == this) return true;
     
     final double epsilon = 0.001;
     Tile other = (Tile) o;
     return abs((float)(this.pos.x - other.pos.x)) <= epsilon
         && abs((float)(this.pos.y - other.pos.y)) <= epsilon;

   }
   
   public int hashCode() {
     int hash = 37;
     hash += 19 * hash + this.pos.x;
     hash += 19 * hash + this.pos.y;
     return hash;
   }
}



//// **************** Solid tile *********************
class SolidTile extends Tile{
  SolidTile() {}
  SolidTile(SolidTile o){ super(o); }
  SolidTile(int x, int y){
   this.pos = new Vec2(x*cellSize, y*cellSize);
   this.size = new Vec2(cellSize, cellSize);
  }
  SolidTile copy(){ return new SolidTile(this); }
  public void draw(){
    fill(0,0,0);
    strokeWeight(0);
    rect(this.pos.x, this.pos.y, this.size.x, this.size.y);

  }
}



//// ************* Breakable tile ********************

class BreakableTile extends Tile{
  boolean broken = false;
  ImageSet imgSet = null;
  
  BreakableTile() {}
  BreakableTile(BreakableTile o){ super(o); this.imgSet = o.imgSet; }
  BreakableTile copy(){ return new BreakableTile(this); }
    
}



//// ******************** Container tile ***********************

class ContainerTile extends Tile{
  Item item;
  int n = 1;
  ImageSet imgSet = null;
  
  ContainerTile() {}
  ContainerTile(ContainerTile o){
    super(o);
    item = o.item;
    imgSet = o.imgSet;
    n = o.n;
  }
  ContainerTile copy(){ return new ContainerTile(this); }

}
