
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
  
}



//// **************** Solid tile *********************
class SolidTile extends Tile{
  SolidTile() {}
  SolidTile(SolidTile o){ super(o); }
  SolidTile copy(){ return new SolidTile(this); }
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