void absorbGreenMushroom() {
  
}

void absorbGrowMushroom() {
  
}

void absorbFlower() {
  
}

void absorbStar() {
  
}

enum MarioState {
  
  SMALL("data/img/players/mariosmall"),
  BIG("data/img/players/mariobig"),
  FLOWER("data/img/players/mariobigflower");
  
  private MarioState(String imgset) {
    this.imgsetUrl = imgset;
  }
  
  MarioState onHit;
  String imgsetUrl;
  ImageSet imageSet;
  
  void init(MarioState onHit, SuperMarioBros bros) {
    this.onHit = onHit;
    this.imageSet = bros.new ImageSet(imgsetUrl);
  }
}

enum Direction{
  UP, DOWN, LEFT, RIGHT, NONE
}

class Vec2{
  float x, y;
  Vec2(){ x=y=0; }
  Vec2(float xy){ x=y=xy; }
  Vec2(float x, float y){ this.x=x; this.y=y; }
  Vec2(Vec2 o){ this.x=o.x; this.y=o.y; }
  Vec2 copy(){ return new Vec2(this); }  
  Vec2 set(Vec2 o){ x=o.x; y=o.y; return this; }
  Vec2 set(float xy){ x=y=xy; return this; }
  Vec2 set(float x, float y){ this.x=x; this.y=y; return this; }
  Vec2 add(Vec2 o){ x+=o.x; y+=o.y; return this; }
  Vec2 add(float x, float y){ this.x+=x; this.y+=y; return this; }
  Vec2 sub(Vec2 o){ x-=o.x; y-=o.y; return this; }
  Vec2 sub(float x, float y){ this.x-=x; this.y-=y; return this; }
  Vec2 mult(Vec2 o){ x*=o.x; y*=o.y; return this; }
  Vec2 mult(float v){ x*=v; y*=v; return this; }
  Vec2 mult(float vx, float vy){ x*=vx; y*=vy; return this; }
  Vec2 div(Vec2 o){ x/=o.x; y/=o.y; return this; }
  Vec2 div(float v){ x/=v; y/=v; return this; }
  float lengthSqr(){ return x*x+y*y; }
  float length(){ return (float)Math.sqrt(x*x+y*y); }
  Vec2 normalize(){ return div(length()); }
  float dot(Vec2 o){ return x*o.x+y*o.y; }
  Vec2 clamp(float min, float max){ 
    if(x<min) x=min; 
    else if(x>max) x=max;
    if(y<min) y=min; 
    else if(y>max) y=max;
    return this; 
  }
  boolean isNull(){ return x==0 && y==0; }
  @Override
  String toString() {
    return "Vec2(" + x + ", " + y + ")";
  }
}

//**** misc *****
float clamp(float x, float a, float b) {
  return min(max(x,a),b);
}

class Color{
  char r, g, b;
  Color(){ set(0); }
  Color(int v){ set(v); }
  Color(int r, int g, int b){ set(r,g,b); }
  void set(int v){ set(v,v,v); }
  void set(int r, int g, int b){
    this.r = (char) r;
    this.g = (char) g;
    this.b = (char) b;
  }
}


//**** keyboard ****
import java.util.HashSet;
enum KeyState{ PRESSED, RELEASED };
static class Keyboard{
  static HashSet<Integer> keys = new HashSet<Integer>();
  static boolean isPressed(int keyCode){ return keys.contains(keyCode); }
  static boolean isReleased(int keyCode){ return !isPressed(keyCode); }
}

void keyPressed() {
  if(Keyboard.isPressed(keyCode)) return;
  Keyboard.keys.add(keyCode);
  onKeyPress(keyCode);
}
void keyReleased() {
  Keyboard.keys.remove(keyCode);
  onKeyRelease(keyCode);
}


// ***************** Drawer class ****************
//  contains utilitary drawing functions

enum Shape{ RECTANGLE, ELLIPSE };
final char CROSS = '+';

class Drawer{
  float fontSize = 16;
  
  // **** Shape ****
  void draw(Shape shape, float x, float y, float sx, float sy){ // rectangle
    if(shape == Shape.RECTANGLE)
       rect(x*cellSize, (game.level.height()-y-sy)*cellSize, sx*cellSize, sy*cellSize);
    else if(shape == Shape.ELLIPSE)
       ellipse((x+sx/2)*cellSize, (game.level.height()-(y-sy/2)-sy)*cellSize, sx*cellSize, sy*cellSize);
  }
  
  // **** Images and PImages ****
  void draw(PImage img, float x, float y, boolean flipX, boolean flipY){
    if(img != null){
      pushMatrix();
      //translate(x*tileSize,(game.level.height()-y)*tileSize-img.height);
      //translate(x,(game.level.height()-y)-img.height/16);
      translate(x,y+img.height/16.0);
      scale(flipX? -1.0/(16.0) : 1.0/(16.0), flipY? 1.0/(16.0) : -1.0/(16.0));
      image(img, flipX? -img.width : 0, flipY? -img.height : 0);
      popMatrix();
    }
  }
  void draw(PImage img, float x, float y, boolean flipX){ draw(img,x,y,flipX,false); }
  void draw(PImage img, float x, float y){ draw(img,x,y,false,false); }
  void draw(Image img, float x, float y, boolean flipX, boolean flipY){ draw(img==null? null : img.getPImage(), x, y, flipX, flipY); }
  void draw(Image img, float x, float y, boolean flipX){ draw(img,x,y,flipX,false); }
  void draw(Image img, float x, float y){ draw(img,x,y,false,false); }
  
