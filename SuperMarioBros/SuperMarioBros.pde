
final int cellSize = 2*16; // in pixels, use multiples of 16
int fps = 50;

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
  pushMatrix();
    //scale(3.125 , 3.125);
    //translate(-19* 12.8,-19 * 12.8);  
    game.draw();
  popMatrix();
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
