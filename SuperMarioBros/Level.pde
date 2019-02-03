class CellContent {
  Tile tile = null;
  PImage background = null;
  Item item = null;
}

class Level {
  Color backgroundColor = new Color(92, 148, 252);
  PImage[][] backgroundImages = new PImage[0][0];
  Tile[][] tiles = new Tile[0][0];
  Item[][] staticItems = new Item[0][0];
  ArrayList<Trigger> triggers = new ArrayList<Trigger>(); 

  Level() {
  }

  // dimensions in tiles.
  int width() { 
    return tiles.length;
  }
  int height() { 
    return tiles[0].length;
  }

  PImage getBackgroundImage(int i, int j) { 
    return (i < 0 || i >= width() || j < 0 || j >= height())? null : backgroundImages[i][j];
  }  
  Tile getTile(int i, int j) { 
    return (i < 0 || i >= width() || j < 0 || j >= height())? null : tiles[i][j];
  }
  Item getStaticItem(int i, int j) { 
    return (i < 0 || i >= width() || j < 0 || j >= height())? null : staticItems[i][j];
  }


  void drawBackgroundImages() {
    fill(backgroundColor.r, backgroundColor.g, backgroundColor.b);
    rect(0 , -6*cellSize, width * 100, height * 100);
    
    for(int i = 0; i < width() ; i++) {
      for(int j = 0; j < height(); j++) {
        PImage bi = backgroundImages[i][j];
        if (bi != null)
           image(bi, cellSize * i, cellSize * j, cellSize, cellSize);
      }
    }
  }
  void drawTiles() {
  }
  void drawItems() {
  }

  // ***** LOADING FUNCTIONS *****
  void load(String file) {

    //TODO(step3): uncomment this

    // read lvl.txt
    String path = (file.lastIndexOf("/") >= 0)? file.substring(0, file.lastIndexOf("/")+1) : ""; 
    String mapFile = null, cellPropertiesFile = null, triggerFile = null;
    String[] lines = loadStrings(file);
    HashMap<String, String> properties = new HashMap<String, String>();
    for (String line : lines) {

      // tokenize
      String[] tokens = line.split(" ");
      for (int iToken = 0; iToken < tokens.length; iToken++) {      
        String[] tokenParts = tokens[iToken].split("=");
        String name = tokenParts[0];
        String value = tokenParts[1];
        properties.put(name, value);
      }

      if (properties.get("property").equals("background")) { 
        backgroundColor.set(int(properties.get("r")), int(properties.get("g")), int(properties.get("b")));
      }
      if (properties.get("property").equals("map")) { 
        mapFile = path+properties.get("file");
      }
      if (properties.get("property").equals("cellProperties")) { 
        cellPropertiesFile = path+properties.get("file");
      }
      if (properties.get("property").equals("triggers")) { 
        triggerFile = path+properties.get("file");
      }
    }

    triggers = loadTriggers(triggerFile);    
    char[][] map = loadMap(mapFile);
    HashMap<Character, CellContent> tileProperties = loadTileProperties(cellPropertiesFile);


    final int w = map.length, h = map[0].length;
    backgroundImages = new PImage[w][h];
    tiles = new Tile[w][h];
    staticItems = new Item[w][h];

    // creates the tile array based on the read symbols and their properties.
    for (int i = 0; i < w; ++i) {
      for (int j = 0; j < h; ++j) {        
        backgroundImages[i][j] = tileProperties.get(map[i][j]).background;
        tiles[i][j] = tileProperties.get(map[i][j]).tile;
        if (tiles[i][j] != null) {
          tiles[i][j] = tiles[i][j].copy();
          tiles[i][j].pos.set(i*cellSize, j*cellSize);
        }
        staticItems[i][j] = tileProperties.get(map[i][j]).item;
        if (staticItems[i][j] != null) {
          staticItems[i][j] = staticItems[i][j].copy();
          staticItems[i][j].pos.set(i*cellSize, j*cellSize);
        }
      }
    }
  }

  private char[][] loadMap(String file) {
    String[] lines = loadStrings(file);
    int w = lines[0].length(), h = lines.length;
    char[][] map = new char[w][h];

    for(int i = 0; i < h; i++) {
      for(int j = 0; j < w; j++) {
        map[j][i] = lines[i].charAt(j);
      }
    }

    return map;
  }


  private HashMap<Character, CellContent> loadTileProperties(String file) {
    HashMap<Character, CellContent> tileProperties = new HashMap<Character, CellContent>();
    String[] lines = loadStrings(file);
    CellContent currentCellContent = null;
    char index = (char)-1;
    for (int i = 0; i < lines.length; ++i) {
      String line = lines[i];
      String[] tokens = line.split(" ");
      if (tokens[0].length() == 0 || tokens[0].charAt(0) == '%') continue;
      if (tokens[0].length() == 1) {
        index = tokens[0].charAt(0);
        currentCellContent = new CellContent();
        tileProperties.put(index, currentCellContent);
      } else {

        HashMap<String, String> properties = new HashMap<String, String>();
        for (int iToken = 0; iToken < tokens.length; iToken++) {
          String[] tokenParts = tokens[iToken].split("=");
          String name = tokenParts[0];
          String value = tokenParts[1];
          properties.put(name, value);
        }



        if (properties.get("property").equals("background")) {
          String imageUrl = properties.get("image");
          tileProperties.get(index).background = loadImage(imageUrl);
        } else if (properties.get("property").equals("tile")) { 
          String imageUrl = properties.get("image");
          tileProperties.get(index).background = loadImage(imageUrl);
          if (properties.get("type").equals("solid")) {
            tileProperties.get(index).tile = new SolidTile();
          } else if (properties.get("type").equals("breakable")) {
            tileProperties.get(index).tile = new BreakableTile();
          } else if (properties.get("type").equals("container")) {
            tileProperties.get(index).tile = new ContainerTile();
          }
        } else if (properties.get("property").equals("item")) {
          //TODO(step7)
        }
      }
    }
    return tileProperties;
  } 

  private ArrayList<Trigger> loadTriggers(String file) {
    ArrayList<Trigger> triggers = new ArrayList<Trigger>();
    String[] lines = loadStrings(file);
    for (String line : lines) {

      // read trigger properties
      String[] tokens = line.split(" ");
      if (tokens[0].length() == 0 || tokens[0].charAt(0) == '%') continue;
      HashMap<String, String> properties = new HashMap<String, String>();
      for (int iToken = 0; iToken < tokens.length; iToken++) {
        String[] tokenParts = tokens[iToken].split("=");
        String name = tokenParts[0];
        String value = tokenParts[1];
        properties.put(name, value);
      }
      
      int enemyX = Integer.parseInt(properties.get("x"));
      int enemyY = Integer.parseInt(properties.get("y"));      
      
      if(properties.get("type").equals("goomba")) {
        Goomba goomba = new Goomba(enemyX, enemyY);
        EnemyTrigger  goombaTrigger = new EnemyTrigger();
        goombaTrigger.enemy = goomba;
        triggers.add(goombaTrigger);
      } else{
        Koopa koopa = new Koopa(enemyX, enemyY);
        EnemyTrigger  koopaTrigger = new EnemyTrigger();
        koopaTrigger.enemy = koopa;
        triggers.add(koopaTrigger);
      }
      

      
    }
    return triggers;
  }

  ArrayList<Trigger> copyTriggersArray() {
    ArrayList<Trigger> result = new ArrayList<Trigger>();
    for (Trigger trig : triggers) {
      result.add(trig);
    }
    return result;
  }
}
