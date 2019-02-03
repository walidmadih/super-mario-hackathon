final static int cellSize = 2*16; // in pixels, use multiples of 16
int fps = 50;
static double finalTilePos = 16 * cellSize;
double initialTilePos = 0;
double lastPos;
double pos;
double deltaPos;

ImageSet CONTAINER_IMAGE_SET;


// global variables
Drawer drawer = new Drawer();
Resources resources = new Resources();
Game game = new Game();

  boolean upPressed, downPressed, leftPressed, rightPressed;


// Processing calls this only once at the beggining of the program.
void setup() {
  noSmooth(); // to get the blocky aspect
  frameRate(fps);
  CONTAINER_IMAGE_SET = new ImageSet("data/img/tiles/imageSet1");
  CONTAINER_IMAGE_SET.get("begin").speed = 0.3;
  game.init();
}

// Processing runs this every frame.
void draw() {
  game.step();
  double pos = game.player.pos.x;
  if(lastPos != 0 && finalTilePos < 211 * cellSize ){
    if(pos > finalTilePos - 3 * cellSize){
     deltaPos = pos - lastPos;
     finalTilePos = finalTilePos + deltaPos;
     initialTilePos = initialTilePos + deltaPos;
    }
  }
  pushMatrix();
    //scale(-2 , -2);
    translate(-(float)initialTilePos, cellSize * 6);  
    
    game.draw();
  popMatrix();
  lastPos = pos;
}

void onKeyPress(int keyCode) {
}

void onKeyRelease(int keyCode) {
}

// mouse arguments x and y given in tile units, relative to window (not relative to absolute world).
void onMouseMove(float x, float y) {
}

void onMousePress(float x, float y) {
}

void onMouseRelease(float x, float y) {
}
