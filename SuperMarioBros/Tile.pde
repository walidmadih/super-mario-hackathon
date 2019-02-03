
// ***************** Tile base class ********************

class Tile extends Body{
    
  Tile() {
    this.size = new Vec2(cellSize, cellSize);
  }
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