  // **** Strings and chars ****
  void draw(char c, float x, float y){ // char
    int pos = 0;
    int w = 8; // char width in pixel (in image img/font.png)
    if('0' <= c && c <= '9') {
      pos = w*(c - '0');
    } else if('A' <= c && c <= 'Z') {
      pos = w*(c - 'A' + 10);
    } else if(c == '-') {
      pos = w*36;
    } else if(c == 'x') {
      pos = w*37;
    } else {
      pos = w*39;
    }
    PImage img = resources.getSprite("data/img/font.png").get(pos,0,w,w);
    img.resize(0, 250);
    draw(img, x, y);
  }
  void draw(String str, float x, float y){ // String
    pushMatrix();
    scale(1, -1);
    for(int i = 0; i < str.length(); ++i)
      draw(str.charAt(i), x+fontSize*i, y);
    popMatrix();
  }
}



class Image{
  float timecursor = 0, imgcursor = 0, speed = 0.1;
  ArrayList<PImage> images = new ArrayList<PImage>();
  Image(PImage img){ images.add(img); }
  Image(ArrayList<PImage> imgs){ for(PImage img : imgs) images.add(img); }
  Image(ArrayList<PImage> imgs, float speed){ this(imgs); this.speed = speed; }
  Image(Image o){
    imgcursor = o.imgcursor;
    timecursor = o.timecursor;
    speed = o.speed;
    for(PImage img : o.images) images.add(img);
  }
  Image copy(){ return new Image(this); }
  
  void reset(){
    timecursor = game.time;
    imgcursor = 0;
  }
  
  PImage getPImage(){
    if(images.size()==0) return null;
    if(images.size()==1) return images.get(0);
    imgcursor += speed*(game.time-timecursor); 
    timecursor = game.time;
    return images.get(floor(imgcursor) % images.size());
  }
  void setSpeed(float speed){ this.speed = speed; }
}

class ImageSet{
  String path;
  HashMap<String, Image> map = new HashMap<String, Image>(11); // small hashmap should be sufficient
  ImageSet(String path){
    this.path = path;
    if(path.charAt(path.length()-1) != '/') path += "/";
    File dir = new File(sketchPath(path));
    String[] list = dir.list();
    if (list == null) { println("Error: No images found in path \""+path+"\""); return; }
    list = sort(list);
    String lastState = null;
    for(int i = 0; i < list.length; ++i){
      String file = list[i];
      String name = file.substring(0, file.lastIndexOf("."));
      String ext = file.substring(file.lastIndexOf("."));
      String state = name.replaceAll("[0-9]","");
      if(state.equals(lastState)) continue;
      lastState = state;
      Image image = (state.equals(name))? resources.getImage(path+file) : resources.getImage(path+state+"%d"+ext);
      if(image == null){ println("Error: Could not load image \""+path+file+"\""); continue; }
      map.put(state, image);
    }
  }
  Image get(){ 
    for(HashMap.Entry entry : map.entrySet()) 
      return (Image)entry.getValue(); 
    return null;  
  }
  Image get(String state){
    Image img = map.get(state);
    if(img == null) {
      println("Warning: ImageSet at path \""+path+"\" doesn't contain such state \""+state+"\"");
      return resources.getImage("data/img/notfound.png");
    }
    return img;
  }
}







// ensures that there exists only one copy of each PImage (singleton)
public class Resources{
  HashMap<String, PImage> sprites = new HashMap<String, PImage>();
  HashMap<String, Image> images = new HashMap<String, Image>();
  
  PImage getSprite(String filename){
    if(sprites.get(filename) == null){
      if(!(new File(sketchPath(filename))).exists()){ return null; }
      sprites.put(filename, loadImage(filename));
    }
    return sprites.get(filename);
  }
  Image getImage(String filename){
    if(filename==null) {
      return getImage("data/img/notfound.png");
    } else {
      if(images.get(filename) == null) {
        if(filename.indexOf("%") == -1){ // static
          images.put(filename, new Image(getSprite(filename)));
        }else{ // animated
          ArrayList<PImage> imgs = new ArrayList<PImage>();
          PImage img;
          int i = 1;
          while((img = getSprite(filename.replace("%d", ""+(i++)))) != null)
            imgs.add(img);
          images.put(filename, new Image(imgs));
        }
      }
      if(images.get(filename).images.size() > 0) {
        return images.get(filename).copy();
      } else {
        return getImage("data/img/notfound.png");
      }
    }    
  }
  Image getImage(String filename, float speed){
    Image anim = getImage(filename);
    anim.speed = speed;
    return anim;
  }
}





class Window {
  Vec2 bottomLeft = new Vec2(0,0);
   
  void setSize(float inWidth, float inHeight) { surface.setSize((int)inWidth*cellSize, (int)inHeight*cellSize); }  
  int width() {return (int)(width/cellSize);}
  int height() {return (int)(height/cellSize);}
    
  void setLeft(float left) { bottomLeft = new Vec2(left, bottomLeft.y); }
  void setBottom(float bottom) { bottomLeft = new Vec2(bottomLeft.x, bottom); }    
    
  float left()   { return bottomLeft.x; }
  float right()  { return bottomLeft.x + width();  }
  float bottom() { return bottomLeft.y; }
  float top()    { return bottomLeft.y + height(); }
  
  void setBottomLeft(Vec2 inBottomLeft) {bottomLeft = inBottomLeft;}
  void translateBy(Vec2 vec) {setBottomLeft(bottomLeft.add(vec));}
}





void mouseMoved() {
  onMouseMove(mouseX/(float)cellSize, game.window.height() - (mouseY+1)/(float)cellSize);
}

void mousePressed() {
  onMousePress(mouseX/(float)cellSize, game.window.height() - (mouseY+1)/(float)cellSize);
}

void mouseReleased() {
  onMouseRelease(mouseX/(float)cellSize, game.window.height() - (mouseY+1)/(float)cellSize);
}
