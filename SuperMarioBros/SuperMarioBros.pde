final int cellSize = 2*16; // in pixels, use multiples of 16
int fps = 50;
double finalTilePos = 16 * cellSize;
double initialTilePos = 0;
double lastPos;
double pos;
double deltaPos;

// global variables
Drawer drawer = new Drawer();
Resources resources = new Resources();
Game game;

  boolean upPressed, downPressed, leftPressed, rightPressed;


// Processing calls this only once at the beggining of the program.
void setup() {
  noSmooth(); // to get the blocky aspect
  frameRate(fps);
  game = new Game();
}

// Processing runs this every frame.
void draw() {
  game.step();
  double pos = game.player.pos.x;
  if(lastPos != 0){
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
